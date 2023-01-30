//
//  ImageExt.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 27/01/2023.
//

import SwiftUI

extension Image {
  init?(data: Data?) {
    guard let data = data, let image = UIImage(data: data) else { return nil }
    self = .init(uiImage: image)
  }
}
