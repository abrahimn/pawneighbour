import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

// Connects to data-controller="address-autocomplete"
export default class extends Controller {
  static values = {
    apiKey: String,
    types: { type: String, default: "locality" },
    proximity: { type: Array, default: [] }
  }

  static targets = ["address"]

  connect() {
    const options = {
      accessToken: this.apiKeyValue,
      types: this.typesValue,
      countries: "au"
    }

    if (this.proximityValue.length === 2) {
      options.proximity = this.proximityValue
    }

    this.geocoder = new MapboxGeocoder(options)

    this.geocoder.addTo(this.element)
    this.geocoder.on("result", event => this.#setInputValue(event))
    this.geocoder.on("clear", () => this.#clearInputValue())
  }

  #setInputValue(event) {
    const result = event.result
    const context = result.context || []
    const find = (prefix) => context.find((c) => c.id.startsWith(prefix))

    const area =
      find("locality")?.text ||
      find("region")?.short_code?.replace(/^\w{2}-/, "")

    this.addressTarget.value = [result.text, area].filter(Boolean).join(", ")
  }

  #clearInputValue() {
    this.addressTarget.value = ""
  }

  disconnect() {
    this.geocoder?.onRemove()
  }
}
