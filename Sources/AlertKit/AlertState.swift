//
//  AlertState.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI

public final class AlertState: ObservableObject {
    @Published public private(set) var alerts: [Alert] = []

    public init() { }

    internal init(_ alerts: [Alert]) {
        self.alerts = alerts
    }

    public func addAlert(_ alert: Alert) {
        alerts.append(alert)
    }

    public func closeAlert(_ alert: Alert) {
        alerts.removeAll(where: { $0.id == alert.id })
    }

    public func closeFirst() {
        if !alerts.isEmpty {
            alerts.removeFirst()
        }
    }
}

extension AlertState {
    internal static var mock: Self {
        .init([.mock])
    }
}

internal struct AlertStateKey: EnvironmentKey {
    public static var defaultValue: AlertState = .init()
}

extension EnvironmentValues {
    public var alertState: AlertState {
        get { self[AlertStateKey.self] }
        set { self[AlertStateKey.self] = newValue }
    }
}
