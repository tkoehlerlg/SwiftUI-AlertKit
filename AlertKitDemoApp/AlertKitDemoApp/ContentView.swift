//
//  ContentView.swift
//  AlertKitDemoApp
//
//  Created by Torben Köhler on 26.11.22.
//

import SwiftUI
import AlertKit
import ComposableArchitecture

struct Part: ReducerProtocol {
    struct State: Equatable {
        var alert: ComposableAKAlert<Action>?
    }
    enum Action: Equatable {
        case onAppear
        case alertChanged(ComposableAKAlert<Action>?)
        case console
        case onClose
    }

    @Dependency(\.mainQueue) var mainQueue

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.alert = ComposableAKAlert(
                    title: "Test",
                    message: "This is a Test-Alert!",
                    primaryButton: ComposableAKButton(
                        title: "Okay!!",
                        style: .primary,
                        action: Action.console
                    ),
                    secondaryButton: AKButton(
                        title: "Nooo",
                        style: .secondary,
                        action: { print("Secondary") }
                    ),
                    closeAction: Action.onClose
                )
                return .none
            case .alertChanged(let newAlert):
                state.alert = newAlert
                return .none
            case .console:
                print("Primary!!!")
                return .none
            case .onClose:
                print("Close")
                return .none
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        GlobalAKAlertView(accentColor: .orange) {
            PartView(store: .init(
                initialState: Part.State(),
                reducer: Part()
            ))
        }
    }
}

struct PartView: View {
    var store: StoreOf<Part>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button("Show Alert") {
                viewStore.send(.onAppear)
            }
                .alert(viewStore.binding(
                    get: \.alert,
                    send: Part.Action.alertChanged
                ), viewStore: viewStore)
                .onAppear {
                    viewStore.send(.onAppear)
                }
        }
    }
}
