//
//  AKAlert.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation

public class AKAlert: NSObject, NSCopying, Identifiable {
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
                    style: .secondary(accentColor: .accentColor),
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

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = AKAlert(title: title, message: message, buttons: buttons, closeAction: closeAction)
        return copy
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

    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = ComposableAKAlert(title: title, message: message, buttons: buttons, closeAction: _closeAction)
        return copy
    }
}

extension AKAlert {
    internal static var mock = AKAlert(
        title: "Alert",
        message: "This is an Alert!",
        buttons: [
            .init(
                title: "Primary",
                style: .primary(accentColor: .orange, textColor: .white),
                action: { print("Primary") }
            ),
            .init(
                title: "Secondary",
                style: .secondary(accentColor: .orange),
                action: { print("Secondary") }
            ),
            .init(
                title: "Destructiv",
                style: .destructiv,
                action: { print("Destructiv") }
            )
        ]
    )
}
