import SwiftUI

struct TextButton: View {
    let text: String
    let font: Font
    let weight: Font.Weight
    let size: CGFloat
    let defaultColor: Color
    let toggledColor: Color
    let isToggled: Bool
    let action: () -> Void

    init(
        text: String,
        font: String = "Righteous-Regular",
        size: CGFloat = 16,
        weight: Font.Weight = .regular,
        defaultColor: Color = .accent.opacity(0.40),
        toggledColor: Color = .accent,
        isToggled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.font = .custom(font, size: size)
        self.weight = weight
        self.size = size
        self.defaultColor = defaultColor
        self.toggledColor = toggledColor
        self.isToggled = isToggled
        self.action = action
    }

    var body: some View {
        Text(text)
            .font(font.weight(weight))
            .foregroundColor(isToggled ? toggledColor : defaultColor)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { _ in
                        action()
                    }
            )
    }
}
