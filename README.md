# SwiftUI-AlertKit

An Alert-Kit for SwiftUI! For easy integration without minding any logic or design, but fully customizable! And I bet you love the animations!

## 🚀 Integration
You can either integrate this Package in your *App-Project* or in your *Package.swift* file if you're building a Package. Simply refer to the current version `0.3.3` and set it to next minor version.

## 🛠️ Use
This Project is focused on simple integration as well as easy maintaince you simply set the `GlobalAKAlertView` around your ParentView and everything works right out of the Box!
```swift
GlobalAKAlertView(accentColor: .orange) {
    ParentView { }
}
```
#### You can easily modify most of the styles:
`overlayBackground: ShapeStyle`,
`alertBackground: ShapeStyle`,
`accentColor: Color` and 
`textColor: Color`
#### Or you create your own AlertStack
```swift
GlobalAKAlertView(
    overlayBackground: .ultraThinMaterial,
    textColor: .primary,
    alertStackView: { alertState in 
        AlertStackView { } 
    },
) {
    ParentView { }
}
```

#### Raising an Alert has never been easier!
Just set an optional AKAlert to the desired alert and it alerts the user emiditly!
```swift
struct ChildView: View {
    @State var alert: AKAlert?

    var body: some View {
        Button("Button", action: {
            alert = .init(
                title: "This is an Error",
                message: "And this is an Error Message",
                primaryButton: .init(
                    title: "Okay",
                    style: .secondary,
                    action: { print("Okay!!") }
                )
            )
        })
        .alert($alert)
    }
}
```
### Do you like The Composable Architecture? I do too!
We support the Composable Architecture right out of the Swift Package!
```swift
struct Child: ReducerProtocol {
    struct State: Equatable {
        var alert: ComposableAKAlert<Action>?
    }
    enum Action: Equatable {
        case alert(ComposableAKAlert<Action>?)
        case triggerAlert
        case alertTappedOkay
    }
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .alert(let newAlert):
            state.alert = newAlert
            return .none
        case .triggerAlert:
            state.alert = .init(
                title: "This is an Error",
                message: "And this is an Error Message",
                primaryButton: ComposableAKButton(
                    title: "Okay",
                    style: .secondary,
                    action: Action.alertTappedOkay
                )
            )
            return .none
        case .alertTappedOkay:
            print("Okay!!")
            return .none
        }
    }
}
```
After this you can simply use this alert in your ChildView like this:
```swift
struct ChildView: View {
    var store: StoreOf<Child>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button("Button", action: {
                viewStore.send(.triggerAlert)
            })
            .alert(viewStore.binding(
                get: \.alert,
                send: Child.Action.alert
            ), viewStore: viewStore)
        }
    }
}
```
This is all!

#### Hope you like the Repo and please left a star!
