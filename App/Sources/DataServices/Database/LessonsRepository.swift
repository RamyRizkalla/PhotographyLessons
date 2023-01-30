//
//  LessonDetailsRepository.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 27/01/2023.
//

import Combine
import CoreData
import Foundation

final class LessonsRepository: NSObject {
  private let repository: CoreDataRepository<LessonData>
  private let context: NSManagedObjectContext

  private(set) var lessonsPublisher = PassthroughSubject<(lesson: LessonData, type: NSFetchedResultsChangeType), Never>()
  private var fetchedResultsCtrl: NSFetchedResultsController<LessonData>

  init(context: NSManagedObjectContext) {
    self.repository = .init(managedObjectContext: context)
    self.context = context

    let fetchRequest = LessonData.fetchRequest().with {
      $0.sortDescriptors = [NSSortDescriptor(keyPath: \LessonData.id, ascending: true)]
    }
    self.fetchedResultsCtrl = .init(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    super.init()
    self.fetchedResultsCtrl.delegate = self
  }

  func batchInsert(_ lessons: [Lesson]) throws {
    try repository.batchInsert(lessons.map(\.dataModel))
  }

  func fetch(
    predicate: NSPredicate? = nil,
    sortDescriptors: [NSSortDescriptor]? = nil
  ) throws -> [LessonData] {
    fetchedResultsCtrl.fetchRequest.predicate = predicate
    fetchedResultsCtrl.fetchRequest.sortDescriptors = sortDescriptors

    try fetchedResultsCtrl.performFetch()
    return fetchedResultsCtrl.fetchedObjects ?? []
  }

  func updateWithData(_ data: Data, for id: Int64) throws {
    let lesson = try repository.fetchFirst(predicate: LessonData.Predicates.primaryKey(Int(id)).predicate)
    lesson?.thumbnail = data
    repository.saveContext()
  }

  func updateDownloadState(_ state: LessonData.DownloadState, for id: Int64) throws {
    let lesson = try repository.fetchFirst(predicate: LessonData.Predicates.primaryKey(Int(id)).predicate)
    lesson?.downloadStateEnum = state
    repository.saveContext()
  }
}

extension LessonsRepository: NSFetchedResultsControllerDelegate {
  func controller(
    _ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?
  ) {
    if let lesson = anObject as? LessonData {
      lessonsPublisher.send((lesson, type))
    }
  }
}
