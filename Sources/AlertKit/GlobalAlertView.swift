//
//  GlobalAlertView.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI

public struct GlobalAlertView<Content>: View where Content : View {
    @StateObject private var alertState: AlertState
    private var overlayBackground: AnyShapeStyle
    private var alertBackground: AnyShapeStyle? = nil
    private var alertStackView: ((AlertState) -> Content)? = nil
    private var accentColor: Color = .accentColor
    private var content: Content

    public init<OB, AB>(
        overlayBackground: OB = .ultraThinMaterial,
        alertBackground: AB? = nil,
        @ViewBuilder alertStackView: @escaping (AlertState) -> Content,
        @ViewBuilder content: () -> Content
    ) where OB : ShapeStyle, AB : ShapeStyle {
        _alertState = StateObject(wrappedValue: .init())
        self.overlayBackground = AnyShapeStyle(overlayBackground)
        if let alertBackgorund = alertBackground {
            self.alertBackground = AnyShapeStyle(alertBackgorund)
        }
        self.alertStackView = alertStackView
        self.content = content()
    }

    public init<S>(
        overlayBackground: S = .ultraThinMaterial,
        alertBackground: S? = nil,
        accentColor: Color,
        @ViewBuilder content: () -> Content
    ) where S : ShapeStyle {
        _alertState = StateObject(wrappedValue: .init())
        self.overlayBackground = AnyShapeStyle(overlayBackground)
        if let alertBackground = alertBackground {
            self.alertBackground = AnyShapeStyle(alertBackground)
        }
        self.accentColor = accentColor
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
                    accentColor: accentColor
                )
            }
        }
    }
}

struct GlobalAlertView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalAlertView(accentColor: .orange) {
//            Color.red
            Text("Hello Little Torben")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
        }
    }
}
