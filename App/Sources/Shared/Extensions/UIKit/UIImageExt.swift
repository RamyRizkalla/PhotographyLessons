//
//  UIImageExt.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 28/01/2023.
//

import Foundation
import UIKit

extension UIImage {
  convenience init?(sfSymbol: SFSymbol) {
    self.init(systemName: sfSymbol.rawValue)
  }
}
