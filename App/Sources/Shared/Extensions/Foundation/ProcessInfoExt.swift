//
//  ProcessInfoExt.swift
//  LessonsUITests
//
//  Created by Ramy Rizkalla on 29/01/2023.
//

import Foundation

extension ProcessInfo {
  enum Argument: String {
    case uitest = "-UITesting"
  }

  var isUITesting: Bool {
    return arguments.contains(Argument.uitest.rawValue)
  }
}
