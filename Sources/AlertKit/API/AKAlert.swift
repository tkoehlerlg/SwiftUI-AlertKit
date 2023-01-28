//
//  AKAlert.swift
//
//
//  Created by Torben Köhler on 16.01.23.
//

import Foundation
import ComposableArchitecture

public struct AKAlert: Identifiable, Equatable {
    public static func == (lhs: AKAlert, rhs: AKAlert) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title && lhs.message == rhs.message && lhs.buttons == rhs.buttons
    }

    public let id: UUID
    public let title: String
    public let message: String
    public let buttons: [AKButton]
    public let closeAction: (() -> Void)? = nil

    public init(
        id: UUID = UUID(),
        title: String,
        message: String,
        buttons: [AKButton] = [],
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
        self.closeAction = closeAction
    }

    public init(
        id: UUID = UUID(),
        title: String,
        message: String,
        primaryButton: AKButton,
        secondaryButton: AKButton? = nil,
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
        self.closeAction = closeAction
    }
}

extension AKAlert {
    internal func toInternal(
        defaultAction: @escaping () -> Void = {},
        viewStore: ViewStore<any Equatable, any Equatable>? = nil
    ) -> InternalAKAlert {
        .init(
            id: id,
            title: title,
            message: message,
            buttons: buttons,
            closeAction: closeAction,
            defaultAction: defaultAction
        )
    }
}

extension AKAlert {
    internal static var mock = AKAlert(
        title: "Alert",
        message: "This is an Alert!",
        buttons: [
            .init(
                title: "Primary",
                style: .primary,
                action: { print("Primary") }
            ),
            .init(
                title: "Secondary",
                style: .secondary,
                action: { print("Secondary") }
            ),
            .init(
                title: "Destructiv",
                style: .destructive,
                action: { print("Destructiv") }
            )
        ],
        closeAction: nil
    )
}
