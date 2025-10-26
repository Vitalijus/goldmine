import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="link-toggle"
export default class extends Controller {
  static targets = ["checkbox", "link"]

  connect() {
    console.log("LinkToggle controller connected")
  }

  updateLink() {
    const isChecked = this.checkboxTarget.checked
    const link = this.linkTarget

    if (isChecked) {
      link.href = "https://example.com/checked"
      link.textContent = "Go to checked page"
    } else {
      link.href = "https://example.com/unchecked"
      link.textContent = "Go to unchecked page"
    }
  }
}