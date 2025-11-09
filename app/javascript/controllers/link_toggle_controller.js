import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="link-toggle"
export default class extends Controller {
  static targets = ["radio", "link"]
  static values = {
    usaUrl: String,
    ukUrl: String,
    canadaUrl: String,
    australiaUrl: String
  }

  connect() {
    console.log("LinkToggle controller connected")

    // When the controller connects, preselect the checked radio (if any)
    const checkedRadio = this.radioTargets.find(r => r.checked)
    if (checkedRadio) {
      this.updateLink({ target: checkedRadio })
    }
  }

  updateLink(event) {
    const selectedValue = event.target.value
    const link = this.linkTarget

    if (selectedValue === "usa") {
      link.href = this.usaUrlValue
    } else if (selectedValue === "united kingdom") {
      link.href = this.ukUrlValue
    } else if (selectedValue === "canada") {
      link.href = this.canadaUrlValue
    } else if (selectedValue === "australia") {
      link.href = this.australiaUrlValue
    } else {
      link.href = "#"
    }
  }
}
