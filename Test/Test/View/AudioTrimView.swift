import AVFoundation
import SwiftUI

struct AudioTrimView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var audio: Audio
    @State private var soundName: String
    @State private var startTime: Double = 0
    @State private var endTime: Double = 0
    @State private var isSaving: Bool = false
    @State private var duration: CGFloat = 0

    init(audio: Audio) {
        _audio = State(initialValue: audio)
        _soundName = State(initialValue: audio.name)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sound Details")) {
                    TextField("Sound Name", text: $soundName)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }

                // Trimming section
                Section(header: Text("Trim Audio")) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(height: 40)

                            // Start Trim Marker
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 2, height: 50)
                                .position(x: max(1, startTime * geometry.size.width / duration),
                                          y: geometry.size.height / 2 - 2)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let newPosition = max(0, min(value.location.x, geometry.size.width))
                                            let newStartTime = (newPosition / geometry.size.width) * duration
                                            // 确保 startTime 不会超过 endTime
                                            startTime = min(newStartTime, endTime - 0.1) // 0.1 秒的最小间隔
                                        }
                                )

                            // End Trim Marker
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 2, height: 50)
                                .position(
                                    x: min(endTime / duration * geometry.size.width, geometry.size.width - 1),
                                    y: geometry.size.height / 2 - 2
                                )
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let newPosition = max(0, min(value.location.x, geometry.size.width))
                                            let newEndTime = (newPosition / geometry.size.width) * duration
                                            // 确保 endTime 不会小于 startTime
                                            endTime = max(newEndTime, startTime + 0.1) // 0.1 秒的最小间隔
                                        }
                                )
                        }
                    }
                    .frame(width: .infinity, height: 70)

                    HStack {
                        Text("Start: \(String(format: "%.2f", startTime))s")
                        Spacer()
                        Text("End: \(String(format: "%.2f", endTime))s")
                    }
                }
            }
            .onAppear {
                // Load duration asynchronously
                Task {
                    let asset: AVAsset = AVURLAsset(url: audio.url)
                    do {
                        let loadedDuration = try await asset.load(.duration)
                        duration = CGFloat(loadedDuration.seconds)
                        endTime = CGFloat(loadedDuration.seconds)
                        print("duration: \(duration)")
                    } catch {
                        print("Error loading asset duration: \(error)")
                    }
                }
            }
            .navigationTitle("Edit Sound")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        isSaving = true
                        Task {
                            await saveChanges()
                        }
                    }
                    .disabled(isSaving)
                }
            }
        }
    }

    private func saveChanges() async {
        do {
            let newURL = try await cutAudio(audio, startTime, endTime)
            audio.url = newURL
            audio.name = soundName
            modelContext.insert(audio)
            isSaving = false
            dismiss()
        } catch {
            print("Error saving changes: \(error)")
//            errorMessage = error.localizedDescription
            isSaving = false
        }
    }

    func cutAudio(_ audio: Audio, _ startTime: Double, _ endTime: Double) async throws -> URL {
        let asset = AVAsset(url: audio.url)
        let composition = AVMutableComposition()

        let tracks: [AVAssetTrack]
        if #available(iOS 16.0, *) {
            tracks = try await asset.loadTracks(withMediaType: .audio)
        } else {
            tracks = asset.tracks(withMediaType: .audio)
        }

        guard let track = tracks.first,
              let compositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            enum AudioTrimError: Error {
                case failedToGetAudioTrack
            }
            throw AudioTrimError.failedToGetAudioTrack
        }

        let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: 1000),
                                    end: CMTime(seconds: endTime, preferredTimescale: 1000))

        try compositionTrack.insertTimeRange(timeRange, of: track, at: .zero)

        let originalFileName = audio.url.deletingPathExtension().lastPathComponent
        let newURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(originalFileName)_trimmed.m4a")

        // 如果文件已存在，先删除它
        if FileManager.default.fileExists(atPath: newURL.path) {
            try FileManager.default.removeItem(at: newURL)
        }

        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        else {
            print("Failed to create export session")
            enum AVAssetExportSessionError: Error {
                case failedToCreateExportSession
            }
            throw AVAssetExportSessionError.failedToCreateExportSession
        }

        exportSession.outputURL = newURL
        exportSession.outputFileType = .m4a

        await exportSession.export()

        if let error = exportSession.error {
            throw error
        }

        // 删除原始音频文件
        try FileManager.default.removeItem(at: audio.url)

        // 将新文件移动到原始文件的位置
        let originalURL = audio.url
        try FileManager.default.moveItem(at: newURL, to: originalURL)

        return originalURL
    }
}

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: String
}
