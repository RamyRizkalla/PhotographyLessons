//
//  LessonData+CoreDataClass.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 26/01/2023.
//
//

import Foundation
import CoreData

@objc(LessonData)
public class LessonData: NSManagedObject {
  enum DownloadState: Int {
    case notDownloaded, inProgress, downloaded
  }

  var primaryKey: Int {
    Int(id)
  }

  var downloadStateEnum: DownloadState {
    set {
      self.downloadState = Int64(newValue.rawValue)
    }
    get {
      return .init(rawValue: Int(downloadState))!
    }
  }
}

extension LessonData {
  enum Predicates {
    case primaryKey(Int)

    var predicate: NSPredicate {
      switch self {
      case let .primaryKey(id):
        return NSPredicate(format: "id == %@", argumentArray: [id])
      }
    }
  }
}
