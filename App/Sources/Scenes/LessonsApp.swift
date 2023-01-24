//
//  LessonsApp.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 24/01/2023.
//

import SwiftUI

@main
struct LessonsApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
