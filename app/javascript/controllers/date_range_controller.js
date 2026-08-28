import { Controller } from "@hotwired/stimulus"

// A dependency-free, progressively enhanced range calendar. The underlying
// Rails date fields remain in the DOM as a no-JavaScript fallback and continue
// to carry the submitted start_date/end_date values.
export default class extends Controller {
  static targets = [
    "trigger", "summary", "start", "end", "popover", "monthLabel",
    "grid", "selection", "error"
  ]

  static values = { min: String }

  connect() {
    this.minimumDate = this.parseDate(this.minValue)
    this.startDate = this.parseDate(this.startTarget.value)
    this.endDate = this.parseDate(this.endTarget.value)
    this.monthCursor = this.startOfMonth(this.startDate || this.minimumDate)

    this.startTarget.required = false
    this.endTarget.required = false
    this.element.classList.add("date-range--enhanced")
    this.triggerTarget.hidden = false

    this.boundOutsideClick = this.handleOutsideClick.bind(this)
    this.boundSubmit = this.validateBeforeSubmit.bind(this)
    document.addEventListener("pointerdown", this.boundOutsideClick)
    this.form = this.element.closest("form")
    this.form?.addEventListener("submit", this.boundSubmit)

    this.render()
    this.updateSummary()
  }

  disconnect() {
    document.removeEventListener("pointerdown", this.boundOutsideClick)
    this.form?.removeEventListener("submit", this.boundSubmit)
  }

  toggle(event) {
    event.stopPropagation()
    this.popoverTarget.hidden ? this.open() : this.closePopover()
  }

  open() {
    this.popoverTarget.hidden = false
    this.triggerTarget.setAttribute("aria-expanded", "true")
    this.element.classList.add("date-range--open")
    this.render()

    requestAnimationFrame(() => {
      const preferredDate = this.endDate || this.startDate || this.minimumDate
      this.gridTarget.querySelector(`[data-date="${this.toISO(preferredDate)}"]`)?.focus()
    })
  }

  close(event) {
    this.closePopover()
    if (event) this.triggerTarget.focus()
  }

  closePopover() {
    this.popoverTarget.hidden = true
    this.triggerTarget.setAttribute("aria-expanded", "false")
    this.element.classList.remove("date-range--open")
  }

  previousMonth() {
    const previous = this.addMonths(this.monthCursor, -1)
    if (previous < this.startOfMonth(this.minimumDate)) return
    this.monthCursor = previous
    this.render()
  }

  nextMonth() {
    this.monthCursor = this.addMonths(this.monthCursor, 1)
    this.render()
  }

  selectDate(event) {
    const selected = this.parseDate(event.currentTarget.dataset.date)

    if (!this.startDate || this.endDate || selected < this.startDate) {
      this.startDate = selected
      this.endDate = null
    } else {
      this.endDate = selected
    }

    this.commitValues()
    this.render()
    this.updateSummary()
  }

  clear() {
    this.startDate = null
    this.endDate = null
    this.commitValues()
    this.render()
    this.updateSummary()
  }

  navigateCalendar(event) {
    if (event.key === "Escape") {
      event.preventDefault()
      this.closePopover()
      this.triggerTarget.focus()
      return
    }

    const dayButton = event.target.closest(".date-range__day")
    if (!dayButton) return

    const offsets = { ArrowLeft: -1, ArrowRight: 1, ArrowUp: -7, ArrowDown: 7 }
    const offset = offsets[event.key]
    if (!offset) return

    event.preventDefault()
    const destination = this.addDays(this.parseDate(dayButton.dataset.date), offset)
    if (destination < this.minimumDate) return

    if (destination.getUTCMonth() !== this.monthCursor.getUTCMonth() ||
        destination.getUTCFullYear() !== this.monthCursor.getUTCFullYear()) {
      this.monthCursor = this.startOfMonth(destination)
      this.render()
    }

    requestAnimationFrame(() => {
      this.gridTarget.querySelector(`[data-date="${this.toISO(destination)}"]`)?.focus()
    })
  }

  handleOutsideClick(event) {
    if (!this.popoverTarget.hidden && !this.element.contains(event.target)) this.closePopover()
  }

  validateBeforeSubmit(event) {
    if (this.startDate && this.endDate) return

    event.preventDefault()
    this.errorTarget.textContent = "Choose both the first and last day you need help."
    this.errorTarget.classList.add("is-visible")
    this.triggerTarget.setAttribute("aria-invalid", "true")
    this.open()
  }

