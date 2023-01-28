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
    @Published public private(set) var alerts: IdentifiedArrayOf<AKAlert> = .init()

    public init() { }

    internal init(_ alerts: IdentifiedArrayOf<AKAlert>) {
        self.alerts = alerts
    }

    public func addAlert(_ alert: AKAlert) {
        alerts.append(alert)
    }

    public func closeAlert<State: Equatable, Action: Equatable>(
        _ alert: AKAlert,
        viewStore: ViewStore<State, Action>
    ) {
        alert.closeAction?()
        alerts.remove(id: alert.id)
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
    public static var defaultValue: GlobalAKAlertState = .init()
}

extension EnvironmentValues {
    public var alertState: GlobalAKAlertState {
        get { self[AKAlertStateKey.self] }
        set { self[AKAlertStateKey.self] = newValue }
    }
}

// MARK: mock
extension GlobalAKAlertState {
    internal static var mock: Self {
        .init([.mock])
    }
}
