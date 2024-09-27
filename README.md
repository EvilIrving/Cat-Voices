# Cat-Voices

## 说明

- Voices 是 app 开发的代码,包含最新的实现, 只用看这一个项目的代码就可以了.
- ViewModelDemo.swift 是 测试 EnvironmentObject 的代码, 包含如何使用 EnvironmentObject 实现 ViewModel 的绑定. 需要新建项目, 将 ViewModelDemo 的代码复制到 ContentView.
- CatVoice 是录音的实现 demo
- audiodemo 是 音频剪辑的实现 demo

后续完成后会将不同的 demo 放在不同的 git 分支.

## 待办

[*] 录音
[ ] 数据持久化
    [ ] 用户设置
    [ ] 猫咪数据
[ ] 音频剪辑


## 录音实现

## 音频剪辑实现

AVFoundation 库提供了音频剪辑的功能，包括音频录制、音频播放、音频合成、音频处理等。

1. EditView.swift 页面获取 audio 音频文件

    ```swift
    EditView(audioFile: binding(for: audioFile))
    ```

2. 创建副本 audioFile Comform to AudioFile , 副本文件名为原始文件名_副本, 副本文件位于原始文件文件夹下.
3. 拖拽左侧滑块, 调整 start 值,  拖拽右侧滑块,调整 end 值.
4. 点击播放按钮,播放副本文件,播放 start 到 end 区间的音频.
5. 点击保存按钮,保存副本文件,保存 start 到 end 区间的音频到原始文件文件夹下, 删除原始文件.
6. 将副本文件 链接到 原始资源文件中.

资料:

音频处理案例:

1. Convert audio to MP3: <https://github.com/SingletonH/SwiftRecorder/blob/master/SwiftRecorder/ConvertMp3.m>

集成 FFMPEG 库:

1. ffmpeg-kit: <https://github.com/arthenica/ffmpeg-kit/tree/main/apple>
2. 手动安装
3. 通过 CocoaPods 添加 FFmpeg

## 状态管理和文件管理实现

 数据状态管理和持久化存储有多种方案，涵盖从简单的数据持久化到复杂的状态管理。以下是常见的几种方法：

### 1. **State 和 State Management**

   iOS 中的数据状态管理涉及多个层次，主要用于处理 UI 和应用的交互状态。

- **SwiftUI 的 `@State` 和 `@Binding`**
  - `@State` 用于管理单个视图的本地状态。
  - `@Binding` 允许在父视图和子视图之间传递状态，从而实现数据共享和双向绑定。

- **`@ObservedObject` 和 `@StateObject`**
  - `@ObservedObject` 用于在不同视图之间共享对象的状态，通常与符合 `ObservableObject` 协议的对象一起使用。
  - `@StateObject` 与 `@ObservedObject` 类似，但用于创建并拥有状态。

- **`@EnvironmentObject`**
  - `@EnvironmentObject` 用于全局状态共享，适合多个视图间共享数据，通常与大型应用中的状态管理器结合使用。

- **Redux/MVVM 框架**
  - Redux 是一种集中式的状态管理模式，常用于大型应用。Swift 语言中有 `ReSwift` 等库实现了类似的 Redux 状态管理。
  - MVVM（Model-View-ViewModel）模式通过 `ViewModel` 来管理 UI 状态。

### 2. **持久化存储方案**

   持久化存储用于保存应用的数据，确保在应用重启时仍可访问这些数据。

- **`UserDefaults`**
  - 适合存储小量的、简单的键值对数据，例如用户设置、偏好等。`UserDefaults` 存储的数据是自动持久化的。
  - 示例：

       ```swift
       let defaults = UserDefaults.standard
       defaults.set("John", forKey: "username")
       let username = defaults.string(forKey: "username")
       ```

- **Keychain**
  - 用于存储敏感数据，如密码、令牌等，Keychain 提供加密存储。

- **文件存储 (File Storage)**
  - 可以将数据序列化为 JSON、Plist、或直接保存为文本文件，存储在设备的沙盒文件系统中。
  - 使用 `FileManager` 管理文件的创建、读写。

- **`CoreData`**
  - `CoreData` 是 iOS 中强大的对象图和关系数据持久化框架，适合处理复杂的数据模型和关系数据库操作。
  - `CoreData` 支持事务管理、数据查询和对象生命周期管理。

- **`SQLite`**
  - 对于对性能要求较高或者需要与 SQL 数据库交互的场景，可以使用 `SQLite`，这是一个轻量级的嵌入式关系数据库。
  - iOS 上可以直接使用 SQLite，或者通过第三方库如 `GRDB`、`FMDB` 进行封装。

- **`Realm`**
  - `Realm` 是一个第三方数据库，兼具强大功能和易用性，适用于需要在本地保存大量数据的应用。相比 `CoreData`，`Realm` 的 API 更加简洁，性能也较好。

- **`CloudKit`**
  - `CloudKit` 是 Apple 提供的云存储服务，可以将数据同步到 iCloud，适合需要云端同步的应用。

### 3. **组合使用**

- 通常会根据应用的需求，组合使用不同的方案。例如：
  - 使用 `UserDefaults` 存储简单的用户偏好设置。
  - 使用 `CoreData` 或 `Realm` 持久化应用的主要数据。
  - 使用 `@StateObject` 或 `@EnvironmentObject` 管理应用内的状态，并将部分状态通过 `UserDefaults` 或数据库持久化。

根据应用规模和数据复杂度，可以选择合适的状态管理和持久化方案来实现高效的状态管理和数据持久化。
