import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
      })

      this.#addMarkersToMap()
      this.#fitMapToMarkers()
      this.#openInfoWindow()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      new mapboxgl.Marker().setLngLat([ marker.lng, marker.lat]). addTo(this.map)
    })
  }

  #fitMapToMarkers() {
  const bounds = new mapboxgl.LngLatBounds()
  this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
  this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  #openInfoWindow(){
    // Select all cards
    const cards = document.querySelectorAll('.card');
    cards.forEach((card, index) => {
      // Put a microphone on each card listening for a mouseenter event
      card.addEventListener('mouseenter', () => {
        // Here we trigger the display of the corresponding marker infoWindow with the "togglePopup" function provided by mapbox-gl
        this.markersValue[index].togglePopup();
      });
      // We also put a microphone listening for a mouseleave event to close the modal when user doesn't hover the card anymore
      card.addEventListener('mouseleave', () => {
        this.markersValue.markers[index].togglePopup();
      });
    });
  }
}
