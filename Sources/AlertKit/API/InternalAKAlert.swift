//
//  InternalAKAlert.swift
//  
//
//  Created by Torben Köhler on 28.01.23.
//

import Foundation

struct InternalAKAlert: Identifiable {
    let id: String
    let title: String
    let message: String
    let buttons: [AKButton]
    let closeAction: (() -> Void)?
    let defaultAction: () -> Void

    func toAKAlert() -> AKAlert {
        .init(
            title: title,
            message: message,
            buttons: buttons,
            closeAction: closeAction
        )
    }
}
