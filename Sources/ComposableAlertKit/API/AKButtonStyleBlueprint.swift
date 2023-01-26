import SwiftUI
import SwiftUIX

public struct AKButtonStyleBlueprint: Equatable {
    var backgroundColor: Color
    var textColor: Color
    var borderColor: Color?
    var isPressedBackgroundColor: Color?
    var isPressedTextColor: Color?
    var isPressedBorderColor: Color?

    public init(
        backgroundColor: Color,
        textColor: Color = .primary,
        borderColor: Color? = nil,
        isPressedBackgroundColor: Color? = nil,
        isPressedTextColor: Color? = nil,
        isPressedBorderColor: Color? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.isPressedBackgroundColor = isPressedBackgroundColor
        self.isPressedTextColor = isPressedTextColor
        self.isPressedBorderColor = isPressedBorderColor
    }
}

extension AKButtonStyleBlueprint {
    public static func primary(accentColor: Color, textColor: Color = .primary) -> Self {
        .init(
            backgroundColor: accentColor,
            textColor: textColor,
            borderColor: nil
        )
    }
    public static func secondary(accentColor: Color) -> Self {
        .init(
            backgroundColor: .clear,
            textColor: accentColor,
            borderColor: accentColor
        )
    }
    public static func destructive(
        warningColor: Color = .systemRed,
        isPressedTextColor: Color = .white
    ) -> Self {
        .init(
            backgroundColor: .clear,
            textColor: warningColor,
            borderColor: warningColor,
            isPressedBackgroundColor: warningColor,
            isPressedTextColor: isPressedTextColor,
            isPressedBorderColor: nil
        )
    }
}
