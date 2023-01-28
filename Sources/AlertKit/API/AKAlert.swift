//
//  AKAlert.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation

public class AKAlert: Identifiable, Equatable {
    public static func == (lhs: AKAlert, rhs: AKAlert) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title && lhs.message == rhs.message && lhs.buttons == rhs.buttons
    }

    public var id: String { title + message }
    public var title: String
    public var message: String
    public var buttons: [AKButton]
    public var closeAction: (() -> Void)?

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
        self.closeAction = closeAction
    }

    public init(
        title: String,
        message: String,
        primaryButton: AKButton,
        secondaryButton: AKButton? = nil,
        closeAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        if let secondaryButton = secondaryButton {
            self.buttons = [primaryButton, secondaryButton]
        } else {
            self.buttons = [primaryButton]
        }
        self.closeAction = closeAction
    }

    func toInternal(defaultAction: @escaping () -> Void) -> InternalAKAlert {
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

public class ComposableAKAlert<Action: Equatable>: AKAlert {
    public var _closeAction: Action?

    public init(
        title: String,
        message: String,
        buttons: [AKButton] = [],
        closeAction: Action? = nil // TODO: This is not working currently but viewModifier changes as expected!
    ) {
        super.init(
            title: title,
            message: message,
            buttons: buttons,
            closeAction: nil
        )
        self._closeAction = closeAction
    }

    public init(
        title: String,
        message: String,
        primaryButton: AKButton,
        secondaryButton: AKButton? = nil,
        closeAction: Action? = nil
    ) {
        super.init(
            title: title,
            message: message,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton,
            closeAction: nil
        )
        self._closeAction = closeAction
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
        ]
    )
}
