//
//  FileManagerExt.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 26/01/2023.
//

import Foundation

extension FileManager {
  func secureCopyItem(at srcURL: URL) -> URL? {
    do {
      let path = self.urls(for: .documentDirectory, in: .userDomainMask).first
      guard let dstURL = path?.appendingPathComponent("\(UUID().uuidString).\(srcURL.pathExtension)") else { return nil }

      if FileManager.default.fileExists(atPath: dstURL.path) {
        try FileManager.default.removeItem(at: dstURL)
      }
      try FileManager.default.copyItem(at: srcURL, to: dstURL)
      return dstURL
    }
    catch {
      logger.error(error.localizedDescription)
      return nil
    }
  }
}
