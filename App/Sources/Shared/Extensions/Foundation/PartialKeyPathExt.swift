//
//  PartialKeyPathExt.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 27/01/2023.
//

import Foundation

extension PartialKeyPath {
  var stringValue: String {
    switch self {
    case let value as KeyPath<Root, String?>:
      return value.pathStringValue
    case let value as KeyPath<Root, Int64>:
      return value.pathStringValue
    case let value as KeyPath<Root, Data?>:
      return value.pathStringValue
    default:
      fatalError("Unsupported type \(self)")
    }
  }
}
