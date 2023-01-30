//
//  Colors.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 28/01/2023.
//

import SwiftUI
import UIKit

enum Colors: String {
  case accent = "Accent"

  var uiColor: UIColor {
    .init(named: self.rawValue)!
  }

  var color: Color {
    .init(self.rawValue)
  }
}
