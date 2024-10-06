import AVFoundation
import Foundation
import SwiftData
import SwiftUI

// 定义 Cat 类，使用 @Model 注解，表示它是一个 SwiftData 模型
@Model
final class Cat {
    // 使用 @Attribute 注解，表示 id 属性是一个唯一的属性
    @Attribute(.unique) let id: UUID
    var name: String
    var age: String
    var desc: String
    var avatar: URL?
    var nickname: String?
    var gender: Gender
    var birthday: Date?
    var weight: Double?
    var bodyType: BodyType
    // 使用 @Relationship 注解，表示 audios 属性是一个关联关系，并定义了删除规则为级联删除
    @Relationship(deleteRule: .cascade) var audios: [Audio] = []

    // 初始化方法
    init(id: UUID = UUID(), name: String, age: String, desc: String, gender: Gender, bodyType: BodyType) {
        self.id = id
        self.name = name
        self.age = age
        self.desc = desc
        self.gender = gender
        self.bodyType = bodyType
    }
}

// 定义 Gender 枚举类型，使用 Codable 注解，表示它可以被编码和解码
enum Gender: String, Codable {
    case male, female, unknown
}

// 定义 BodyType 枚举类型，使用 Codable 注解，表示它可以被编码和解码
enum BodyType: String, Codable {
    case small, medium, large
}

// 定义 Audio 类，使用 @Model 注解，表示它是一个 SwiftData 模型
@Model
final class Audio {
    // 使用 @Attribute 注解，表示 id 属性是一个唯一的属性
    @Attribute(.unique) let id: UUID
    let url: URL
    let name: String
    var duration: Double

    // 使用 @Relationship 注解，表示 cat 属性是一个反向关联关系，并定义了关联的属性为 Cat 类的 audios 属性
    @Relationship(inverse: \Cat.audios) var cat: Cat?

    // 初始化方法
    init(id: UUID = UUID(), url: URL, name: String) {
        self.id = id
        self.url = url
        self.name = name
        duration = 0.0 // 初始化为 0，稍后会更新
    }

    // 使用 async/await 定义异步方法，用于更新音频时长
    func updateDuration() async {
        let asset = AVAsset(url: url)
        do {
            let duration = try await asset.load(.duration)
            await MainActor.run {
                self.duration = duration.seconds
            }
        } catch {
            print("Error loading audio duration: \(error)")
        }
    }
}

// 扩展 Cat 类，添加方法用于添加和删除音频
extension Cat {
    func addAudio(_ audio: Audio) {
        audios.append(audio)
        audio.cat = self
    }

    func removeAudio(_ audio: Audio) {
        audios.removeAll { $0.id == audio.id }
        audio.cat = nil
    }
}

