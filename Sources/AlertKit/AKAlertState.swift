//
//  AKAlertState.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Dependencies

public final class AKAlertState: ObservableObject {
    @Published public private(set) var alerts: IdentifiedArrayOf<AKAlert> = .init()

    public init() { }

    internal init(_ alerts: IdentifiedArrayOf<AKAlert>) {
        self.alerts = alerts
    }

    public func addAlert(_ alert: AKAlert) {
        alerts.append(alert)
    }

    public func closeAlert(_ alert: AKAlert) {
        alert.closeAction?()
        alerts.removeAll(where: { $0.id == alert.id })
    }

    public func closeFirstAlert() {
        if !alerts.isEmpty {
            alerts.first!.closeAction?()
            alerts.removeFirst()
        }
    }
}

// MARK: Environment
internal struct AKAlertStateKey: EnvironmentKey {
    public static var defaultValue: AKAlertState = .init()
}

extension EnvironmentValues {
    public var alertState: AKAlertState {
        get { self[AKAlertStateKey.self] }
        set { self[AKAlertStateKey.self] = newValue }
    }
}

// MARK: Composable Architecture
extension AKAlertStateKey: DependencyKey {
    static var liveValue: AKAlertState = .init()
}

extension DependencyValues {
    public var alertState: AKAlertState {
        get { self[AKAlertStateKey.self] }
        set { self[AKAlertStateKey.self] = newValue }
    }
}

// MARK: mock
extension AKAlertState {
    internal static var mock: Self {
        .init([.mock])
    }
}
