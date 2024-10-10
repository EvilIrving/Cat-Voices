# 带波形可视化的音频播放器

这个 SwiftUI 项目展示了一个具有波形可视化、进度条和基本播放控制功能的音频播放器。该项目主要针对 iOS 设备开发。

## 功能特点

- 音频文件加载和播放
- 波形可视化显示
- 播放/暂停控制
- 循环播放选项
- 可交互的进度条，用于在音频中快速定位
- 播放过程中实时更新进度

## 项目结构

- `Code_with_CursorApp.swift`：应用程序的入口点
- `ContentView.swift`：包含主要 UI 元素的视图
- `AudioPlayerViewModel.swift`：管理音频播放状态和控制逻辑
- `WaveformView.swift`：渲染音频波形可视化
- `ProgressBar.swift`：自定义进度条组件

## 技术细节

- 使用 SwiftUI 构建用户界面
- 利用 AVFoundation 框架进行音频处理和播放
- 采用 MVVM 架构模式
- 集成了 Inject 库用于热重载开发

## 使用方法

1. 克隆仓库
2. 在 Xcode 中打开 `Code with Cursor.xcodeproj` 文件
3. 将您的音频文件（MP3 格式）添加到项目中
4. 在 `ContentView.swift` 中更新 `loadAudio(fileName:)` 调用，使用您的音频文件名
5. 在模拟器或 iOS 设备上运行项目

## 系统要求

- iOS 18.0+
- Xcode 16.0+
- Swift 5.0+

## 自定义

您可以通过修改相应的视图文件来自定义波形和进度条的外观。波形的采样点数量可以在 `AudioPlayerViewModel.swift` 的 `generateWaveformSamples()` 方法中调整。

## 注意事项

- 确保项目中包含有效的音频文件（.mp3 格式）
- 本项目使用了 Inject 库，可能需要额外的配置来启用热重载功能

## 贡献

欢迎提交问题报告和改进建议。如果您想为这个项目做出贡献，请随时提交 Pull Request。

## 许可证

本项目是开源的，基于 MIT 许可证发布。

## 致谢

本项目使用了 SwiftUI 框架、AVFoundation 进行音频播放，以及 Inject 库用于开发过程中的热重载。
