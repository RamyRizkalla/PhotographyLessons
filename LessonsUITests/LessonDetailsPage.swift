//
//  LessonDetailsPage.swift
//  LessonsUITests
//
//  Created by Ramy Rizkalla on 30/01/2023.
//

import XCTest

enum LessonDetailsPage {
  private static let app = XCUIApplication()

  static var title: XCUIElement {
    staticTexts[AccessibilityIdentifier.Details.title.rawValue]
  }

  static var description: XCUIElement {
    staticTexts[AccessibilityIdentifier.Details.description.rawValue]
  }

  static var staticTexts: XCUIElementQuery {
    app.scrollViews.firstMatch.staticTexts
  }
}
