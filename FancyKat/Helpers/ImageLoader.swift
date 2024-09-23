// Copyright © 2024 Josh Adams. All rights reserved.

import UIKit

actor ImageLoader {
  private var loaderStatuses: [URL: LoaderStatus] = [:]
  private let errorImage = UIImage(resource: .error)

  private enum LoaderStatus {
    case inProgress(Task<UIImage, Error>)
    case fetched(UIImage)
  }

  func fetch(_ url: URL) async -> UIImage {
    if let status = loaderStatuses[url] {
      switch status {
      case .fetched(let image):
        return image
      case .inProgress(let task):
        return (try? await task.value) ?? errorImage
      }
    }

    let task: Task<UIImage, Error> = Task {
      let image: UIImage

      do {
        let (imageData, _) = try await URLSession.shared.data(from: url)
        image = UIImage(data: imageData) ?? errorImage
      } catch {
        image = errorImage
      }

      return image
    }

    loaderStatuses[url] = .inProgress(task)

    do {
      let image = try await task.value
      loaderStatuses[url] = .fetched(image)
      return image
    } catch {
      loaderStatuses[url] = .fetched(errorImage)
      return errorImage
    }
  }
}
