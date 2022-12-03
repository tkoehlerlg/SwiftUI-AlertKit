//
//  GlobalAlertView.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI

public struct GlobalAKAlertView<Content>: View where Content : View {
    @StateObject private var alertState: AKAlertState
    private var overlayBackground: AnyShapeStyle
    private var alertBackground: AnyShapeStyle? = nil
    private var alertStackView: ((AKAlertState) -> Content)? = nil
    private var accentColor: Color = .accentColor
    private var content: Content

    public init<OB, AB>(
        overlayBackground: OB = .ultraThinMaterial,
        alertBackground: AB = .thinMaterial,
        @ViewBuilder alertStackView: @escaping (AKAlertState) -> Content,
        @ViewBuilder content: () -> Content
    ) where OB : ShapeStyle, AB : ShapeStyle {
        _alertState = StateObject(wrappedValue: .init())
        self.overlayBackground = AnyShapeStyle(overlayBackground)
        self.alertBackground = AnyShapeStyle(alertBackground)
        self.alertStackView = alertStackView
        self.content = content()
    }

    public init<OB, AB>(
        overlayBackground: OB = .ultraThinMaterial,
        alertBackground: AB = .thinMaterial,
        accentColor: Color,
        @ViewBuilder content: () -> Content
    ) where OB : ShapeStyle, AB : ShapeStyle {
        _alertState = StateObject(wrappedValue: .init())
        self.overlayBackground = AnyShapeStyle(overlayBackground)
        self.alertBackground = AnyShapeStyle(alertBackground)
        self.accentColor = accentColor
        self.content = content()
    }

    public var body: some View {
        content
            .environmentObject(alertState)
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
                if let alertBackground {
                    AlertStackView(
                        alertState: alertState,
                        alertBackground: alertBackground,
                        accentColor: accentColor
                    )
                }
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