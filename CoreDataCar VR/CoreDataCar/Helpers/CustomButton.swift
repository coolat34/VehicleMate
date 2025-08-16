//
//  CustomButton.swift
//  Buttons and TabItems
//
//  Created by Chris Milne on 24/09/2023.
//    let buttonWidth = Size.screenWidth/1.3
//    let buttonHeight = Size.screenHeight/5

import SwiftUI

struct CustomButton: View {
    let label: String
    let width: Int
    let height: Int
    let isDisabled: Bool

    init(label: String, width: Int = 200, height: Int = 38, isDisabled: Bool = false) {
      self.label = label
      self.width = width
        self.height = height
      self.isDisabled = isDisabled
    }

    
    var body: some View {
      Text("\(label)").fontWeight(.bold)
        .foregroundColor(Color.white)
        .frame(width: CGFloat(width), height: CGFloat(height), alignment: .center)
        .background(isDisabled ? Color.teal: Color.blue)
        .cornerRadius(16, antialiased: true)
        .padding()
        .animation(.easeInOut, value: isDisabled)
    }
  }

  struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
      CustomButton(label: "This is the label", isDisabled: true)
    }
  }
