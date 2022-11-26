//
//  SecondaryButtonStyle.swift
//  
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    var accentColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(accentColor)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(accentColor, lineWidth: 4.5)
            }
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Text", action: {})
            .buttonStyle(SecondaryButtonStyle(accentColor: .orange))
            .padding()
    }
}
