//
//  LessonDetailsRepository.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 27/01/2023.
//

import Foundation
import CoreData

/// Enum for CoreData related errors
enum CoreDataError: Error {
  case invalidManagedObjectType
}

/// Generic class for handling NSManagedObject subclasses.
class CoreDataRepository<T: NSManagedObject>: Repository {
  typealias Entity = T
  
  /// The NSManagedObjectContext instance to be used for performing the operations.
  let managedObjectContext: NSManagedObjectContext
  
  /// Designated initializer.
  /// - Parameter managedObjectContext: The NSManagedObjectContext instance to be used for performing the operations.
  init(managedObjectContext: NSManagedObjectContext) {
    self.managedObjectContext = managedObjectContext
  }
  
  func create() -> Result<Entity, Error> {
    let className = String(describing: Entity.self)
    guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className, into: managedObjectContext) as? Entity else {
      return .failure(CoreDataError.invalidManagedObjectType)
    }
    return .success(managedObject)
  }
  
  func delete(entity: Entity) {
    managedObjectContext.delete(entity)
  }

  func batchInsert(_ objects: [[PartialKeyPath<Entity>: Any]]) throws {
    let lessonsMap = objects.map {
      $0.mapKeys(transform: \.stringValue)
    }

    let batchInsert = NSBatchInsertRequest(entity: Entity.entity(), objects: lessonsMap).with {
      $0.resultType = .objectIDs
    }

    let batchInsertResult = try managedObjectContext.execute(batchInsert) as? NSBatchInsertResult
    guard let insertResult = batchInsertResult?.result as? [NSManagedObjectID] else {
      throw CoreDataError.invalidManagedObjectType
    }
    let insertedObjects: [AnyHashable: Any] = [NSInsertedObjectsKey: insertResult]
    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: insertedObjects, into: [managedObjectContext])
  }
  
  func fetchFirst(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> T? {
    try fetch(predicate: predicate, sortDescriptors: sortDescriptors).first
  }
  
  func fetch(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Entity] {
    let fetchRequest = Entity.fetchRequest().with {
      $0.predicate = predicate
      $0.sortDescriptors = sortDescriptors
    }

    if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [Entity] {
      return fetchResults
    } else {
      throw CoreDataError.invalidManagedObjectType
    }
  }
  
  func saveContext() {
    PersistenceController.shared.saveContext(managedObjectContext)
  }
}
