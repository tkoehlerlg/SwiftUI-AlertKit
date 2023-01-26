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
    var action: Action

    enum Action: Equatable {
        public static func == (lhs: Action, rhs: Action) -> Bool {
            if case .composable = lhs, case .composable = rhs { return true }
            else if case .void = lhs, case .void = rhs { return true }
            return false
        }

        case composable(any Equatable)
        case void(() -> Void)
    }

    enum Style {
        case system(SystemStyle)
        case custom(AKButtonStyleBlueprint)
    }

    public enum SystemStyle {
        case primary
        case secondary
        case destructive
    }

    init(title: String, style: Style, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = style
        self.action = .void(action)
    }

    init<Action: Equatable>(title: String, style: Style, action: Action) {
        self.title = title
        self.style = style
        self.action = .composable(action)
    }

    public init(title: String, style: SystemStyle, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = .system(style)
        self.action = .void(action)
    }

    public init<Action: Equatable>(title: String, style: SystemStyle, action: Action) {
        self.title = title
        self.style = .system(style)
        self.action = .composable(action)
    }

    public init(title: String, style: AKButtonStyleBlueprint, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = .custom(style)
        self.action = .void(action)
    }

    public init<Action: Equatable>(title: String, style: AKButtonStyleBlueprint, action: Action) {
        self.title = title
        self.style = .custom(style)
        self.action = .composable(action)
    }
}

extension AKButton: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = AKButton(title: title, style: style, action: action)
        return copy
    }
}
