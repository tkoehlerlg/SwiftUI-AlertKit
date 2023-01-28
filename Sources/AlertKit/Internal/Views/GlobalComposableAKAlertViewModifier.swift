//
//  GlobalComposableAKAlertViewModifier.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct GlobalComposableAKAlertViewModifier<State: Equatable, Action: Equatable>: ViewModifier {
    @Environment(\.globalAlertState) var alertState
    @Binding var alert: ComposableAKAlert<Action>?
    var viewStore: ViewStore<State, Action>

    func body(content: Content) -> some View {
        content
            .alert($alert, alertState: alertState, viewStore: viewStore)
    }
}

extension View {
    public func alert<State: Equatable, Action: Equatable>(
        _ alert: Binding<ComposableAKAlert<Action>?>,
        viewStore: ViewStore<State, Action>
    ) -> some View {
        return self.modifier(GlobalComposableAKAlertViewModifier(alert: alert, viewStore: viewStore))
    }

    func alert<State: Equatable, Action: Equatable>(
        _ alert: Binding<ComposableAKAlert<Action>?>,
        alertState: GlobalAKAlertState,
        viewStore: ViewStore<State, Action>
    ) -> some View {
        self.onChange(of: alert.wrappedValue) { newAlert in
            guard let newAlert = newAlert else {
                alertState.closeFirstAlert()
                return
            }
            let _alert: AKAlert = .init(
                title: newAlert.title,
                message: newAlert.message,
                buttons: newAlert.buttons.map {
                    guard let button = $0 as? ComposableAKButton<Action>, let _action = button._action else { return $0 }
                    let action: () -> Void = {
                        viewStore.send(_action)
                    }
                    button.action = action
                    return button
                },
                closeAction: {
                    if let closeAction = newAlert._closeAction {
                        viewStore.send(closeAction)
                    }
                }
            )
            withAnimation(.easeOut(duration: 0.3)) {
                alertState.addAlert(_alert.toInternal(defaultAction: { alert.wrappedValue = nil }))
            }
        }
    }
}
