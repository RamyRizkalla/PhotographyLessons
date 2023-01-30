//
//  LessonDetailsViewModel.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 26/01/2023.
//

import Combine
import Foundation
import SwiftUI

final class LessonDetailsViewModel {
  @Environment(\.lessonRepository) var lessonsRepository

  private(set) var lesson: LessonData
  private var lessonsList: [LessonData]
  private let downloadManager = DownloadManager<Int>()
  private var cancellables = Set<AnyCancellable>()

  weak var delegate: LessonDetailsDelegate?

  /// Returns `true` if this is the last lesson in the list.
  var isLastLesson: Bool {
    guard let lessonIndex = indexOfCurrentLesson else { return true }
    return lessonIndex == lessonsList.count - 1
  }

  private var indexOfCurrentLesson: Int? {
    lessonsList.firstIndex(of: lesson)
  }

  /// Returns te title for the right bar button depending on the download status of the video.
  var rightButtonTitle: String {
    switch lesson.downloadStateEnum {
    case .downloaded:
      return "Downloaded"
    case .inProgress:
      return "Cancel"
    case .notDownloaded:
      return "Download"
    }
  }

  /// Returns the local url of the video if it's downloaded, otherwise returns the server url.
  var videoUrl: URL {
    if let stringUrl = lesson.videoLocalUrl {
      return .init(fileURLWithPath: stringUrl)
    }
    else {
      return .init(string: lesson.videoRemoteUrl!)!
    }
  }

  // MARK: - Initializer

  init(lessonsList: [LessonData], selectedLesson: LessonData) {
    self.lessonsList = lessonsList
    self.lesson = selectedLesson
    self.observeDownloadOperation()
  }

  private func observeDownloadOperation() {
    downloadManager
      .progressPublisher
      .sink { [weak self] fractionCompletion in
        self?.delegate?.updateProgress(fractionCompletion)
      }
      .store(in: &cancellables)

    downloadManager
      .completionPublisher
      .sink { [weak self] (url, id) in
        guard let self else { return }
        self.lesson.videoLocalUrl = url.absoluteString
        try? self.lessonsRepository.updateDownloadState(.downloaded, for: self.lesson.id)
        self.delegate?.updateDownloadButton(title: self.rightButtonTitle)
        self.delegate?.setProgressBarVisibility(false)
      }
      .store(in: &cancellables)
  }
}

// MARK: - User Actions Handling

extension LessonDetailsViewModel {
  func navigateToNextLesson() {
    guard !isLastLesson, let lessonIndex = indexOfCurrentLesson else { return }
    lesson = lessonsList[lessonIndex + 1]
    delegate?.updateView()
  }

  func performRightBarButtonAction() {
    switch lesson.downloadStateEnum {
    case .notDownloaded:
      try? lessonsRepository.updateDownloadState(.inProgress, for: lesson.id)
      delegate?.setProgressBarVisibility(true)
      downloadManager.fetchWithProgress(url: URL(string: lesson.videoRemoteUrl!)!, identifier: lesson.primaryKey)
    case .inProgress:
      try? lessonsRepository.updateDownloadState(.notDownloaded, for: lesson.id)
      downloadManager.cancel(identifier: lesson.primaryKey)
      delegate?.setProgressBarVisibility(false)
    case .downloaded:
      return
    }
    delegate?.updateDownloadButton(title: rightButtonTitle)
  }
}
