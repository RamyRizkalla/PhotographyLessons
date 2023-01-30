//
//  LessonsListPage.swift
//  LessonsUITests
//
//  Created by Ramy Rizkalla on 29/01/2023.
//

import XCTest

enum LessonsListPage {
  private static let app = XCUIApplication()

  static var table: XCUIElement {
    app.collectionViews.firstMatch
  }

  static var cells: XCUIElementQuery {
    return table.cells
  }

  static var numberOfCells: Int {
    return table.cells.count
  }

  static func cell(at index: Int) -> XCUIElement {
    return table.cells.element(boundBy: index)
  }

  static func title(at index: Int) -> XCUIElement {
    cell(at: index).staticTexts[AccessibilityIdentifier.List.title.rawValue]
  }

  static func pressOnCell(at index: Int) {
    cell(at: index).tap()
  }
}
