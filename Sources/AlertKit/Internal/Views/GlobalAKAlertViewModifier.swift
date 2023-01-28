//
//  GlobalAKAlertViewModifier.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct GlobalAKAlertViewModifier: ViewModifier {
    @Environment(\.alertState) var alertState
    @Binding var alert: AKAlert?

    func body(content: Content) -> some View {
        content
            .alert($alert, alertState: alertState)
    }
}

struct GlobalCAKAlertViewModifier<State: Equatable, Action: Equatable>: ViewModifier {
    @Environment(\.alertState) var alertState
    @Binding var alert: AKAlert?
    var viewStore: ViewStore<State, Action>

    func body(content: Content) -> some View {
        content
            .alert($alert, viewStore: viewStore, alertState: alertState)
    }
}

extension View {
    public func alert(_ alert: Binding<AKAlert?>) -> some View {
        self.modifier(GlobalAKAlertViewModifier(alert: alert))
    }

    public func alert<State: Equatable, Action: Equatable>(_ alert: Binding<AKAlert?>, viewStore: ViewStore<State, Action>) -> some View {
        self.modifier(GlobalCAKAlertViewModifier(alert: alert, viewStore: viewStore))
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

    func alert<State: Equatable, Action: Equatable>(_ alert: Binding<AKAlert?>, viewStore: ViewStore<State, Action>, alertState: GlobalAKAlertState) -> some View {
        self.onChange(of: alert.wrappedValue) { newAlert in
            guard let newAlert = newAlert else {
                alertState.closeFirstAlert(viewStore: viewStore)
                return
            }

            withAnimation(.easeOut(duration: 0.3)) {
                alertState.addAlert(newAlert.toInternal(defaultAction: { alert.wrappedValue = nil }, viewStore: viewStore))
            }
        }
    }
}
