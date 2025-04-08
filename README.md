# Waveform Demo

一个简单的iOS音频波形可视化和播放控制演示应用。

## 功能

- 音频波形显示
- 播放/暂停控制
- 进度条拖动
- 循环播放选项

## 技术栈

- SwiftUI
- AVFoundation

## 主要文件

- `ContentView.swift`: 主界面
- `WaveformView.swift`: 波形图绘制
- `ProgressBar.swift`: 自定义进度条
- `AudioPlayerViewModel.swift`: 音频播放逻辑

## 使用方法

1. 打开应用
2. 点击播放/暂停按钮控制音频
3. 拖动进度条调整播放位置
4. 点击循环按钮开启/关闭循环播放

## 自定义

- 更改音频文件: 修改 `ContentView.swift` 中的 `viewModel.loadAudio(fileName: "your_audio_file")`
- 调整波形外观: 修改 `WaveformView.swift` 中的参数
- 添加新功能: 在 `AudioPlayerViewModel.swift` 中扩展功能

## 依赖

- [Inject](https://github.com/krzysztofzablocki/Inject): 用于实时代码注入
