//
//  Persistence.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 24/01/2023.
//

import CoreData

final class PersistenceController {
  static let shared = PersistenceController()

  #if DEBUG
    static var preview: PersistenceController = .init(inMemory: true)
  #endif

  /// Used for unit tests.
  static var test: PersistenceController = .init(inMemory: true)

  let container: NSPersistentContainer
  private let notificationCenter = NotificationCenter.default

  private(set) lazy var viewContext: NSManagedObjectContext = {
    container.viewContext
  }()

  var privateManagedObjectContext: NSManagedObjectContext {
    container.newBackgroundContext().with {
      $0.automaticallyMergesChangesFromParent = true
    }
  }

  init(inMemory: Bool = false) {
    container = .init(name: AppConstants.databaseName)
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        print(error)
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
  }

  func saveContext(_ context: NSManagedObjectContext) {
    guard context.hasChanges else { return }

    let observer = notificationCenter.addObserver(
      forName: .NSManagedObjectContextDidSave,
      object: context,
      queue: .main
    ) { notification in
      self.viewContext.mergeChanges(fromContextDidSave: notification)
    }
    context.performAndWait {
      try? context.save()
    }
    notificationCenter.removeObserver(observer)
  }
}
