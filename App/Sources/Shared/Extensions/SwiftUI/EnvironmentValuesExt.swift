//
//  RepoKey.swift
//  LessonsUITests
//
//  Created by Ramy Rizkalla on 29/01/2023.
//

import SwiftUI

extension EnvironmentValues {
  private struct LessonRepositoryKey: EnvironmentKey {
    static let defaultValue: LessonsRepository = {
      if ProcessInfo.processInfo.isUITesting {
        return .init(context: PersistenceController.test.viewContext)
      }
      else {
        return .init(context: PersistenceController.shared.viewContext)
      }
    }()
  }

  private struct ApiProviderKey: EnvironmentKey {
    static let defaultValue: ApiProvider = .init(urlSession: .shared)
  }
}

extension EnvironmentValues {
  var lessonRepository: LessonsRepository {
    get {
      self[LessonRepositoryKey.self]
    }
    set {
      self[LessonRepositoryKey.self] = newValue
    }
  }

  var apiProvider: ApiProvider {
    get {
      self[ApiProviderKey.self]
    }
    set {
      self[ApiProviderKey.self] = newValue
    }
  }
}
