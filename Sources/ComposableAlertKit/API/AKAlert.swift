//
//  AKAlert.swift
//  
//
//  Created by Torben Köhler on 16.01.23.
//

import Foundation
import ComposableArchitecture

public class AKAlert: NSObject, NSCopying, Identifiable {
    public var id: String { title + message }
    public var title: String
    public var message: String
    public var buttons: [AKButton]
    private(set) var closeAction: CloseAction? = nil

    enum CloseAction: Equatable {
        public static func == (lhs: CloseAction, rhs: CloseAction) -> Bool {
            if case .composable = lhs, case .composable = rhs { return true }
            else if case .void = lhs, case .void = rhs { return true }
            return false
        }

        case composable(any Equatable)
        case void(() -> Void)

        func execute<State: Equatable, Action: Equatable>(viewStore: ViewStore<State, Action>) {
            switch self {
            case .composable(let composable):
                viewStore.send(composable as! Action)
            case .void(let void):
                void()
            }
        }
    }

    public init<Action: Equatable>(
        title: String,
        message: String,
        buttons: [AKButton] = [],
        closeAction: Action? = nil // TODO: This is not working currently but viewModifier changes as expected!
    ) {
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

    public init<Action: Equatable>(
        title: String,
        message: String,
        primaryButton: AKButton,
        secondaryButton: AKButton? = nil,
        closeAction: Action? = nil
    ) {
        self.title = title
        self.message = message
        self.buttons
        if let closeAction {
            self.closeAction = .composable(closeAction)
        }
    }

    public init(
        title: String,
        message: String,
        buttons: [AKButton] = [],
        closeAction: (() -> Void)? = nil
    ) {
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

    public init<Action: Equatable>(
        title: String,
        message: String,
        primaryButton: AKButton,
        secondaryButton: AKButton? = nil,
        closeAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttons
        if let closeAction {
            self.closeAction = .void(closeAction)
        }
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = AKAlert(
            title: title,
            message: message,
//            buttons: buttons,
            closeAction: closeAction
        )
        return copy
    }
}

extension AKAlert {
    internal static var mock = AKAlert(
        title: "Alert",
        message: "This is an Alert!",
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
        closeAction: nil
    )
}