// 定义 ContentView 结构体，作为应用程序的根视图
struct ContentView: View {
    var body: some View {
        TabView {
            SoundsView()
                .tabItem {
                    Label("Sounds", systemImage: "music.note")
                }

            CatsView()
                .tabItem {
                    Label("Cats", systemImage: "pawprint")
                }

            SettingView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

// 定义 SoundsView 结构体，用于显示猫的音频列表
struct SoundsView: View {
    // 使用 @Query 注解，获取所有 Cat 对象
    @Query private var cats: [Cat]
    // 使用 @State 注解，声明 selectedCat 属性，用于存储当前选中的猫
    @State private var selectedCat: Cat?
    // 使用 @State 注解，声明 isRecording 属性，用于指示是否正在录音
    @State private var isRecording: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // 如果 selectedCat 或 cats.first 不为空，则显示选中的猫的音频列表
                if let cat = selectedCat ?? cats.first {
                    Text("Sounds for \(cat.name)")
                        .font(.headline)

                    // 如果 cat 的 audios 列表为空，则显示无音频提示
                    if cat.audios.isEmpty {
                        Text("No sounds available for this cat.")
                            .foregroundColor(.secondary)
                    } else {
                        // 使用 List 视图显示猫的音频列表
                        List(cat.audios, id: \.id) { audio in
                            HStack {
                                Text(audio.name)
                                Spacer()
                                // 显示音频时长
                                Text(String(format: "%.1f sec", audio.duration))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Spacer()

                    // 显示录音按钮
                    if let cat = selectedCat {
                        // 使用 cat 对象
                        RecordButton(isRecording: $isRecording, cat: cat)
                    } else {
                        // 如果 selectedCat 为空，则显示提示信息
                        Text("Please select a cat.")
                            .foregroundColor(.secondary)
                    }
                } else {
                    // 如果没有猫，则显示无猫提示
                    Text("No cats available.")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Cat Sounds")
            .toolbar {
                // 添加一个工具栏按钮，用于选择猫
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Select Cat") {
                        // 遍历 cats 列表，为每个猫添加一个按钮
                        ForEach(cats) { cat in
                            Button(cat.name) {
                                selectedCat = cat
                            }
                        }
                    }
                }
            }
        }
    }
}

// 定义 CatsView 结构体，用于显示猫的列表
struct CatsView: View {
    // 使用 @Query 注解，获取所有 Cat 对象
    @Query private var cats: [Cat]
    // 使用 @Environment 注解，获取 modelContext 对象
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            // 使用 List 视图显示猫的列表
            List(cats) { cat in
                VStack(alignment: .leading) {
                    Text(cat.name)
                        .font(.headline)
                    Text("Age: \(cat.age)")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Cats")
            .toolbar {
                // 添加一个工具栏按钮，用于添加猫
                Button("Add Cat") {
                    addCat()
                }
            }
        }
    }

    // 添加猫的方法
    private func addCat() {
        let newCat = Cat(name: "New Cat", age: "1", desc: "A cute cat", gender: .unknown, bodyType: .medium)
        // 使用 modelContext 插入新的猫对象
        modelContext.insert(newCat)
    }
}

// 定义 SettingView 结构体，用于显示设置页面
struct SettingView: View {
    // 使用 @State 注解，声明 notificationsEnabled 和 darkModeEnabled 属性，用于控制通知和暗黑模式
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false

    var body: some View {
        NavigationView {
            Form {
                // 添加通知设置部分
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }

                // 添加外观设置部分
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                }

                // 添加关于部分
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// 定义 RecordButton 结构体，用于显示录音按钮
struct RecordButton: View {
    // 使用 @Binding 注解，绑定 isRecording 属性，用于指示是否正在录音
    @Binding var isRecording: Bool
    // 使用 @StateObject 注解，创建 AudioRecorder 对象
    @StateObject private var audioRecorder = AudioRecorder()
    // 使用 @Binding 注解，绑定 cat 属性，用于获取当前选中的猫
    @State var cat: Cat

    var body: some View {
        HStack {
            Spacer()

            // 显示录音按钮
            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                .resizable() // 使图标可调整大小
                .scaledToFit()
                .frame(width: 30, height: 30) // 固定宽高
                .scaleEffect(isRecording ? 0.6 : 1.0) // 录音时缩小 stop 图标
                .font(.largeTitle)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 10)
                .onTapGesture {
                    // 点击按钮时，根据 isRecording 状态，开始或停止录音
                    if isRecording {
                        audioRecorder.stopRecording()
                        if let url = audioRecorder.recordingURL {
                            let sound = Audio(id: UUID(), url: url, name: url.lastPathComponent)
                            cat.addAudio(sound) // 添加音频到猫的 audios 列表中
                            // 可选：调用 updateDuration() 更新音频时长
                            Task {
                                await sound.updateDuration()
                            }
                        }
                        isRecording = false
                    } else {
                        audioRecorder.startRecording(cat: cat)
                        isRecording = true
                    }
                }
        }
    }
}

class AudioRecorder: NSObject, ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var dateTimer: Date?

    // 使用 @Published 注解，声明 isRecording 和 isPlaying 属性，用于指示是否正在录音或播放
    @Published var isRecording = false
    @Published var isPlaying = false
    // 使用 @Published 注解，声明 recordingURL 属性，用于存储录音文件路径
    @Published var recordingURL: URL?

    // 初始化方法
    override init() {
        super.init()
        setupAudioSession()
    }

    // 设置音频会话
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    // 开始录音
    func startRecording(cat: Cat) {
        guard !isRecording else { return }

        isRecording = true
        updateButtonDetails()

        timerStart()

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
        ]

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let fileURL: URL
        let catFolderPath = paths[0].appendingPathComponent(cat.id.uuidString)
        do {
            try FileManager.default.createDirectory(at: catFolderPath, withIntermediateDirectories: true, attributes: nil)
            let recordingName = "声音\(cat.audios.count + 1).m4a"
            let fileURL = catFolderPath.appendingPathComponent(recordingName)
            recordingURL = fileURL
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            print("Started recording at \(fileURL.path)")
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }

    // 停止录音
    func stopRecording() {
        guard isRecording else { return }

        isRecording = false
        updateButtonDetails()

        timerStop()

        audioRecorder?.stop()
        print("Stopped recording at \(recordingURL?.path ?? "Unknown path")")
        audioRecorder = nil
    }

    // 开始播放
    func startPlaying() {
        guard let url = recordingURL, !isPlaying else { return }

        isPlaying = true
        updateButtonDetails()

        timerStart()

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Started playing sound from \(url.path)")
        } catch {
            print("Failed to start playing: \(error.localizedDescription)")
        }
    }

    // 停止播放
    func stopPlaying() {
        guard isPlaying else { return }

        isPlaying = false
        updateButtonDetails()

        timerStop()

        audioPlayer?.stop()
        print("Stopped playing sound")
        audioPlayer = nil
    }

    // 更新按钮状态
    private func updateButtonDetails() {
        // Implement UI update logic here
    }

    // 定时器方法
    private func timerStart() {
        dateTimer = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { _ in
            self.timerUpdate()
        }
    }

    private func timerUpdate() {
        if let dateTimer = dateTimer {
            let interval = Date().timeIntervalSince(dateTimer)
            let millisec = Int(interval * 100) % 100
            let seconds = Int(interval) % 60
            let minutes = Int(interval) / 60
            // Update timer label here
            print(String(format: "%02d:%02d:%02d", minutes, seconds, millisec))
        }
    }

    private func timerStop() {
        timer?.invalidate()
        timer = nil
    }
}

// 扩展 AudioRecorder 类，实现 AVAudioPlayerDelegate 协议
extension AudioRecorder: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        updateButtonDetails()
        timerStop()
    }
}

// 预览代码
#Preview {
    do {
        let previewer = try Previewer()
        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
