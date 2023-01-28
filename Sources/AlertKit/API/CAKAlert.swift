//
//  CAKAlert.swift
//
//
//  Created by Torben Köhler on 16.01.23.
//

import Foundation
import ComposableArchitecture

public protocol CAKAlertAction: Equatable {}

public struct CAKAlert<Action: CAKAlertAction>: Identifiable, Equatable {
    public static func == (lhs: CAKAlert<Action>, rhs: CAKAlert<Action>) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title && lhs.message == rhs.message && lhs.buttons == rhs.buttons
    }

    public var id: UUID
    public var title: String
    public var message: String
    public var buttons: [CAKButton<Action>]
    private(set) var closeAction: CloseAction<Action>? = nil

    enum CloseAction<Action: Equatable> {
        case composable(Action)
        case void(() -> Void)

        func execute<State: Equatable, Action: Equatable>(viewStore: ViewStore<State, Action>) {
            switch self {
            case .composable(let composable):
                viewStore.send(composable as! Action)
            case .void(let void):
                void()
            }
        }

        func execute() {
            if case .void(let void) = self {
                void()
            }
        }
    }

    public init(
        id: UUID = UUID(),
        title: String,
        message: String,
        buttons: [CAKButton<Action>] = [],
        closeAction: (() -> Void)? = nil
    ) {
        self.id = id
        self.title = title
        self.message = message
        if buttons.isEmpty {
            self.buttons = [
                .init(
                    title: "Okay",
                    style: .secondary,
                    action: {}
                )
            ]
        } else {
            self.buttons = buttons
        }
        if let closeAction {
            self.closeAction = .void(closeAction)
        }
    }

    public init(
        id: UUID = UUID(),
        title: String,
        message: String,
        primaryButton: CAKButton<Action>,
        secondaryButton: CAKButton<Action>? = nil,
        closeAction: (() -> Void)? = nil
    ) {
        self.id = id
        self.title = title
        self.message = message
        if let secondaryButton = secondaryButton {
            buttons = [primaryButton, secondaryButton]
        } else {
            buttons = [primaryButton]
        }
        if let closeAction {
            self.closeAction = .void(closeAction)
        }
    }

    public init(
        id: UUID = UUID(),
        title: String,
        message: String,
        buttons: [CAKButton<Action>] = [],
        closeAction: Action? = nil // TODO: This is not working currently but viewModifier changes as expected!
    ) {
        self.id = id
        self.title = title
        self.message = message
        if buttons.isEmpty {
            self.buttons = [
                .init(
                    title: "Okay",
                    style: .secondary,
                    action: {}
                )
            ]
        } else {
            self.buttons = buttons
        }
        if let closeAction {
            self.closeAction = .composable(closeAction)
        }
    }

    public init(
        id: UUID = UUID(),
        title: String,
        message: String,
        primaryButton: CAKButton<Action>,
        secondaryButton: CAKButton<Action>? = nil,
        closeAction: Action? = nil
    ) {
        self.id = id
        self.title = title
        self.message = message
        if let secondaryButton = secondaryButton {
            buttons = [primaryButton, secondaryButton]
        } else {
            buttons = [primaryButton]
        }
        if let closeAction {
            self.closeAction = .composable(closeAction)
        }
    }
}

extension CAKAlert {
    internal func toInternal(
        executeButtonAction: @escaping (CAKButton<Action>) -> Void,
        defaultAction: @escaping () -> Void = {}
    ) -> InternalCAKAlert<Action> {
        .init(
            id: id,
            title: title,
            message: message,
            buttons: buttons,
            closeAction: closeAction,
            executeButtonAction: executeButtonAction,
            defaultAction: defaultAction
        )
    }
}

extension CAKAlert {
    struct Mock: ReducerProtocol {
        struct State: Equatable {}
        struct Action: Equatable {}
        func reduce(into state: inout State, action: Action) -> EffectTask<Action> { return .none }
    }

//    internal static var mock: CAKAlert<Mock.Action> = .init(
//        title: "Alert",
//        message: "This is an Alert!",
//        buttons: [
//            .init(
//                title: "Primary",
//                style: .primary,
//                action: { print("Primary") }
//            ),
//            .init(
//                title: "Secondary",
//                style: .secondary,
//                action: { print("Secondary") }
//            ),
//            .init(
//                title: "Destructiv",
//                style: .destructive,
//                action: { print("Destructiv") }
//            )
//        ],
//        closeAction: nil
//    )
}
