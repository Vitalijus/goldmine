import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="link-toggle"
export default class extends Controller {
  static targets = ["radio", "link"]

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
      link.href = "https://buy.stripe.com/test_00w00jboOgsRdbs4Pr8k801"
    } else if (selectedValue === "united kingdom") {
      link.href = "https://buy.stripe.com/test_cNibJ150q4K9gnE1Df8k802"
    } else if (selectedValue === "canada") {
      link.href = "https://buy.stripe.com/test_fZu6oH64u3G57R8fu58k803"
    } else {
      link.href = "#"
    }
  }
}
