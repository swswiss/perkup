import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      const q = this.inputTarget.value.trim()
      const frame = document.getElementById("clients-frame")
      const url = `/customers/clients/search?q=${encodeURIComponent(q)}`
      frame.src = url
    }, 300)
  }
}