//
//  LessonsApp.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 24/01/2023.
//

import SwiftUI

@main
struct LessonsApp: App {
  init() {
    setNavigationBarAppearance()
  }

  private func setNavigationBarAppearance() {
    let barAppearance = UINavigationBarAppearance().with {
      $0.backgroundColor = Colors.accent.uiColor
      $0.titleTextAttributes = [.foregroundColor: UIColor.white]
      $0.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    let navigationBar = UINavigationBar.appearance()
    navigationBar.standardAppearance = barAppearance
    navigationBar.scrollEdgeAppearance = barAppearance
  }

  var body: some Scene {
    WindowGroup {
      LessonsListView(viewModel: .init())
        .ignoresSafeArea()
    }
  }
}
