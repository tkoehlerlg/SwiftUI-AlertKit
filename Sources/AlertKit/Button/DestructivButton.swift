//
//  DestructivButtonStyle.swift
//  
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI

struct DestructivButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(configuration.isPressed ? .white : .red)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? .red : .clear)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.red, lineWidth: 4.5)
            }
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct DestructivButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Text", action: {})
            .buttonStyle(DestructivButtonStyle())
            .padding()
    }
}
