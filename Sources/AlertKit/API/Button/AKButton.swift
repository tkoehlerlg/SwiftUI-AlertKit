//
//  AKButton.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import ComposableArchitecture

public class AKButton: Identifiable, Equatable {
	public static func == (lhs: AKButton, rhs: AKButton) -> Bool {
        lhs.title == rhs.title && lhs.style == rhs.style
    }

    var title: String
    var style: Style
    var action: () -> Void

    enum Style: Equatable {
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
        self.action = action
    }

    public init(title: String, style: SystemStyle, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = .system(style)
        self.action = action
    }

    public init(title: String, style: AKButtonStyleBlueprint, action: @escaping () -> Void = {}) {
        self.title = title
        self.style = .custom(style)
        self.action = action
    }
}
