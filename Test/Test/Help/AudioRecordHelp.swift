//
//  AudioRecordHelp.swift
//  Test
//
//  Created by Actor on 2024/10/7.
//

import AVFoundation
import SwiftUI

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
