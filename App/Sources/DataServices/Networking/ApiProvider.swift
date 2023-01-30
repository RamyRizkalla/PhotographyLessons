//
//  ApiProvider.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 26/01/2023.
//

import Combine
import Foundation

enum ApiError: Error {
  case error
}

//https://iphonephotographyschool.com/test-api/lessons
final class ApiProvider {
  static var shared = ApiProvider()
  
  private var urlSession: URLSession

  init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }

  func performRequest(_ endpoint: Endpoint) -> AnyPublisher<LessonsApiResponse, ApiError> {
    let url: URL = endpoint.baseUrl.appendingPathComponent(endpoint.path)
    return urlSession
      .dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: LessonsApiResponse.self, decoder: JSONDecoder.standard)
      .mapError { error in
        return ApiError.error
      }
      .eraseToAnyPublisher()
  }

  func fetch(url: URL) -> AnyPublisher<Data, ApiError> {
    urlSession.dataTaskPublisher(for: url)
      .map(\.data)
      .mapError { _ in
        return .error
      }
      .eraseToAnyPublisher()
  }
}
