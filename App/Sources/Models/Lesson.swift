//
//  Lesson.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 26/01/2023.
//

import Foundation

struct Lesson: Decodable, Identifiable {
  let id: Int
  let name: String
  let description: String
  let thumbnail: String
  let videoUrl: String
}

extension Lesson: DataModelConverter {
  var dataModel: [PartialKeyPath<LessonData>: Any] {
    [
      \.id: Int64(id),
       \.name: name,
       \.lessonDescription: description,
       \.thumbnailUrl: thumbnail,
       \.videoRemoteUrl: videoUrl
    ]
  }
}
