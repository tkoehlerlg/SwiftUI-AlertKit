//
//  AlertState.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Dependencies

public final class AlertState: ObservableObject {
    @Published public private(set) var alerts: IdentifiedArrayOf<Alert> = .init()

    public init() { }

    internal init(_ alerts: IdentifiedArrayOf<Alert>) {
        self.alerts = alerts
    }

    public func addAlert(_ alert: Alert) {
        alerts.append(alert)
    }

    public func closeAlert(_ alert: Alert) {
        alerts.removeAll(where: { $0.id == alert.id })
    }

    public func closeFirst() {
        if !alerts.isEmpty { alerts.removeFirst() }
    }
}

// MARK: Environment
internal struct AlertStateKey: EnvironmentKey {
    public static var defaultValue: AlertState = .init()
}

extension EnvironmentValues {
    public var alertState: AlertState {
        get { self[AlertStateKey.self] }
        set { self[AlertStateKey.self] = newValue }
    }
}

// MARK: Composable Architecture
extension AlertStateKey: DependencyKey {
    static var liveValue: AlertState = .init()
}

extension DependencyValues {
    public var alertState: AlertState {
        get { self[AlertStateKey.self] }
        set { self[AlertStateKey.self] = newValue }
    }
}

// MARK: mock
extension AlertState {
    internal static var mock: Self {
        .init([.mock])
    }
}
