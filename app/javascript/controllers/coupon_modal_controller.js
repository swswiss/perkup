import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "qrImage", "name", "expires", "code"]

  open(event) {
    event.preventDefault()

    const couponId = event.currentTarget.dataset.couponId
    const couponName = event.currentTarget.dataset.couponName
    const couponExpires = event.currentTarget.dataset.couponExpires
    const couponCode = event.currentTarget.dataset.couponCode

    // Set text
    this.nameTarget.textContent = couponName
    this.expiresTarget.textContent = couponExpires
    this.codeTarget.textContent = couponCode

    // Load QR image from the /qr endpoint
    this.qrImageTarget.src = `/coupons/${couponId}/qr`
    this.qrImageTarget.style.opacity = "0"

    this.qrImageTarget.onload = () => {
      this.qrImageTarget.style.opacity = "1"
    }

    // Show modal
    this.overlayTarget.classList.add("show")
    document.body.style.overflow = "hidden"
  }

  close() {
    this.overlayTarget.classList.remove("show")
    document.body.style.overflow = ""
  }

  // Close on overlay click (not modal content)
  backdropClose(event) {
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }

  // Close on Escape key
  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}