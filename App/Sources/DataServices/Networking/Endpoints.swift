//
//  Endpoints.swift
//  LessonsTests
//
//  Created by Ramy Rizkalla on 26/01/2023.
//

import Foundation

enum Endpoint {
  case lessons
}

extension Endpoint {
  var baseUrl: URL {
    URL(string: ApiEnvironment.apiUrl)!
  }

  var path: String {
    switch self {
    case .lessons:
      return "/lessons"
    }
  }
}
