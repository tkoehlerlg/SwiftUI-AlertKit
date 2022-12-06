//
//  GlobalAlertView.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI

public struct GlobalAKAlertView<Content>: View where Content : View {
    @StateObject private var alertState: AKAlertState
    private var accentColor: Color = .accentColor
    private var textColor: Color = .primary
    private var alertBackground: AnyShapeStyle = .init(.white)
    private var overlayBackground: AnyShapeStyle
    private var alertStackView: ((AKAlertState) -> Content)? = nil
    private var content: Content

    public init<OB>(
        textColor: Color = .primary,
        overlayBackground: OB = .ultraThinMaterial,
        @ViewBuilder alertStackView: @escaping (AKAlertState) -> Content,
        @ViewBuilder content: () -> Content
    ) where OB : ShapeStyle {
        _alertState = StateObject(wrappedValue: .init())
        self.overlayBackground = AnyShapeStyle(overlayBackground)
        self.textColor = textColor
        self.alertStackView = alertStackView
        self.content = content()
    }

    public init<OB, AB>(
        accentColor: Color = .accentColor,
        textColor: Color = .primary,
        alertBackground: AB = .white,
        overlayBackground: OB = .ultraThinMaterial,
        @ViewBuilder content: () -> Content
    ) where OB : ShapeStyle, AB : ShapeStyle {
        _alertState = StateObject(wrappedValue: .init())
        self.overlayBackground = AnyShapeStyle(overlayBackground)
        self.alertBackground = AnyShapeStyle(alertBackground)
        self.accentColor = accentColor
        self.textColor = textColor
        self.content = content()
    }

    public var body: some View {
        content
            .environment(\.alertState, alertState)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                if alertState.alerts.count > 0 {
                    createAlertStackView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .background(overlayBackground)
                }
            }
    }

    private func createAlertStackView() -> some View {
        Group {
            if let alertStackView = alertStackView {
                alertStackView(alertState)
            } else {
                AlertStackView(
                    alertState: alertState,
                    alertBackground: alertBackground,
                    accentColor: accentColor,
                    textColor: textColor
                )
            }
        }
    }
}

struct GlobalAlertView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalAKAlertView(accentColor: .orange) {
//            Color.red
            Text("Hello Little Torben")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
        }
    }
}
