// Copyright © 2024 Josh Adams. All rights reserved.

import UIKit

struct Breed: Codable, Equatable, Identifiable {
  var id: String { name }
  let name: String
  let origin: String
  let description: String
  let wikipediaURL: String?
  let catImage: CatImage?

  enum CodingKeys: String, CodingKey {
    case name
    case origin
    case description
    case wikipediaURL = "wikipedia_url"
    case catImage = "image"
  }

  static var mock: Breed {
    Breed(
      name: "Abyssinian",
      origin: "Egypt",
      description: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
      wikipediaURL: "https://en.wikipedia.org/wiki/Abyssinian_(cat)",
      catImage: CatImage(url: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg")
    )
  }
}
