import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    duration: { type: Number, default: 5000 }
  }

  connect() {
    // Slide in
    requestAnimationFrame(() => {
      this.element.classList.add("flash--show")
      this.startProgress()
    })

    // Auto dismiss
    this.timer = setTimeout(() => this.dismiss(), this.durationValue)

    // Pause on hover
    this.element.addEventListener("mouseenter", () => {
      clearTimeout(this.timer)
      this.element.querySelector(".flash__progress")
        ?.style.setProperty("animation-play-state", "paused")
    })

    this.element.addEventListener("mouseleave", () => {
      this.timer = setTimeout(() => this.dismiss(), 2000)
      this.element.querySelector(".flash__progress")
        ?.style.setProperty("animation-play-state", "running")
    })
  }

  dismiss() {
    this.element.classList.remove("flash--show")
    this.element.classList.add("flash--hide")
    setTimeout(() => this.element.remove(), 400)
  }

  startProgress() {
    const bar = this.element.querySelector(".flash__progress")
    if (bar) {
      bar.style.animationDuration = `${this.durationValue}ms`
      bar.classList.add("flash__progress--running")
    }
  }

  disconnect() {
    clearTimeout(this.timer)
  }
}