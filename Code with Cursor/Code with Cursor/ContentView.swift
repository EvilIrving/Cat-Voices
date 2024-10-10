import SwiftUI

struct ContentView: View {

    @ObserveInjection var inject

    @StateObject private var viewModel = AudioPlayerViewModel()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                // TODO
                // 不用 CADisplayLink 是怎么做到实时显示的
                
                WaveformView(
                    samples: viewModel.samples, progress: viewModel.progress
                )
                .frame(height: 40)
                .padding(.bottom, 30)

                ProgressBar(progress: viewModel.progress) { newProgress in
                    viewModel.seek(to: newProgress)
                }
                .frame(height: 4)
                .padding(.bottom, 20)

                HStack(spacing: 30) {
                    IconButton(
                        systemName: viewModel.isPlaying
                            ? "pause.circle" : "play.circle",
                        size: 50,
                        action: viewModel.togglePlayPause
                    )

                    IconButton(
                        systemName: viewModel.isLooping ? "repeat.1" : "repeat",
                        size: 30,
                        action: viewModel.toggleLoop
                    )
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadAudio(fileName: "numbers")
        }
        .enableInjection()
    }
}

struct IconButton: View {
    let systemName: String
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: size, height: size)
            .foregroundColor(.white)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { _ in
                        action()
                    }
            )
    }
}

#Preview {
    ContentView()
}
