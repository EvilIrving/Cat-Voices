# Cat-Voices

## 说明

- Voices 是 app 开发的代码,包含最新的实现, 只用看这一个项目的代码就可以了.
- ViewModelDemo.swift 是 测试 EnvironmentObject 的代码, 包含如何使用 EnvironmentObject 实现 ViewModel 的绑定. 需要新建项目, 将 ViewModelDemo 的代码复制到 ContentView.
- cutAudioFunc.swift 是音频剪辑函数的最小实现, 包含如何使用 AVFoundation 实现音频剪辑. 但代码运行还需要重新传入参数,音频等.
- audiodemo 可以忽略了

后续完成后会将不同的 demo 放在不同的 git 分支.

## 待办

[*] 录音
[ ] 数据持久化: 结合 SwiftData 或 CoreData 与文件系统进行数据持久化，再利用 Localizable.strings 和 UserDefaults 进行多语言和主题色的管理
    [ ] 用户设置 UserDefaults
      [ ] 主题色
      [ ] 语言
      [ ] 关于我们
    [ ] 猫咪数据 SwiftData
        - ⭐️⭐️⭐️⭐️⭐️: [如何使用SwiftData？如何与SwiftUI配合使用](https://blog.zhheo.com/p/92aa21b4.html)  
        - [Let's Integrate SwiftData CRUD into the Notes App, youtube 视频](https://www.youtube.com/watch?v=uK-OIchqh08)
        - ⭐️⭐️⭐️⭐️⭐️⭐️ : [using-swiftdata-to-store-large-files-from-an-api-call](https://medium.com/@jpmtech/using-swiftdata-to-store-large-files-from-an-api-call-11ad83404f76)
        - [SwiftData 实战：用现代方法构建 SwiftUI 应用](https://fatbobman.com/zh/posts/practical-swiftdata-building-swiftui-applications-with-modern-approaches/#%E6%96%B0%E7%9A%84%E9%97%AE%E9%A2%98%E6%95%B0%E6%8D%AE%E6%9B%B4%E6%96%B0%E5%90%8E%E8%A7%86%E5%9B%BE%E6%B2%A1%E6%9C%89%E5%88%B7%E6%96%B0)
        - [WWDC23 初识 SwiftData](https://www.swiftdict.com/wwdc23-meet-swiftdata.swift/WWDC23+%E5%88%9D%E8%AF%86+SwiftData)
    [ ] 录音存储管理 FileManager 存储在猫咪 id 对应的文件夹下
[ ] 音频剪辑

## 录音实现

`AudioRecorder.swift` 实现录音和保存功能. `AVAudioRecorder` `类用于录音，AVAudioPlayer` 类用于播放录音文件.

## 音频剪辑实现

AVFoundation 库提供了音频剪辑的功能，包括音频录制、音频播放、音频合成、音频处理等。 参考 cutAudioFile 文件对音频进行剪辑.但是 Swift 内置库 AVFoundation 只能进行 m4a 格式的音频剪辑, mp3 格式是只读的. 需要引入第三方库,如 ffmpeg-kit 等.

资料: 音频处理案例:

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

## 参考资料

[SwiftAudioEx: Swift 音频播放库](https://github.com/doublesymmetry/SwiftAudioEx):SwiftAudioEx is an audio player written in Swift, making it simpler to work with audio playback from streams and files.
[AudioKit Cookbook: 音频合成、处理和分析库](https://github.com/AudioKit/Cookbook)
AVAudioSession：用于管理音频会话和处理音频中断。
