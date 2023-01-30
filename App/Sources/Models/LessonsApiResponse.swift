//
//  LessonsApiResponse.swift
//  LessonsTests
//
//  Created by Ramy Rizkalla on 26/01/2023.
//

import Foundation

struct LessonsApiResponse: Decodable {
  let lessons: [Lesson]
}
