//
//  AKButton.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation

public class AKButton: NSObject, Identifiable {
    var title: String
    var style: Style
    var action: () -> Void

    enum Style {
        case system(SystemStyle)
        case custom(AKButtonStyleBlueprint)
    }

    public enum SystemStyle {
        case primary
        case secondary
        case destructive
    }

    init(title: String, style: Style, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }

    public init(title: String, style: SystemStyle, action: @escaping () -> Void) {
        self.title = title
        self.style = .system(style)
        self.action = action
    }

    public init(title: String, style: AKButtonStyleBlueprint, action: @escaping () -> Void) {
        self.title = title
        self.style = .custom(style)
        self.action = action
    }
}

extension AKButton: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = AKButton(title: title, style: style, action: action)
        return copy
    }
}

public class ComposableAKButton<Action: Equatable>: AKButton {
    var _action: Action

    init(title: String, style: Style, action: Action) {
        self._action = action
        super.init(
            title: title,
            style: style,
            action: {}
        )
    }

    public init(title: String, style: SystemStyle, action: Action) {
        self._action = action
        super.init(
            title: title,
            style: style,
            action: {}
        )
    }

    public init(title: String, style: AKButtonStyleBlueprint, action: Action) {
        self._action = action
        super.init(
            title: title,
            style: style,
            action: {}
        )
    }
}
