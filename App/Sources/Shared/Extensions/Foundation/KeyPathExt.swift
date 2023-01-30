//
//  KeyPathExt.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 27/01/2023.
//

import Foundation

extension KeyPath {
  var pathStringValue: String {
    NSExpression(forKeyPath: self).keyPath
  }
}
