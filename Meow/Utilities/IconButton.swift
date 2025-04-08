import SwiftUI

struct IconButton: View {
    let isSystemImage: Bool
    let iconName: String
    let size: CGFloat
    let weight: Font.Weight
    let color: Color
    let action: () -> Void

    init(
        isSystemImage: Bool = true,
        iconName: String,
        size: CGFloat,
        weight: Font.Weight = .regular,
        color: Color = .black,
        action: @escaping () -> Void
    ) {
        self.isSystemImage = isSystemImage
        self.iconName = iconName
        self.size = size
        self.weight = weight
        self.color = color
        self.action = action
    }

    var body: some View {
        Group {
            if isSystemImage {
                Image(systemName: iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(.system(size: size, weight: weight))
            } else {
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(.system(size: size, weight: weight))
            }
        }
        .frame(width: size, height: size)
        .foregroundColor(color)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { _ in
                    action()
                }
        )
    }
}
