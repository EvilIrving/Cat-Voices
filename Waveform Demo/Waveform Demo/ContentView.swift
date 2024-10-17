import SwiftUI

/// 主要的内容视图结构体
struct ContentView: View {
    // 用于热重载的属性
    @ObserveInjection var inject

    // 创建并管理音频播放器视图模型
    @StateObject private var viewModel = AudioPlayerViewModel()

    var body: some View {
        ZStack {
            // 设置黑色背景
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                // 波形视图，显示音频波形
                WaveformView(
                    samples: viewModel.samples, progress: viewModel.progress
                )
                .frame(height: 40)
                .padding(.bottom, 30)

                // 进度条，用于显示和控制播放进度
                ProgressBar(progress: viewModel.progress) { newProgress in
                    viewModel.seek(to: newProgress)
                }
                .frame(height: 4)
                .padding(.bottom, 20)

                // 播放控制按钮
                HStack(spacing: 30) {
                    // 播放/暂停按钮
                    IconButton(
                        systemName: viewModel.isPlaying
                            ? "pause.circle" : "play.circle",
                        size: 50,
                        action: viewModel.togglePlayPause
                    )

                    // 循环播放按钮
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
            // 加载音频文件
            viewModel.loadAudio(fileName: "numbers")
        }
        .enableInjection()
    }
}

/// 自定义图标按钮视图
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
