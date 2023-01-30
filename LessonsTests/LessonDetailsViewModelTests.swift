//
//  LessonsTests.swift
//  LessonsTests
//
//  Created by Ramy Rizkalla on 24/01/2023.
//

import XCTest
@testable import Lessons

final class LessonDetailsViewModelTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testSavingLessons() throws {
    let persistenceCtrl = PersistenceController.test
    let lessonsRepository = LessonsRepository(context: persistenceCtrl.viewContext)

    let data = try XCTUnwrap(FileReader.readJson("MockLessonsResponse"))
    let lessonsResponse = try JSONDecoder.standard.decode(LessonsApiResponse.self, from: data)

    try lessonsRepository.batchInsert(lessonsResponse.lessons)

    let localLessons = try lessonsRepository.fetch(sortDescriptors: [NSSortDescriptor(keyPath: \LessonData.id, ascending: true)])
    XCTAssertEqual(localLessons.count, 3)
    XCTAssertEqual(localLessons.first!.id, 950)
    XCTAssertEqual(localLessons.first!.name, "The Key To Success In iPhone Photography")
  }
}
