//
//  Alert+Button.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

extension Alert {
    public struct Button: Identifiable {
        public var id: String {
            return title+style.rawValue
        }

        var title: String
        var style: Style
        var action: () -> Void

        public init(title: String, style: Style, action: @escaping () -> Void) {
            self.title = title
            self.style = style
            self.action = action
        }
    }
}

extension Alert.Button {
    public enum Style: String {
        case primary, secondary, destructiv
    }
}
