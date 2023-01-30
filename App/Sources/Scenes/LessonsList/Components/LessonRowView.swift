//
//  LessonRowView.swift
//  Lessons
//
//  Created by Ramy Rizkalla on 24/01/2023.
//

import SwiftUI

struct LessonRowView: View {
  let imageData: Data?
  let text: String

  var body: some View {
    HStack {
      image
        .renderingMode(.original)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 100, height: 60)
        .cornerRadius(AppConstants.cornerRadius)
        .padding(.trailing, 10)
        .accessibilityIdentifier(AccessibilityIdentifier.List.image)

      Text(text)
        .font(.system(size: 16))
        .accessibilityIdentifier(AccessibilityIdentifier.List.title)
    }
  }

  var image: Image {
    if let imageData = imageData {
      return Image(data: imageData)!
    }
    else {
      return Image("LoadingImage")
    }
  }
}

struct LessonRowView_Previews: PreviewProvider {
  static var previews: some View {
    LessonRowView(
      imageData: Data(),
      text: "The Key To Success In iPhone Photography"
    )
  }
}
