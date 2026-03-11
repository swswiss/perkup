import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "panel"]

  connect() {
    this.timeout = null
    this.highlightedIndex = -1

    // ⌘K shortcut
    document.addEventListener("keydown", (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key === "k") {
        e.preventDefault()
        this.inputTarget.focus()
      }
    })

    // Close dropdown on outside click
    document.addEventListener("click", (e) => {
      if (!this.element.contains(e.target)) {
        this.dropdownTarget.classList.remove("open")
      }
    })
  }

  search() {
    clearTimeout(this.timeout)
    const query = this.inputTarget.value.trim()

    if (query.length < 2) {
      this.dropdownTarget.classList.remove("open")
      return
    }

    // Debounce 300ms
    this.timeout = setTimeout(() => {
      fetch(`/customers/lookup/search?q=${encodeURIComponent(query)}`, {
        headers: { "Accept": "text/html" }
      })
      .then(r => r.text())
      .then(html => {
        this.dropdownTarget.innerHTML = html
        this.dropdownTarget.classList.add("open")
        this.highlightedIndex = -1
      })
    }, 300)
  }

  navigate(e) {
    const items = this.dropdownTarget.querySelectorAll(".sd-item")
    if (!items.length) return

    if (e.key === "ArrowDown") {
      e.preventDefault()
      this.highlightedIndex = Math.min(this.highlightedIndex + 1, items.length - 1)
    } else if (e.key === "ArrowUp") {
      e.preventDefault()
      this.highlightedIndex = Math.max(this.highlightedIndex - 1, 0)
    } else if (e.key === "Enter" && this.highlightedIndex >= 0) {
      e.preventDefault()
      items[this.highlightedIndex].click()
      return
    } else if (e.key === "Escape") {
      this.dropdownTarget.classList.remove("open")
      return
    } else {
      return
    }

    items.forEach((el, i) => el.classList.toggle("highlighted", i === this.highlightedIndex))
    items[this.highlightedIndex].scrollIntoView({ block: "nearest" })
  }

  select(e) {
    const userId = e.currentTarget.dataset.userId
    const userName = e.currentTarget.dataset.userName

    this.inputTarget.value = userName
    this.dropdownTarget.classList.remove("open")

    // Load user panel via fetch
    fetch(`/customers/lookup/user/${userId}`, {
      headers: { "Accept": "text/html" }
    })
    .then(r => r.text())
    .then(html => {
      this.panelTarget.innerHTML = html
      this.panelTarget.classList.remove("show")
      // Reflow for animation
      void this.panelTarget.offsetWidth
      this.panelTarget.classList.add("show")
    })
  }

  closeUser() {
    this.panelTarget.classList.remove("show")
    this.inputTarget.value = ""
  }

  switchTab(e) {
    const tab = e.currentTarget.dataset.tab
    this.element.querySelectorAll(".tab").forEach(t => t.classList.remove("active"))
    e.currentTarget.classList.add("active")
    this.element.querySelectorAll(".tab-content").forEach(tc => tc.classList.remove("show"))
    document.getElementById(`tab-${tab}`).classList.add("show")
  }
}