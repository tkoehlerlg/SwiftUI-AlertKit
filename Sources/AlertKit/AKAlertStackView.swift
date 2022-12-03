//
//  AlertStackView.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI
import ColorSync

struct AlertStackView: View {
    @ObservedObject private var alertState: AKAlertState
    @State private var popAlert: Bool = false
    private var alertBackground: AnyShapeStyle
    private var accentColor: Color

    init<S>(
        alertState: AKAlertState,
        alertBackground: S = .thinMaterial,
        accentColor: Color
    ) where S : ShapeStyle {
        self.alertState = alertState
        self.alertBackground = AnyShapeStyle(alertBackground)
        self.accentColor = accentColor
    }

    var body: some View {
        ZStack {
            ForEach(alertState.alerts) { alert in
                Group {
                    AlertView(
                        alert: alert,
                        background: alertBackground,
                        accentColor: accentColor,
                        closeAlert: {
                            alertState.closeAlert(alert)
                        }
                    )
                }
                .transition(.scale(scale: 1.1).combined(with: .opacity).animation(.easeOut(duration: 0.5)))
                .opacity(alertState.alerts.firstIndex(of: alert) ?? -1 == 0 ? 1 : 0)
            }
        }
    }
}

struct AlertStackView_Previews: PreviewProvider {
    static var previews: some View {
        AlertStackView(
            alertState: .mock,
            accentColor: .orange
        )
    }
}
