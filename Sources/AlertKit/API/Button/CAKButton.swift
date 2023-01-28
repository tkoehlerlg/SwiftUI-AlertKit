//
//  CAKButton.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import ComposableArchitecture

public class CAKButton<Action: Equatable>: Identifiable, Equatable {
    public static func == (lhs: CAKButton<Action>, rhs: CAKButton<Action>) -> Bool {
        lhs.title == rhs.title && lhs.style == rhs.style
    }

    var title: String
    var style: AKButton.Style
    var action: _Action<Action>

    enum _Action<Action: Equatable> {
        case composable(Action)
        case void(() -> Void)

        func execute<State: Equatable>(viewStore: ViewStore<State, Action>) {
            switch self {
            case .composable(let composable):
                viewStore.send(composable)
            case .void(let void):
                void()
            }
        }
    }

    init(title: String, style: AKButton.Style, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = style
        self.action = .void(action)
    }

    init(title: String, style: AKButton.Style, action: Action) {
        self.title = title
        self.style = style
        self.action = .composable(action)
    }

    public init(title: String, style: AKButton.SystemStyle, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = .system(style)
        self.action = .void(action)
    }

    public init(title: String, style: AKButton.SystemStyle, action: Action) {
        self.title = title
        self.style = .system(style)
        self.action = .composable(action)
    }

    public init(title: String, style: AKButtonStyleBlueprint, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = .custom(style)
        self.action = .void(action)
    }

    public init(title: String, style: AKButtonStyleBlueprint, action: Action) {
        self.title = title
        self.style = .custom(style)
        self.action = .composable(action)
    }
}
