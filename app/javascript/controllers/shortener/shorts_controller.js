import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="shortener--shorts"
export default class extends Controller {
  static targets = ["expireAt"];

  expireAtTargetConnected(expireAtElement) {
    const expireAt = new Date(expireAtElement.dateTime);

    expireAtElement.textContent = expireAt.toLocaleString();
  };
}
