import SwiftUI

struct ProgressBar: View {
    let progress: Double
    var onSeek: (Double) -> Void
    let cornerRadius: CGFloat = 5

    var body: some View {
        GeometryReader { geometry in
            let fullWidth = geometry.size.width
            let barWidth = fullWidth * 0.9

            HStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.gray)

                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white)
                        .frame(width: barWidth * CGFloat(progress))
                }
                .frame(width: barWidth)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let xPosition = value.location.x
                            let newProgress = min(
                                max(xPosition / barWidth, 0), 1)  // 确保进度值在 0 到 1 之间
                            onSeek(newProgress)
                        }
                )
            }
            .frame(maxWidth: .infinity)
        }
    }
}
