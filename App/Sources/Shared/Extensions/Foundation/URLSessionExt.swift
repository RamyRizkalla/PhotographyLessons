//
//  URLSessionExt.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 26/01/2023.
//

import Combine
import Foundation

extension URLSession {
  public func downloadTaskPublisher(for url: URL, identifier: any Hashable) -> DownloadTaskPublisher {
    downloadTaskPublisher(for: .init(url: url), identifier: identifier)
  }

  public func downloadTaskPublisher(for request: URLRequest, identifier: any Hashable) -> DownloadTaskPublisher {
    .init(request: request, session: self, identifier: identifier)
  }
}

extension URLSession {
  public struct DownloadTaskPublisher: Publisher {
    public struct PublisherOutput {
      let downloadUrl: URL?
      let identifier: any Hashable
      let fractionCompleted: Double
    }

    public typealias Output = PublisherOutput
    public typealias Failure = Error

    let request: URLRequest
    let session: URLSession
    let identifier: any Hashable

    public init(
      request: URLRequest,
      session: URLSession,
      identifier: any Hashable
    ) {
      self.request = request
      self.session = session
      self.identifier = identifier
    }

    public func receive<S: Subscriber>(subscriber: S) where DownloadTaskPublisher.Failure == S.Failure, DownloadTaskPublisher.Output == S.Input {
      let subscription = DownloadTaskSubscription(
        subscriber: subscriber,
        session: self.session,
        request: self.request,
        identifier: identifier
      )
      subscriber.receive(subscription: subscription)
    }
  }

  final class DownloadTaskSubscription<SubscriberType: Subscriber>: NSObject, Subscription, URLSessionDownloadDelegate where
  SubscriberType.Input == DownloadTaskPublisher.Output,
  SubscriberType.Failure == DownloadTaskPublisher.Failure
  {
    private var subscriber: SubscriberType?
    private var session: URLSession?
    private var request: URLRequest!
    private var downloadTask: URLSessionDownloadTask?
    private let identifier: any Hashable

    init(
      subscriber: SubscriberType,
      session: URLSession,
      request: URLRequest,
      identifier: any Hashable
    ) {
      self.subscriber = subscriber
      self.session = session
      self.request = request
      self.identifier = identifier
    }

    func request(_ demand: Subscribers.Demand) {
      guard demand > 0 else { return }
      self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
      downloadTask = session?.downloadTask(with: request)
      downloadTask?.resume()
    }

    func cancel() {
      self.downloadTask?.cancel()
      self.session?.invalidateAndCancel()
      self.session = nil
    }

    func urlSession(
      _ session: URLSession,
      downloadTask: URLSessionDownloadTask,
      didFinishDownloadingTo location: URL
    ) {
      do {
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
          subscriber?.receive(completion: .failure(URLError(.fileDoesNotExist)))
          return
        }

        let fileUrl = cacheDir.appendingPathComponent("\(UUID().uuidString).\(request.url!.pathExtension)")
        try FileManager.default.moveItem(atPath: location.path, toPath: fileUrl.path)
        _ = subscriber?.receive(
          .init(downloadUrl: fileUrl, identifier: identifier, fractionCompleted: 1)
        )
        subscriber?.receive(completion: .finished)
      }
      catch {
        subscriber?.receive(completion: .failure(URLError(.cannotCreateFile)))
      }
    }

    func urlSession(
      _ session: URLSession,
      downloadTask: URLSessionDownloadTask,
      didWriteData bytesWritten: Int64,
      totalBytesWritten: Int64,
      totalBytesExpectedToWrite: Int64
    ) {
      let fractionCompleted: Double = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
      _ = subscriber?.receive(
        .init(downloadUrl: nil, identifier: identifier, fractionCompleted: fractionCompleted)
      )
    }
  }
}
