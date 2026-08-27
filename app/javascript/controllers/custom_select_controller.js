import { Controller } from "@hotwired/stimulus"

// Replaces the unstyleable OS option menu with a keyboard-accessible listbox.
// The native select remains the source of truth and receives every selection.
export default class extends Controller {
  static targets = ["select", "trigger", "value", "menu", "error"]

  connect() {
    this.wasRequired = this.selectTarget.required
    this.selectTarget.required = false
    this.selectTarget.hidden = true
    this.triggerTarget.hidden = false
    this.element.classList.add("custom-select--enhanced")

    this.menuId = this.menuTarget.id || `custom-select-${crypto.randomUUID()}`
    this.menuTarget.id = this.menuId
    this.triggerTarget.setAttribute("aria-controls", this.menuId)
    this.triggerTarget.setAttribute("aria-label", this.selectTarget.getAttribute("aria-label") || "Choose an option")

    this.boundOutsideClick = this.handleOutsideClick.bind(this)
    this.boundSubmit = this.validateBeforeSubmit.bind(this)
    document.addEventListener("pointerdown", this.boundOutsideClick)
    this.form = this.element.closest("form")
    this.form?.addEventListener("submit", this.boundSubmit)

    this.buildOptions()
    this.syncFromSelect()
  }

  disconnect() {
    document.removeEventListener("pointerdown", this.boundOutsideClick)
    this.form?.removeEventListener("submit", this.boundSubmit)
    this.selectTarget.required = this.wasRequired
    this.selectTarget.hidden = false
  }

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.hidden ? this.open() : this.closePopover()
  }

  open() {
    this.menuTarget.hidden = false
    this.triggerTarget.setAttribute("aria-expanded", "true")
    this.element.classList.add("custom-select--open")

    requestAnimationFrame(() => {
      const selected = this.menuTarget.querySelector('[aria-selected="true"]')
      ;(selected || this.menuTarget.querySelector(".custom-select__option"))?.focus()
    })
  }

  closePopover(returnFocus = false) {
    this.menuTarget.hidden = true
    this.triggerTarget.setAttribute("aria-expanded", "false")
    this.element.classList.remove("custom-select--open")
    if (returnFocus) this.triggerTarget.focus()
  }

  choose(event) {
    const value = event.currentTarget.dataset.value
    this.selectTarget.value = value
    this.syncFromSelect()
    this.closePopover(true)
    this.clearError()

    this.selectTarget.dispatchEvent(new Event("input", { bubbles: true }))
    this.selectTarget.dispatchEvent(new Event("change", { bubbles: true }))
  }

  handleTriggerKeydown(event) {
    if (["ArrowDown", "ArrowUp", "Enter", " "].includes(event.key)) {
      event.preventDefault()
      this.open()
    }
  }

  handleMenuKeydown(event) {
    const options = Array.from(this.menuTarget.querySelectorAll(".custom-select__option"))
    const currentIndex = options.indexOf(event.target.closest(".custom-select__option"))

    if (event.key === "Escape") {
      event.preventDefault()
      this.closePopover(true)
      return
    }

    if (event.key === "Tab") {
      this.closePopover()
      return
    }

    const destinations = {
      ArrowDown: Math.min(currentIndex + 1, options.length - 1),
      ArrowUp: Math.max(currentIndex - 1, 0),
      Home: 0,
      End: options.length - 1
    }
    const destination = destinations[event.key]
    if (destination === undefined) return

    event.preventDefault()
    options[destination]?.focus()
  }

  handleOutsideClick(event) {
    if (!this.menuTarget.hidden && !this.element.contains(event.target)) this.closePopover()
  }

  validateBeforeSubmit(event) {
    if (!this.wasRequired || this.selectTarget.value) return

    event.preventDefault()
    this.triggerTarget.setAttribute("aria-invalid", "true")
    this.triggerTarget.classList.add("is-invalid")
    if (this.hasErrorTarget) {
      this.errorTarget.textContent = "Choose the kind of help you need."
      this.errorTarget.classList.add("d-block")
    }
    this.open()
  }

  buildOptions() {
    this.menuTarget.replaceChildren()

    Array.from(this.selectTarget.options).forEach((option, index) => {
      const button = document.createElement("button")
      button.type = "button"
      button.className = "custom-select__option"
      button.dataset.value = option.value
      button.dataset.action = "custom-select#choose"
      button.setAttribute("role", "option")
      button.setAttribute("aria-selected", option.selected ? "true" : "false")
      button.tabIndex = option.selected ? 0 : -1
      if (!option.value) button.classList.add("custom-select__option--placeholder")

      const check = document.createElement("span")
      check.className = "custom-select__check"
      check.textContent = "✓"
      check.setAttribute("aria-hidden", "true")

      const label = document.createElement("span")
      label.textContent = option.text
      button.append(check, label)
      this.menuTarget.append(button)

      if (index === 0 && !this.selectTarget.value) button.tabIndex = 0
    })
  }

  syncFromSelect() {
    const selected = this.selectTarget.options[this.selectTarget.selectedIndex]
    this.valueTarget.textContent = selected?.text || "Choose an option"
    this.menuTarget.querySelectorAll(".custom-select__option").forEach((option) => {
      const isSelected = option.dataset.value === this.selectTarget.value
      option.setAttribute("aria-selected", isSelected ? "true" : "false")
      option.tabIndex = isSelected ? 0 : -1
    })
  }

  clearError() {
    this.triggerTarget.removeAttribute("aria-invalid")
    this.triggerTarget.classList.remove("is-invalid")
    if (this.hasErrorTarget && !this.selectTarget.selectedOptions[0]?.value) return
    if (this.hasErrorTarget) {
      this.errorTarget.textContent = ""
      this.errorTarget.classList.remove("d-block")
    }
  }
}
