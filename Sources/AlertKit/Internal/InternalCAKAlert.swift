//
//  File.swift
//  
//
//  Created by Torben Köhler on 28.01.23.
//

import Foundation
import ComposableArchitecture

internal struct InternalCAKAlert: Identifiable {
    let id: UUID
    let title: String
    let message: String
    let buttons: [CAKButton<CAKAlertAction>]
    let closeAction: CloseAction<CAKAlertAction>?
    private let executeButtonAction: (CAKButton<CAKAlertAction>) -> Void
    let defaultAction: () -> Void

    typealias CloseAction = CAKAlert<CAKAlertAction>.CloseAction

    init(
        id: UUID,
        title: String,
        message: String,
        buttons: [CAKButton<CAKAlertAction>],
        closeAction: CloseAction<CAKAlertAction>?,
        executeButtonAction: @escaping (CAKButton<CAKAlertAction>) -> Void,
        defaultAction: @escaping () -> Void
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.buttons = buttons
        self.closeAction = closeAction
        self.executeButtonAction = executeButtonAction
        self.defaultAction = defaultAction
    }

    func executeButtonAction(_ button: CAKButton<Action>) {
        self.executeButtonAction(button)
    }
}
