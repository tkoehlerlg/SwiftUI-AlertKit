//
//  GlobalCAKAlertState.swift
//  SwiftUI-AlertKit
//
//  Created by Torben Köhler on 26.11.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Dependencies

public final class GlobalCAKAlertState: ObservableObject {
    @Published private(set) var alerts: IdentifiedArrayOf<InternalCAKAlert> = []

    public init() { }

    internal init<Action: Equatable>(_ alerts: [CAKAlert<CAKAlertAction>]) {
        self.alerts = .init(uniqueElements: alerts.map { $0.toInternal(executeButtonAction: { _ in }) })
    }

    func addAlert(_ alert: InternalAKAlert) {
        alerts.append(alert)
    }

    public func addAlert(_ alert: AKAlert) {
        addAlert(alert.toInternal())
    }

    func closeAlert<State: Equatable, Action: Equatable>(_ alert: InternalAKAlert, viewStore: ViewStore<State, Action>) {
        guard let alert = alerts[id: alert.id] else { return }
        alert.closeAction?()
        alerts.remove(id: alert.id)
        alert.defaultAction()
    }

    public func closeAlert<State: Equatable, Action: Equatable>(_ alert: AKAlert, viewStore: ViewStore<State, Action>) {
        closeAlert(alert.toInternal(), viewStore: viewStore)
    }

    func closeAlert(_ alert: InternalAKAlert) {
        guard let alert = alerts[id: alert.id] else { return }
        alert.closeAction?()
        alerts.remove(id: alert.id)
        alert.defaultAction()
    }

    public func closeAlert(_ alert: AKAlert) {
        closeAlert(alert.toInternal())
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
