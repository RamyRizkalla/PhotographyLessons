//
//  Withable.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 27/01/2023.
//

import Foundation

public protocol Withable {
  /* no requirements */
}

extension Withable {
  func with(_ config: (inout Self) throws -> Void) rethrows -> Self {
    var copy = self
    try config(&copy)
    return copy
  }
}
