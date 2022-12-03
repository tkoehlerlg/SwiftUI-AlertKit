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
    @EnvironmentObject var alertState: AKAlertState
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
        alertState: AKAlertState,
        viewStore: ViewStore<State, Action>
    ) -> some View {
        self.onChange(of: alert.wrappedValue) { newAlert in
            guard let newAlert = newAlert else {
                alertState.closeFirstAlert()
                return
            }
            if let _alert = alert.wrappedValue?.copy() as? ComposableAKAlert<Action> {
                _alert.buttons = _alert.buttons.map {
                    guard let button = $0 as? ComposableAKButton<Action>  else { return $0 }
                    let action: () -> Void = {
                        viewStore.send(button._action)
                    }
                    button.action = action
                    return button
                }
                if let closeAction = alert.wrappedValue?._closeAction {
                    _alert.closeAction = {
                        viewStore.send(closeAction)
                    }
                }
                alert.wrappedValue = _alert
            }
            withAnimation(.easeOut(duration: 0.3).delay(0.5)) {
                alertState.addAlert(newAlert.setNilWhenAlertClosed(binding: alert))
            }
        }
    }
}

extension ComposableAKAlert {
    func setNilWhenAlertClosed(binding: Binding<ComposableAKAlert?>) -> ComposableAKAlert {
        let alert = self.copy() as! ComposableAKAlert
        let closeAction: () -> Void = {
            self.closeAction?()
            binding.wrappedValue = nil
        }
        alert.closeAction = closeAction
        return alert
    }
}

