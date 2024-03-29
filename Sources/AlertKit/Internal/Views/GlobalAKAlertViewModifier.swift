//
//  GlobalAKAlertViewModifier.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI

struct GlobalAKAlertViewModifier: ViewModifier {
    @Environment(\.globalAlertState) var alertState
    @Binding var alert: AKAlert?

    func body(content: Content) -> some View {
        content
            .alert($alert, alertState: alertState)
    }
}

extension View {
    public func alert(_ alert: Binding<AKAlert?>) -> some View {
        self.modifier(GlobalAKAlertViewModifier(alert: alert))
    }

    func alert(_ alert: Binding<AKAlert?>, alertState: GlobalAKAlertState) -> some View {
        self.onChange(of: alert.wrappedValue) { newAlert in
            guard let newAlert = newAlert else {
                alertState.closeFirstAlert()
                return
            }

            withAnimation(.easeOut(duration: 0.3)) {
                alertState.addAlert(newAlert.toInternal(defaultAction: { alert.wrappedValue = nil }))
            }
        }
    }
}
