//
//  LessonDetailsRepository.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 27/01/2023.
//

import Foundation

protocol Repository {
  associatedtype Entity
  
  func create() -> Result<Entity, Error>
  func delete(entity: Entity)
  func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> [Entity]
  func fetchFirst(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> Entity?
}
