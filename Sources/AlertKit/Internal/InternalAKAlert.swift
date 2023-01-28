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
    let closeAction: CloseAction?
    let viewStore: ViewStore<any Equatable, any Equatable>?
    let defaultAction: () -> Void

    typealias CloseAction = AKAlert.CloseAction

    init(
        id: UUID,
        title: String,
        message: String,
        buttons: [AKButton],
        closeAction: CloseAction?,
        viewStore: ViewStore<any Equatable, any Equatable>?,
        defaultAction: @escaping () -> Void
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.buttons = buttons
        self.closeAction = closeAction
        self.viewStore = viewStore
        self.defaultAction = defaultAction
    }

    func executeButtonAction(_ button: AKButton) {
        button.action.execute(viewStore: viewStore)
    }
}
