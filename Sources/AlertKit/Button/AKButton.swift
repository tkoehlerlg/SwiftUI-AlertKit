//
//  AKButton.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation

public class AKButton: NSObject, Identifiable {
    var title: String
    var style: AKButtonStyleBlueprint
    var action: () -> Void

    public init(title: String, style: AKButtonStyleBlueprint, action: @escaping () -> Void) {
        self.title = title
        self.style = style
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
    var _action: Action?

    public init(title: String, style: AKButtonStyleBlueprint, action: Action?) {
        self._action = action
        super.init(
            title: title,
            style: style,
            action: {}
        )
    }
}
