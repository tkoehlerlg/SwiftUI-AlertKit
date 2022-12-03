//
//  Alert.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation

public struct Alert: Identifiable, Equatable {
    public static func == (lhs: Alert, rhs: Alert) -> Bool {
        lhs.id == rhs.id
    }

    public var id: String {
        title+description
    }
    var title: String
    var description: String
    var buttons: [Button]
    var closeAction: (() -> Void)?

    public init(
        title: String,
        description: String,
        buttons: [Button] = [],
        closeAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
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
        description: String,
        primaryButton: Button,
        secondaryButton: Button? = nil
    ) {
        self.title = title
        self.description = description
        if let secondaryButton = secondaryButton {
            self.buttons = [primaryButton, secondaryButton]
        } else {
            self.buttons = [primaryButton]
        }
    }
}

extension Alert {
    internal static var mock: Self {
        .init(
            title: "Alert",
            description: "This is an Alert!",
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
                    style: .destructiv,
                    action: { print("Destructiv") }
                )
            ]
        )
    }
}
