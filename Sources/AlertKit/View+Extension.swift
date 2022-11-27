//
//  View+Extension.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI

struct GlobalAlertViewModifier: ViewModifier {
    @Environment(\.alertState) var alertState
    var alert: Alert?

    func body(content: Content) -> some View {
        content
            .alert(alert, alertState: alertState)
    }
}

extension View {
    public func alert(_ alert: Alert?) -> some View {
        self.modifier(GlobalAlertViewModifier(alert: alert))
    }

    func alert(_ alert: Alert?, alertState: AlertState) -> some View {
        if let alert = alert {
            withAnimation(.easeOut(duration: 0.3).delay(0.5)) {
                alertState.addAlert(alert)
            }
        }
        return self.onChange(of: alert) { newAlert in
            guard let alert = newAlert else {
                alertState.closeFirst()
                return
            }

            withAnimation(.easeOut(duration: 0.3).delay(0.5)) {
                alertState.addAlert(alert)
            }
        }
    }
}
