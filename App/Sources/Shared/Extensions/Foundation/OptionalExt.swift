//
//  OptionalExt.swift
//  LessonsUITests
//
//  Created by Ramy Rizkalla on 29/01/2023.
//

import Foundation

extension Optional where Wrapped == String {
  var isNilOrEmpty: Bool {
    guard let self else { return true }
    return self.isEmpty
  }
}
