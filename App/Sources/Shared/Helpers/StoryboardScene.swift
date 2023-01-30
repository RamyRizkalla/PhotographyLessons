//
//  StoryboardScene.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 27/01/2023.
//

import UIKit

enum StoryboardScene {
  enum LessonDetails {
    static let storyboardName = "LessonDetails"

    static let lessonDetails = SceneType<LessonDetailsViewController>(storyboardName: storyboardName, identifier: "LessonDetailsViewController")
  }
}

extension StoryboardScene {
  struct SceneType<ViewController: UIViewController> {
    let storyboardName: String
    let identifier: String

    func instantiate() -> ViewController {
      let storyBoard = UIStoryboard(name: storyboardName, bundle: .main)
      guard let viewCtrl = storyBoard.instantiateViewController(withIdentifier: identifier) as? ViewController else {
        fatalError()
      }
      return viewCtrl
    }
  }
}
