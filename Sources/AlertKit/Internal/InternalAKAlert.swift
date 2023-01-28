//
//  InternalAKAlert.swift
//  
//
//  Created by Torben Köhler on 28.01.23.
//

import Foundation
import ComposableArchitecture

internal struct InternalAKAlert: Identifiable {
    let id: UUID
    let title: String
    let message: String
    let buttons: [AKButton]
    let closeAction: (() -> Void)?
    let defaultAction: () -> Void

    init(
        id: UUID,
        title: String,
        message: String,
        buttons: [AKButton],
        closeAction: (() -> Void)?,
        defaultAction: @escaping () -> Void
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.buttons = buttons
        self.closeAction = closeAction
        self.defaultAction = defaultAction
    }
}
