//
//  LessonsListViewModel.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 24/01/2023.
//

import Combine
import SwiftUI

final class LessonsListViewModel: ObservableObject {
  @Environment(\.apiProvider) var apiProvider
  @Environment(\.lessonRepository) var lessonRepository

  @Published var lessons = [LessonData]()
  @Published private(set) var errorText: String?

  let screenTitle = "Lessons"

  private var cancellables = Set<AnyCancellable>()

  init() {
    self.observeLessonDataChanges()
  }

  private func observeLessonDataChanges() {
    lessonRepository.lessonsPublisher
      .sink { [weak self] (lesson, type) in
        switch type {
        case .insert:
          self?.lessons.append(lesson)
          self?.lessons.sort(by: { $0.id < $1.id })
        case .delete:
          self?.lessons.removeAll { $0.id == lesson.id }
        case .move, .update:
          if let index = self?.lessons.firstIndex(where: { $0.id == lesson.id }) {
            self?.lessons[index] = lesson
          }
        @unknown default:
          logger.error("Unsupported change type \(type)")
        }
      }
      .store(in: &cancellables)
  }

  func requestLessons() {
    apiProvider.performRequest(.lessons)
      .map(\.lessons)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          if completion != .finished {
            self?.fetchLessonsLocally()
          }
        },
        receiveValue: { lessonsResponse in
          do {
            try self.lessonRepository.batchInsert(lessonsResponse)
          } catch {
            print(error)
          }
          self.fetchLessonsLocally()
          self.downLoadImages()
        }
      )
      .store(in: &cancellables)
  }

  private func downLoadImages() {
    var index = 0
    lessons
      .filter { $0.thumbnail == nil }
      .publisher
      .flatMap(maxPublishers: .max(1)) { lesson in
        URLSession.shared.dataTaskPublisher(for: URL(string: lesson.thumbnailUrl!)!)
      }
      .map(\.data)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { result in
          print(result)
        },
        receiveValue: { [weak self] data in
          if let lesson = self?.lessons[index] {
            try? self?.lessonRepository.updateWithData(data, for: lesson.id)
            index += 1
          }
        }
      )
      .store(in: &cancellables)
  }

  private func fetchLessonsLocally() {
    do {
      self.lessons = try lessonRepository.fetch(sortDescriptors: [.init(keyPath: \LessonData.id, ascending: true)])
    }
    catch {

    }
  }
}
