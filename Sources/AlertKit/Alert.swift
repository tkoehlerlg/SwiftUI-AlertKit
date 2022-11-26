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

    public var id: UUID
    var title: String
    var description: String
    var buttons: [Button]

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        buttons: [Button]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.buttons = buttons
    }

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        primaryButton: Button,
        secondaryButton: Button? = nil
    ) {
        self.id = id
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
