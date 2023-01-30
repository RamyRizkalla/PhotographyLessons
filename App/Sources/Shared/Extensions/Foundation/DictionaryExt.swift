//
//  DictionaryExt.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 27/01/2023.
//

import Foundation

extension Dictionary {
  func mapKeys<T: Hashable>(transform: (Key) -> T) -> [T: Value] {
    .init(
      uniqueKeysWithValues: map { (transform($0), $1) }
    )
  }
}
