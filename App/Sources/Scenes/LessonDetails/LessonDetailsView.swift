//
//  LessonDetailsView.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 26/01/2023.
//

import SwiftUI

/// A SwiftUI wrapper arounf `LessonDetailsViewController`.
struct LessonDetailsView: UIViewControllerRepresentable {
  let viewModel: LessonDetailsViewModel

  func makeUIViewController(context: Context) -> LessonDetailsViewController {
    let viewCtrl = StoryboardScene.LessonDetails.lessonDetails.instantiate()
    viewCtrl.viewModel = viewModel
    return viewCtrl
  }

  func updateUIViewController(_ uiViewController: LessonDetailsViewController, context: Context) {
    // Not needed.
  }
}
