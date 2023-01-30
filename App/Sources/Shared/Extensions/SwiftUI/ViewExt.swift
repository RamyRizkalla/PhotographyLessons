//
//  ViewExt.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 29/01/2023.
//

import SwiftUI

extension View {
  /// Convenience method that uses `AccessibilityIdentifiable`.
  func accessibilityIdentifier(
    _ identifier: any AccessibilityIdentifiable
  ) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
    self.accessibilityIdentifier(identifier.rawValue)
  }
}
