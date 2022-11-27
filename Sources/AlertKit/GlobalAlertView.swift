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
    private var alertBackgorund: AnyShapeStyle? = nil
    private var alertStackView: ((AlertState) -> Content)? = nil
    private var accentColor: Color = .accentColor
    private var content: Content

    public init<S>(
        overlayBackground: S = .ultraThinMaterial,
        alertBackgorund: S? = nil,
        @ViewBuilder alertStackView: @escaping (AlertState) -> Content,
        @ViewBuilder content: () -> Content
    ) where S : ShapeStyle {
        _alertState = StateObject(wrappedValue: .init())
        self.overlayBackground = AnyShapeStyle(overlayBackground)
        if let alertBackgorund = alertBackgorund {
            self.alertBackgorund = AnyShapeStyle(alertBackgorund)
        }
        self.alertStackView = alertStackView
        self.content = content()
    }

    public init<S>(
        overlayBackground: S = .ultraThinMaterial,
        alertBackgorund: S? = nil,
        accentColor: Color,
        @ViewBuilder content: () -> Content
    ) where S : ShapeStyle {
        _alertState = StateObject(wrappedValue: .init())
        self.overlayBackground = AnyShapeStyle(overlayBackground)
        if let alertBackgorund = alertBackgorund {
            self.alertBackgorund = AnyShapeStyle(alertBackgorund)
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
