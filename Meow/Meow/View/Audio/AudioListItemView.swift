import SwiftUI

struct AudioListItemView: View {
    let audio: Audio
    @ObservedObject var audioPlayerVM: AudioPlayerViewModel
    let isPlaying: Bool
    let progress: Double
    var onPlayPause: () -> Void
    var onShowTrim: () -> Void  // 新增的回调函数

    var body: some View {
        VStack(spacing: 10) {
            GeometryReader { geometry in
                HStack(spacing: 30) {
                    VStack(alignment: .leading) {
                        Text(audio.name)
                        WaveformView(samples: audio.waves, progress: progress)
                            .frame(width: geometry.size.width * 0.5, height: 30)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 0) {
                        Text("loop")
                            .font(.custom("Righteous-Regular", size: 16))
                            .foregroundColor(.accent.opacity(0.40))
                            .padding(.bottom, 2)

                        IconButton(
                            iconName: "ellipsis",
                            size: 25,
                            weight: .bold,
                            color: .customBlack,
                            action: onShowTrim  // 使用新的回调函数
                        )
                    }
                    .frame(height: 50)

                    VStack(spacing: 8) {
                        IconButton(
                            iconName: isPlaying
                                ? "pause.circle" : "play.circle",
                            size: 50,
                            color: Color.accent,
                            action: onPlayPause
                        )

                        Text(formatDuration(audio.duration))
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                            .foregroundColor(.accent.opacity(0.80))
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.customBlack, lineWidth: 1)
                )
                .frame(width: geometry.size.width)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 100)
        }
    }
}

func formatDuration(_ seconds: Double) -> String {
    let minutes = Int(seconds) / 60
    let remainingSeconds = Int(seconds) % 60
    return String(format: "%02d:%02d", minutes, remainingSeconds)
}

#Preview {
    do {
        let previewer = try MP3Preview()
        return SoundsView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
