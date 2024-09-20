// Copyright © 2024 Josh Adams. All rights reserved.

import Foundation

enum BreedLoader {
  static let apiKey = ""

  static func loadBreeds() async -> [Breed]? {
    if apiKey == "" {
      fatalError("FancyKat requires a free API key from The Cat API. Visit: https://thecatapi.com/signup")
    }

    guard let url = URL(string: "https://api.thecatapi.com/v1/breeds?api_key=\(BreedLoader.apiKey)") else {
      return nil
    }

    do {
      let (jsonData, _) = try await URLSession.shared.data(from: url)
      let breeds = try JSONDecoder().decode([Breed].self, from: jsonData)
      for breed in breeds {
        print(breed.name)
      }
      return breeds
    } catch {
      return nil
    }
  }
}
