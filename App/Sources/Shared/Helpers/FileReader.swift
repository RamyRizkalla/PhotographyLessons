//
//  FileReader.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 29/01/2023.
//

import Foundation

enum FileReader {
  static func readJson(_ name: String, bundle: Bundle = Bundle.main) -> Data? {
    guard let bundlePath = Bundle.main.path(forResource: name, ofType: "json") else { return nil }
    return try? String(contentsOfFile: bundlePath).data(using: .utf8)
  }
}
