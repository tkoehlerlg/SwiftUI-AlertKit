//
//  GlobalAlertView.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

public struct GlobalAlertView<Content>: View where Content : View {
    @BindableState private var alertState: AlertState
    private var overlayBackground: AnyShapeStyle
    private var alertStackView: ((AlertState) -> Content)? = nil
    private var accentColor: Color = .accentColor
    private var content: Content

    public init<S>(
        alertState: BindableState<AlertState>? = nil,
        overlayBackground: S = .ultraThinMaterial,
        @ViewBuilder alertStackView: @escaping (AlertState) -> Content,
        @ViewBuilder content: () -> Content
    ) where S : ShapeStyle {
        _alertState = alertState ?? BindableState(wrappedValue: .init())
        self.overlayBackground = AnyShapeStyle(overlayBackground)
        self.alertStackView = alertStackView
        self.content = content()
    }

    public init<S>(
        alertState: BindableState<AlertState>? = nil,
        overlayBackground: S = .ultraThinMaterial,
        accentColor: Color,
        @ViewBuilder content: () -> Content
    ) where S : ShapeStyle {
        _alertState = alertState ?? BindableState(wrappedValue: .init())
        self.overlayBackground = AnyShapeStyle(overlayBackground)
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
