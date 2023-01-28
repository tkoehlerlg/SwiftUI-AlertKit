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
    @Published private(set) var alerts: IdentifiedArrayOf<InternalAKAlert> = []

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

    func closeAlert<State: Equatable, Action: Equatable>(_ alert: InternalAKAlert, viewStore: ViewStore<State, Action>) {
        guard var alert = alerts[id: alert.id] else { return }
        alert.closeAction?.execute(viewStore: viewStore)
        alerts.remove(id: alert.id)
        alert.defaultAction()
    }

    public func closeAlert<State: Equatable, Action: Equatable>(_ alert: AKAlert, viewStore: ViewStore<State, Action>) {
        closeAlert(alert.toInternal(defaultAction: {}), viewStore: viewStore)
    }

    func closeAlert(_ alert: InternalAKAlert) {
        guard var alert = alerts[id: alert.id] else { return }
        alert.closeAction?.execute()
        alerts.remove(id: alert.id)
        alert.defaultAction()
    }

    public func closeAlert(_ alert: AKAlert) {
        closeAlert(alert.toInternal(defaultAction: {}))
    }

    public func closeFirstAlert<State: Equatable, Action: Equatable>(viewStore: ViewStore<State, Action>) {
        guard let firstAlert = alerts.first else { return }
        closeAlert(firstAlert, viewStore: viewStore)
    }

    public func closeFirstAlert() {
        guard let firstAlert = alerts.first else { return }
        closeAlert(firstAlert)
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
