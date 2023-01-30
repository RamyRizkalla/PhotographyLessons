//
//  DownloadManager.swift
//  LessonsUITests
//
//  Created by Ramy Rizkalla on 29/01/2023.
//

import Combine
import Foundation

final class DownloadManager<Identifier: Hashable> {
  private var downloads: [Identifier: AnyCancellable]
  private var urlSession: URLSession

  var completionPublisher = PassthroughSubject<(URL, any Hashable), Never>()
  var progressPublisher = PassthroughSubject<Double, Never>()

  init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
    self.downloads = [:]
  }

  func fetchWithProgress(url: URL, identifier: Identifier) {
    guard downloads[identifier] == nil else { return }

    downloads[identifier] = urlSession.downloadTaskPublisher(for: url, identifier: identifier)
      .sink { result in
        print(result)
      } receiveValue: { [weak progressPublisher, weak completionPublisher] output in
        if let url = output.downloadUrl {
          if let permanentDownloadUrl = FileManager.default.secureCopyItem(at: url) {
            completionPublisher?.send((permanentDownloadUrl, output.identifier))
          }
        }
        else {
          progressPublisher?.send(output.fractionCompleted)
        }
      }
  }

  func cancel(identifier: Identifier) {
    downloads[identifier]?.cancel()
    downloads[identifier] = nil
  }
}
