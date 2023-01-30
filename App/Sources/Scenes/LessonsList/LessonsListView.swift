//
//  LessonsListView.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 24/01/2023.
//

import SwiftUI

struct LessonsListView: View {
  @ObservedObject var viewModel: LessonsListViewModel

  var body: some View {
    NavigationView {
      List(viewModel.lessons, id: \.id) { lesson in
        NavigationLink {
          LessonDetailsView(
            viewModel: .init(
              lessonsList: viewModel.lessons,
              selectedLesson: lesson
            )
          )
          .ignoresSafeArea(edges: .bottom)
        } label: {
          LessonRowView(
            imageData: lesson.thumbnail,
            text: lesson.name!
          )
        }
        .listRowBackground(Colors.accent.color.ignoresSafeArea())
        .foregroundColor(.white)
        .listItemTint(.blue)
      }
      .onAppear {
        viewModel.requestLessons()
      }
      .listStyle(.plain)
      .navigationViewStyle(.stack)
      .navigationTitle(viewModel.screenTitle)
      .ignoresSafeArea(edges: .bottom)
    }
  }
}

#if DEBUG
struct LessonsListView_Previews: PreviewProvider {
  static var previews: some View {
    LessonsListView(viewModel: .init())
  }
}
#endif
