import { Controller } from "@hotwired/stimulus"

// Reveals meaningful content once, as it enters the reading flow. The page is
// fully visible without JavaScript; hidden states only apply after this
// controller opts the document into motion.
export default class extends Controller {
  connect() {
    this.reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    if (this.reduceMotion || !("IntersectionObserver" in window)) return

    this.revealElements = Array.from(this.element.querySelectorAll(this.revealSelector))
    this.revealElements.forEach((element, index) => {
      element.classList.add("motion-reveal")
      element.style.setProperty("--motion-order", index % 3)
    })

    // Wait one frame so the browser records the composed start state before
    // visible elements transition in. This avoids layout reads and thrashing.
    this.frame = requestAnimationFrame(() => {
      this.element.classList.add("motion-ready")
      this.observer = new IntersectionObserver(this.reveal.bind(this), {
        threshold: 0.14,
        rootMargin: "0px 0px -7% 0px"
      })
      this.revealElements.forEach((element) => this.observer.observe(element))
    })
  }

  disconnect() {
    cancelAnimationFrame(this.frame)
    this.observer?.disconnect()
  }

  reveal(entries) {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return

      entry.target.classList.add("motion-reveal--visible")
      entry.target.addEventListener("transitionend", () => {
        entry.target.classList.add("motion-reveal--settled")
      }, { once: true })
      this.observer.unobserve(entry.target)
    })
  }

  get revealSelector() {
    return [
      ".section-heading",
      ".listing-filter",
      ".listing-card",
      ".activity-card",
      ".offer-card",
      ".empty-state",
      ".paw-form",
      ".offers-header",
      ".landing-reveal"
    ].join(",")
  }
}
