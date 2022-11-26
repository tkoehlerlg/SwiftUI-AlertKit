//
//  AlertStackView.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI

struct AlertStackView: View {
    @ObservedObject var alertState: AlertState
    @State var popAlert: Bool = false
    var accentColor: Color

    var body: some View {
        ZStack {
            ForEach(alertState.alerts) { alert in
                AlertView(
                    alert: alert,
                    backgorund: Color(hue: 0, saturation: 0, brightness: 0.93),
                    accentColor: accentColor,
                    closeAlert: {
                        alertState.closeAlert(alert)
                    }
                )
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
