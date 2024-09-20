// Copyright © 2024 Josh Adams. All rights reserved.

import SwiftUI

struct BrowseBreedsView: View {
  private let viewModel = BrowseBreedsViewModel()
  @State private var images: [String: UIImage] = [:]
  private let photoHeightWidth: CGFloat = 150
  private let imageLoader = ImageLoader()

  var body: some View {
    NavigationStack {
      VStack {
        switch viewModel.state {
        case .loading:
          ProgressView()
        case .loaded(let breeds):
          list(of: breeds)
        case .error:
          Image(.error)
        }
      }
      .navigationTitle("Cat Breeds")
    }
    .task {
      await viewModel.loadBreeds()
    }
  }

  func list(of breeds: [Breed]) -> some View {
    List(breeds) { breed in
      NavigationLink {
        BreedDetailsView(breed: breed, loadedImage: images[breed.name], imageLoader: imageLoader)
      } label: {
        HStack {
          VStack(alignment: .leading) {
            Text(breed.name)
              .font(.headline)
            Text(breed.origin)
              .font(.body)
          }

          Spacer()

          Group {
            if let image = images[breed.name] {
              Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            } else {
              ProgressView()
            }
          }
          .frame(width: photoHeightWidth, height: photoHeightWidth)
          .task {
            if
              let urlString = breed.catImage?.url,
              let url = URL(string: urlString)
            {
              let loadedImage = await imageLoader.fetch(url)
              images[breed.name] = loadedImage
            }
          }
        }
      }
    }
  }
}

#Preview {
  BrowseBreedsView()
}
