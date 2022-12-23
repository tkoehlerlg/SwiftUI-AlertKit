//
//  GlobalAKAlertViewModifier.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI

struct GlobalAKAlertViewModifier: ViewModifier {
    @Environment(\.alertState) var alertState
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

    func alert(_ alert: Binding<AKAlert?>, alertState: AKAlertState) -> some View {
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

extension AKAlert {
    func setNilWhenAlertClosed(binding: Binding<AKAlert?>) -> AKAlert {
        let alert = self.copy() as! AKAlert
        let closeAction: () -> Void = {
            self.closeAction?()
            binding.wrappedValue = nil
        }
        alert.closeAction = closeAction
        return alert
    }
}
