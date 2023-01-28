//
//  GlobalAKAlertState.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Dependencies

public final class GlobalAKAlertState: ObservableObject {
    @Published private(set) var alerts: IdentifiedArrayOf<InternalAKAlert> = .init()

    public func getAlerts() -> [AKAlert] {
        return alerts.map { $0.toAKAlert() }
    }

    public init() { }

    internal init(_ alerts: [AKAlert]) {
        self.alerts = .init(uniqueElements: alerts.map { $0.toInternal(defaultAction: {}) })
    }

    func addAlert(_ alert: InternalAKAlert) {
        alerts.append(alert)
    }

    public func addAlert(_ alert: AKAlert) {
        addAlert(alert.toInternal(defaultAction: {}))
    }

    func closeAlert(_ alert: InternalAKAlert) {
        guard let alert = alerts[id: alert.id] else { return }
        alert.closeAction?()
        alerts.remove(id: alert.id)
        alert.defaultAction()
    }

    public func closeAlert(_ alert: AKAlert) {
        closeAlert(alert.toInternal(defaultAction: {}))
    }

    public func closeFirstAlert() {
        if let firstAlert = alerts.first {
            closeAlert(firstAlert)
        }
    }
}

// MARK: Environment
internal struct GlobalAKAlertStateKey: EnvironmentKey {
    public static var defaultValue: GlobalAKAlertState = .init()
}

extension EnvironmentValues {
    public var globalAlertState: GlobalAKAlertState {
        get { self[GlobalAKAlertStateKey.self] }
        set { self[GlobalAKAlertStateKey.self] = newValue }
    }
}

// MARK: mock
extension GlobalAKAlertState {
    internal static var mock: Self {
        .init([.mock])
    }
}
