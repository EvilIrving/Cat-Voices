//
//  AudioPlayManager.swift
//  Test
//
//  Created by Actor on 2024/10/7.
//

import AVFoundation
import Foundation

class AudioManager: NSObject, ObservableObject {
    @Published private(set) var isPlaying = false
    @Published private(set) var currentTime: TimeInterval = 0
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    func play(url: URL) throws {
        try setupAudioPlayer(with: url)
        startPlayback()
    }
    
    func pause() {
        audioPlayer?.pause()
        updatePlaybackState(isPlaying: false)
    }
    
    func resume() {
        guard let player = audioPlayer, !player.isPlaying else { return }
        player.play()
        updatePlaybackState(isPlaying: true)
    }
    
    func stop() {
        audioPlayer?.stop()
        updatePlaybackState(isPlaying: false)
        currentTime = 0
    }
    
    private func setupAudioPlayer(with url: URL) throws {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
    }
    
    private func startPlayback() {
        audioPlayer?.play()
        updatePlaybackState(isPlaying: true)
    }
    
    private func updatePlaybackState(isPlaying: Bool) {
        self.isPlaying = isPlaying
        isPlaying ? startTimer() : stopTimer()
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateCurrentTime()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateCurrentTime() {
        guard let player = audioPlayer, player.isPlaying else {
            stopTimer()
            return
        }
        currentTime = player.currentTime
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updatePlaybackState(isPlaying: false)
        currentTime = 0
    }
}
