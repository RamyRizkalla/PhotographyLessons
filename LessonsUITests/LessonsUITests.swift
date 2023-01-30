//
//  LessonsUITests.swift
//  LessonsUITests
//
//  Created by Ramy Rizkalla on 24/01/2023.
//

import XCTest

final class LessonsUITests: XCTestCase {
  private var app = XCUIApplication()

  override func setUpWithError() throws {
    continueAfterFailure = false
    app.launchArguments = [ProcessInfo.Argument]([.uitest]).map(\.rawValue)
    app.launch()
  }

  func testFirstRowInList() throws {
    let expectedFirstRowTitle = "Setting The Correct Exposure For Your Photos"

    XCTAssertTrue(LessonsListPage.table.waitForExistence(timeout: 3))
    XCTAssertTrue(LessonsListPage.cells.firstMatch.waitForExistence(timeout: 5))
    XCTAssertEqual(LessonsListPage.title(at: 0).label, expectedFirstRowTitle)
  }

  func testNavigationToLessonDetails() throws {
    XCTAssertTrue(LessonsListPage.cells.firstMatch.waitForExistence(timeout: 5))
    LessonsListPage.pressOnCell(at: 0)
    XCTAssertTrue(LessonDetailsPage.title.waitForExistence(timeout: 3.0))

    let expectedTitle = "Setting The Correct Exposure For Your Photos"
    let expectedDescription = """
    Setting the correct exposure is essential for capturing stunning photos with amazing detail. But did you know that exposure can also be used as a creative tool to take truly unique images? Watch this video from our breakthrough iPhone Photo Academy course, and discover the secrets of setting the perfect exposure for your iPhone photos.
    """

    XCTAssertEqual(LessonDetailsPage.title.label, expectedTitle)
    XCTAssertEqual(LessonDetailsPage.description.label, expectedDescription)
  }
}
