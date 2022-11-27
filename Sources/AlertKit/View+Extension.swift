//
//  View+Extension.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI

extension View {
    public func alert(_ alert: Alert?) -> some View {
        @Environment(\.alertState) var alertState
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
