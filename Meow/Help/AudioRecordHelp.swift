//
//  AudioRecordHelp.swift
//  Test
//
//  Created by Actor on 2024/10/7.
//

import AVFoundation
import SwiftUI

class AudioRecorder: NSObject, ObservableObject {
    // MARK: - Published properties
    @Published private(set) var isRecording = false
    @Published private(set) var isPlaying = false
    @Published private(set) var recordingURL: URL?
    @Published private(set) var timerDisplay: String = "00:00:00"

    // MARK: - Private properties
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var dateTimer: Date?

    // MARK: - Initialization
    override init() {
        super.init()
        setupAudioSession()
    }

    // MARK: - Public methods
    func startRecording(cat: Cat) {
        guard !isRecording else { return }
        
        isRecording = true
        timerStart()
        
        do {
            let fileURL = try createAudioFileURL(for: cat)
            try setupAudioRecorder(fileURL: fileURL)
            audioRecorder?.record()
            recordingURL = fileURL
            print("Started recording at \(fileURL.path)")
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        guard isRecording else { return }
        
        isRecording = false
        timerStop()
        
        audioRecorder?.stop()
        print("Stopped recording at \(recordingURL?.path ?? "Unknown path")")
        audioRecorder = nil
    }

    func startPlaying() {
        guard let url = recordingURL, !isPlaying else { return }
        
        isPlaying = true
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

    func stopPlaying() {
        guard isPlaying else { return }
        
        isPlaying = false
        timerStop()
        
        audioPlayer?.stop()
        print("Stopped playing sound")
        audioPlayer = nil
    }

    // MARK: - Private methods
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    private func createAudioFileURL(for cat: Cat) throws -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let catFolderPath = paths[0].appendingPathComponent(cat.id.uuidString)
        try FileManager.default.createDirectory(at: catFolderPath, withIntermediateDirectories: true, attributes: nil)
        let recordingName = "声音\(cat.audios.count + 1).m4a"
        return catFolderPath.appendingPathComponent(recordingName)
    }

    private func setupAudioRecorder(fileURL: URL) throws {
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
        ]
        audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
        audioRecorder?.prepareToRecord()
    }

    // MARK: - Timer methods
    private func timerStart() {
        dateTimer = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { [weak self] _ in
            self?.timerUpdate()
        }
    }

    private func timerUpdate() {
        guard let dateTimer = dateTimer else { return }
        
        let interval = Date().timeIntervalSince(dateTimer)
        let millisec = Int(interval * 100) % 100
        let seconds = Int(interval) % 60
        let minutes = Int(interval) / 60
        
        timerDisplay = String(format: "%02d:%02d:%02d", minutes, seconds, millisec)
    }

    private func timerStop() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioRecorder: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        timerStop()
    }
}
