//
//  View+Extension.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI

struct GlobalAlertViewModifier: ViewModifier {
    @EnvironmentObject var alertState: AlertState
    @Binding var alert: Alert?

    func body(content: Content) -> some View {
        content
            .alert($alert, alertState: alertState)
    }
}

extension View {
    public func alert(_ alert: Binding<Alert?>) -> some View {
        self.modifier(GlobalAlertViewModifier(alert: alert))
    }

    func alert(_ alert: Binding<Alert?>, alertState: AlertState) -> some View {
        self.onChange(of: alert.wrappedValue) { newAlert in
            guard let newAlert = newAlert else {
                alertState.closeFirstAlert()
                return
            }

            withAnimation(.easeOut(duration: 0.3).delay(0.5)) {
                alertState.addAlert(newAlert.setNilWhenAlertClosed(binding: alert))
            }
        }
    }
}

extension Alert {
    func setNilWhenAlertClosed(binding: Binding<Alert?>) -> Alert {
        var alert = self
        let closeAction = {
            self.closeAction?()
            binding.wrappedValue = nil
        }
        alert.closeAction = closeAction
        return alert
    }
}

