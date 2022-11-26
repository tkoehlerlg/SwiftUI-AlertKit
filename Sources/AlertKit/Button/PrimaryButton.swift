//
//  PrimaryButtonStyle.swift
//  
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var accentColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(accentColor)
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Button("Text", action: {})
            .buttonStyle(PrimaryButtonStyle(accentColor: .orange))
            .padding()
    }
}
