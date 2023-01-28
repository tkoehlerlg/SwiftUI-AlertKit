//
//  AlertView.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI
import SwiftUIX

struct AlertView: View {
    var alert: AKAlert
    var background: AnyShapeStyle
    var accentColor: Color
    var textColor: Color
    var closeAlert: () -> Void

    init<S>(
        alert: AKAlert,
        background: S = .thinMaterial,
        accentColor: Color,
        textColor: Color,
        closeAlert: @escaping () -> Void
    ) where S : ShapeStyle {
        self.alert = alert
        self.background = AnyShapeStyle(background)
        self.accentColor = accentColor
        self.textColor = textColor
        self.closeAlert = closeAlert
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(alert.title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(textColor)
                .padding(.top, 15)
            Text(alert.message)
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .foregroundColor(textColor)
                .padding(.top, 2)
                .padding(.bottom, 5)
            VStack(spacing: 10) {
                ForEach(alert.buttons, id: \.id) { button in
                    let buttonView = Button(action: {
                        button.action()
                        withAnimation {
                            closeAlert()
                        }
                    }, label: {
                        Text(button.title)
                    })
                    buttonView
                        .buttonStyle(AKButtonStyle(getBlueprint(button.style)))
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

    func getBlueprint(_ style: AKButton.Style) -> AKButtonStyleBlueprint {
        switch style {
        case .system(let systemStyle):
            switch systemStyle {
            case .primary:
                return .primary(accentColor: accentColor, textColor: .white)
            case .secondary:
                return .secondary(accentColor: accentColor)
            case .destructive:
                return .destructive()
            }
        case .custom(let blueprint):
            return blueprint
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(
            alert: AKAlert.mock,
            accentColor: .blue,
            textColor: .primary,
            closeAlert: {}
        )
    }
}
