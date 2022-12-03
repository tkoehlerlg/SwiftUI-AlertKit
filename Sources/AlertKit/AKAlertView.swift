//
//  AlertView.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI
import SystemColors

struct AlertView: View {
    var alert: AKAlert
    var background: AnyShapeStyle
    var accentColor: Color
    var fontColor: Color
    var closeAlert: () -> Void

    init<S>(
        alert: AKAlert,
        background: S = .thinMaterial,
        accentColor: Color,
        fontColor: Color = .primary,
        closeAlert: @escaping () -> Void
    ) where S : ShapeStyle {
        self.alert = alert
        self.background = AnyShapeStyle(background)
        self.accentColor = accentColor
        self.fontColor = fontColor
        self.closeAlert = closeAlert
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(alert.title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(fontColor)
                .padding(.top, 15)
            Text(alert.message)
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .foregroundColor(fontColor)
                .padding(.top, 2)
                .padding(.bottom, 5)
            VStack(spacing: 10) {
                ForEach(alert.buttons, id: \.id) { button in
                    let buttonView = Button(action: {
                        withAnimation {
                            closeAlert()
                        }
                        button.action()
                    }, label: {
                        Text(button.title)
                    })
                    buttonView
                        .buttonStyle(AKButtonStyle(button.style))
                }
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(background)
        .cornerRadius(15)
        .padding(40)
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(
            alert: AKAlert.mock,
            accentColor: .blue,
            closeAlert: {}
        )
    }
}