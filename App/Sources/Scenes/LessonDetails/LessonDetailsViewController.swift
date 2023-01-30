//
//  LessonDetailsViewController.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 26/01/2023.
//

import AVKit
import Foundation
import UIKit

protocol LessonDetailsDelegate: AnyObject {
  func updateProgress(_ progress: Double)
  func updateDownloadButton(title: String)
  func updateView()
  func setProgressBarVisibility(_ visible: Bool)
}

class LessonDetailsViewController: UIViewController {
  @IBOutlet private var playerContainerView: UIView!
  @IBOutlet private var playImageView: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!
  @IBOutlet private var nextLessonButton: UIButton!
  @IBOutlet private var progressView: UIProgressView!

  private let playerViewController = AVPlayerViewController()
  private var downLoadButton = UIButton(type: .custom)

  var viewModel: LessonDetailsViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupNavigationView()
    viewModel.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationItem.largeTitleDisplayMode = .never
    playerViewController.player?.pause()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupPlayerView()
  }

  @IBAction private func nextLessonPressed() {
    viewModel.navigateToNextLesson()
  }

  private func setupPlayerView() {
    let player = AVPlayer(url: viewModel.videoUrl)
    playerViewController.player = player
    let playerLayer = AVPlayerLayer(player: player).with {
      $0.frame = self.playerContainerView.frame
      $0.videoGravity = .resizeAspectFill
    }
    if let oldPlayerLayer = self.oldPlayerLayer() {
      playerContainerView.layer.replaceSublayer(oldPlayerLayer, with: playerLayer)
    }
    else {
      playerContainerView.layer.insertSublayer(playerLayer, at: 0)
    }
  }

  private func oldPlayerLayer() -> CALayer? {
    if let sublayers = playerContainerView.layer.sublayers, sublayers.count > 1 {
      return sublayers.first
    }
    return nil
  }

  private func setupViews() {
    setupLabels()
    setupPlayImageViewinteraction()
    nextLessonButton.isHidden = viewModel.isLastLesson
    progressView.progress = 0
    progressView.isHidden = true
  }

  private func setupLabels() {
    titleLabel.text = viewModel.lesson.name
    titleLabel.accessibilityIdentifier = AccessibilityIdentifier.Details.title.rawValue
    descriptionLabel.text = viewModel.lesson.lessonDescription
    descriptionLabel.accessibilityIdentifier = AccessibilityIdentifier.Details.description.rawValue
  }

  private func setupPlayImageViewinteraction() {
    playImageView.isUserInteractionEnabled = true
    playImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playVideo)))
  }

  private func setupNavigationView() {
    self.downLoadButton = UIButton(type: .custom).with {
      $0.tintColor = .systemBlue
      $0.setTitleColor(.systemBlue, for: .normal)
      $0.setTitle(viewModel.rightButtonTitle, for: .normal)
      $0.setImage(.init(sfSymbol: .icloudAndArrowDown), for: .normal)
      $0.addAction(
        .init { [weak self] action in
          self?.viewModel.performRightBarButtonAction()
        },
        for: .primaryActionTriggered
      )
    }
    DispatchQueue.main.async {
      self.navigationController?.navigationBar.topItem?.rightBarButtonItem = .init(customView: self.downLoadButton)
    }
  }

  @objc private func playVideo() {
    present(playerViewController, animated: true) { [weak self] in
      self?.playerViewController.player?.play()
    }
  }
}

extension LessonDetailsViewController: LessonDetailsDelegate {
  func updateProgress(_ progress: Double) {
    DispatchQueue.main.async { [weak progressView] in
      progressView?.progress = Float(progress)
    }
  }

  func updateDownloadButton(title: String) {
    DispatchQueue.main.async { [weak downLoadButton] in
      downLoadButton?.setTitle(title, for: .normal)
    }
  }

  func updateView() {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      UIView.transition(
        with: self.view,
        duration: AppConstants.animationsDuration,
        options: .transitionCrossDissolve
      ) {
        self.setupViews()
        self.setupPlayerView()
      }
    }
  }

  func setProgressBarVisibility(_ visible: Bool) {
    DispatchQueue.main.async { [weak progressView] in
      progressView?.isHidden = !visible
    }
  }
}