  render() {
    const year = this.monthCursor.getUTCFullYear()
    const month = this.monthCursor.getUTCMonth()
    const numberOfDays = new Date(Date.UTC(year, month + 1, 0)).getUTCDate()
    const leadingBlanks = (new Date(Date.UTC(year, month, 1)).getUTCDay() + 6) % 7
    const todayISO = this.toISO(this.minimumDate)
    const startISO = this.startDate ? this.toISO(this.startDate) : null
    const endISO = this.endDate ? this.toISO(this.endDate) : null

    this.monthLabelTarget.textContent = new Intl.DateTimeFormat("en-AU", {
      month: "long", year: "numeric", timeZone: "UTC"
    }).format(this.monthCursor)
    this.gridTarget.replaceChildren()

    for (let index = 0; index < leadingBlanks; index += 1) {
      const blank = document.createElement("span")
      blank.className = "date-range__blank"
      blank.setAttribute("aria-hidden", "true")
      this.gridTarget.append(blank)
    }

    for (let day = 1; day <= numberOfDays; day += 1) {
      const date = new Date(Date.UTC(year, month, day))
      const iso = this.toISO(date)
      const button = document.createElement("button")
      button.type = "button"
      button.className = "date-range__day"
      button.textContent = day
      button.dataset.date = iso
      button.dataset.action = "date-range#selectDate"
      button.setAttribute("role", "gridcell")
      button.setAttribute("aria-label", this.longDate(date))
      button.setAttribute("aria-pressed", iso === startISO || iso === endISO ? "true" : "false")
      button.tabIndex = iso === (endISO || startISO || todayISO) ? 0 : -1

      if (date < this.minimumDate) button.disabled = true
      if (iso === todayISO) {
        button.classList.add("date-range__day--today")
        button.setAttribute("aria-current", "date")
      }
      if (iso === startISO) button.classList.add("date-range__day--start")
      if (iso === endISO) button.classList.add("date-range__day--end")
      if (this.startDate && this.endDate && date > this.startDate && date < this.endDate) {
        button.classList.add("date-range__day--in-range")
      }

      this.gridTarget.append(button)
    }

    const previousButton = this.element.querySelector('[aria-label="Previous month"]')
    previousButton.disabled = this.monthCursor <= this.startOfMonth(this.minimumDate)
  }

  updateSummary() {
    if (!this.startDate) {
      this.summaryTarget.textContent = "Choose a date range"
      this.selectionTarget.textContent = "Choose your first day"
      return
    }

    if (!this.endDate) {
      const firstDay = this.shortDate(this.startDate)
      this.summaryTarget.textContent = `${firstDay} — choose an end date`
      this.selectionTarget.textContent = `${firstDay} — choose your last day`
      return
    }

    const range = `${this.shortDate(this.startDate)} – ${this.shortDate(this.endDate, true)}`
    this.summaryTarget.textContent = range
    this.selectionTarget.textContent = range
  }

  commitValues() {
    this.startTarget.value = this.startDate ? this.toISO(this.startDate) : ""
    this.endTarget.value = this.endDate ? this.toISO(this.endDate) : ""
    this.startTarget.dispatchEvent(new Event("change", { bubbles: true }))
    this.endTarget.dispatchEvent(new Event("change", { bubbles: true }))

    if (this.startDate && this.endDate) {
      this.errorTarget.textContent = ""
      this.errorTarget.classList.remove("is-visible")
      this.triggerTarget.removeAttribute("aria-invalid")
    }
  }

  parseDate(value) {
    if (!value) return null
    const [year, month, day] = value.split("-").map(Number)
    return new Date(Date.UTC(year, month - 1, day))
  }

  startOfMonth(date) {
    return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), 1))
  }

  addMonths(date, amount) {
    return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth() + amount, 1))
  }

  addDays(date, amount) {
    return new Date(date.getTime() + amount * 86_400_000)
  }

  toISO(date) {
    return date.toISOString().slice(0, 10)
  }

  shortDate(date, includeYear = false) {
    return new Intl.DateTimeFormat("en-AU", {
      day: "numeric", month: "short", year: includeYear ? "numeric" : undefined, timeZone: "UTC"
    }).format(date)
  }

  longDate(date) {
    return new Intl.DateTimeFormat("en-AU", {
      weekday: "long", day: "numeric", month: "long", year: "numeric", timeZone: "UTC"
    }).format(date)
  }
}
