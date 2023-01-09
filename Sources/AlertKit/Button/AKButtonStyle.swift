//
//  AKButtonStyle.swift
//  
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI

struct AKButtonStyle: ButtonStyle {
    var buttonStyle: AKButtonStyleBlueprint

    init(_ buttonStyle: AKButtonStyleBlueprint) {
        self.buttonStyle = buttonStyle
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(textColor(configuration.isPressed))
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(backgroundColor(configuration.isPressed))
            .overlay {
                if showStroke(configuration.isPressed) {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(strokeColor(configuration.isPressed), lineWidth: 4.5)
                }
            }
            .cornerRadius(15)
            .contentShape(RoundedRectangle(cornerRadius: 15))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }

    func textColor(_ isPressed: Bool) -> Color {
        return isPressed ? buttonStyle.isPressedTextColor ?? buttonStyle.textColor : buttonStyle.textColor
    }

    func backgroundColor(_ isPressed: Bool) -> Color {
        return isPressed ? buttonStyle.isPressedBackgroundColor ?? buttonStyle.backgroundColor : buttonStyle.backgroundColor
    }

    func showStroke(_ isPressed: Bool) -> Bool {
        return isPressed ? (buttonStyle.isPressedBorderColor ?? buttonStyle.borderColor) != nil : buttonStyle.borderColor != nil
    }

    func strokeColor(_ isPressed: Bool) -> Color {
        return isPressed ? buttonStyle.isPressedBorderColor ?? buttonStyle.borderColor ?? .clear : buttonStyle.borderColor ?? .clear
    }
}

struct DestructivButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Text", action: {})
            .buttonStyle(AKButtonStyle(.primary(accentColor: .orange, textColor: .white)))
            .padding()
    }
}
