// Copyright © 2024 Josh Adams. All rights reserved.

import Observation

@Observable
class BrowseBreedsViewModel {
  enum State: Equatable {
    case loading
    case loaded(breeds: [Breed])
    case error
  }

  var state: State = .loading

  func loadBreeds() async {
    let breeds = await BreedLoader.loadBreeds()
    if let breeds {
      state = .loaded(breeds: breeds)
    } else {
      state = .error
    }
  }
}
