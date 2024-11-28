import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown", "details"];

  updateDetails(event) {
    const dropdown = event.target;
    const locationId = dropdown.value;
    const promptOption = dropdown.querySelector("option[value='']");
    const label = dropdown.closest(".form-group").querySelector("label");

    // Update label text to "Address Selection"
    if (label) {
      label.textContent = "Selected Address";
    }

    // Disable the "Please select location" prompt
    if (promptOption) {
      promptOption.disabled = true;
    }

    // Display "Loading..." text while fetching data
    this.detailsTarget.innerHTML = "<p>Loading...</p>";

    // Fetch and update the location details dynamically
    if (locationId) {
      fetch(`/client/locations/${locationId}/details`)
          .then(response => response.text())
          .then(html => {
            this.detailsTarget.innerHTML = html; // Populate details with the fetched HTML
          })
          .catch(error => {
            this.detailsTarget.innerHTML = "<p>Error loading details. Please try again.</p>";
            console.error("Error fetching location details:", error);
          });
    } else {
      this.detailsTarget.innerHTML = ""; // Clear details if no location selected
    }
  }
}
