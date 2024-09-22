// Copyright © 2024 Josh Adams. All rights reserved.

import SwiftUI

struct BreedDetailsView: View {
  private let breed: Breed
  @State var loadedImage: UIImage?
  private let imageLoader: ImageLoader

  private let photoHeightWidth: CGFloat = 300
  @Environment(\.openURL) var openURL

  init(breed: Breed, loadedImage: UIImage? = nil, imageLoader: ImageLoader) {
    self.breed = breed
    self.loadedImage = loadedImage
    self.imageLoader = imageLoader
  }

  var body: some View {
    VStack {
      Text(breed.name)
        .font(.title)

      Group {
        if let loadedImage {
          Image(uiImage: loadedImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
        } else {
          ProgressView()
          .task {
            if
              let urlString = breed.catImage?.url,
              let url = URL(string: urlString)
            {
              loadedImage = await imageLoader.fetch(url)
            }
          }
        }
      }
      .frame(width: photoHeightWidth, height: photoHeightWidth)

      ScrollView {
        Text(breed.description)
          .font(.body)
          .padding()
      }

      Spacer()

      if
        let wikipediaURLString = breed.wikipediaURL,
        let wikipediaURL = URL(string: wikipediaURLString)
      {
        Button("View Wikipedia Article") {
          openURL(wikipediaURL)
        }
      }
    }
  }
}

#Preview {
  BreedDetailsView(breed: Breed.mock, loadedImage: nil, imageLoader: ImageLoader())
}
