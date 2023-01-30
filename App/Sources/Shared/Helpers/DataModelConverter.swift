//
//  DataModelConverted.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 27/01/2023.
//

import CoreData
import Foundation

protocol DataModelConverter {
  associatedtype Model: NSManagedObject

  var dataModel: [PartialKeyPath<Model>: Any] { get }
}
