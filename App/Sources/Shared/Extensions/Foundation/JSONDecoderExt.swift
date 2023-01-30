//
//  JSONDecoderExt.swift
//  LessonsTests
//
//  Created by Ramy Rizkalla on 26/01/2023.
//

import Foundation

extension JSONDecoder {
  static let standard: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    return jsonDecoder
  }()
}
