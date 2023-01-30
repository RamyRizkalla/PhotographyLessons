//
//  AccessibilityIdentifiers.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 29/01/2023.
//

import Foundation

protocol AccessibilityIdentifiable {
  var rawValue: String { get }
}

enum AccessibilityIdentifier {
  enum List: String, AccessibilityIdentifiable {
    case image = "List.image"
    case title = "List.title"
  }

  enum Details: String, AccessibilityIdentifiable {
    case title = "Details.title"
    case description = "Details.description"
  }
}
