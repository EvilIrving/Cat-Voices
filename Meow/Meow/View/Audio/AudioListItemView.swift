import SwiftUI
import SwiftData

struct AudioListItemView: View {
    let audio: Audio
    @ObservedObject var audioPlayerVM: AudioPlayerViewModel
    let isPlaying: Bool
    let progress: Double
    var onPlayPause: () -> Void
    var onShowTrim: () -> Void
    @Environment(\.modelContext) private var modelContext

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
                        TextButton(
                            text: "loop",
                            isToggled: audio.isLooping,
                            action: {
                                toggleLooping()
                            }
                        )
                        .padding(.bottom, 2)

                        IconButton(
                            iconName: "ellipsis",
                            size: 25,
                            weight: .bold,
                            color: .customBlack,
                            action: onShowTrim
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

                        Text(isPlaying ? formatCurrentTime(audioPlayerVM.currentTime) : formatTotalDuration(audio.duration))
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

    private func toggleLooping() {
        audio.isLooping.toggle()
        modelContext.insert(audio)
        
        if audioPlayerVM.currentAudioURL == audio.url {
            audioPlayerVM.setLooping(audio.isLooping)
        }
    }
}

func formatCurrentTime(_ seconds: Double) -> String {
    let totalSeconds = Int(floor(seconds))
    let minutes = totalSeconds / 60
    let remainingSeconds = totalSeconds % 60
    return String(format: "%02d:%02d", minutes, remainingSeconds)
}

func formatTotalDuration(_ seconds: Double) -> String {
    let roundedSeconds = Int(seconds.rounded())
    let minutes = roundedSeconds / 60
    let remainingSeconds = roundedSeconds % 60
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
