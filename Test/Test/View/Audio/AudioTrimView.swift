import AVFoundation
import SwiftUI

struct AudioTrimView: View {
    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - State
    @State private var audio: Audio
    @State private var soundName: String
    @State private var startTime: Double = 0
    @State private var endTime: Double = 0
    @State private var isSaving: Bool = false
    @State private var duration: CGFloat = 0
    @State private var errorWrapper: ErrorWrapper?

    // MARK: - Initialization
    init(audio: Audio) {
        _audio = State(initialValue: audio)
        _soundName = State(initialValue: audio.name)
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                soundDetailsSection
                audioTrimSection
            }
            .onAppear(perform: loadAudioDuration)
            .navigationTitle("Edit Sound")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
            .alert(item: $errorWrapper) { wrapper in
                Alert(title: Text("Error"), message: Text(wrapper.error), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // MARK: - UI Components
    private var soundDetailsSection: some View {
        Section(header: Text("Sound Details")) {
            TextField("Sound Name", text: $soundName)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
    
    private var audioTrimSection: some View {
        Section(header: Text("Trim Audio")) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    backgroundRectangle
                    startTrimMarker(in: geometry)
                    endTrimMarker(in: geometry)
                }
            }
            .frame(height: 70)
            
            HStack {
                Text("Start: \(String(format: "%.2f", startTime))s")
                Spacer()
                Text("End: \(String(format: "%.2f", endTime))s")
            }
        }
    }
    
    private var backgroundRectangle: some View {
        Rectangle()
            .fill(Color.blue.opacity(0.3))
            .frame(height: 40)
    }
    
    private func trimMarker(at position: CGFloat, in geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: 2, height: 50)
            .position(x: position, y: geometry.size.height / 2 - 2)
    }
    
    private func startTrimMarker(in geometry: GeometryProxy) -> some View {
        trimMarker(at: max(1, startTime * geometry.size.width / duration), in: geometry)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { updateStartTime(with: $0, in: geometry) }
            )
    }
    
    private func endTrimMarker(in geometry: GeometryProxy) -> some View {
        trimMarker(at: min(endTime / duration * geometry.size.width, geometry.size.width - 1), in: geometry)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { updateEndTime(with: $0, in: geometry) }
            )
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            isSaving = true
            Task {
                await saveChanges()
            }
        }
        .disabled(isSaving)
    }
    
    // MARK: - Helper Methods
    private func updateStartTime(with value: DragGesture.Value, in geometry: GeometryProxy) {
        let newPosition = max(0, min(value.location.x, geometry.size.width))
        let newStartTime = (newPosition / geometry.size.width) * duration
        startTime = min(newStartTime, endTime - 0.1) // 0.1 秒的最小间隔
    }
    
    private func updateEndTime(with value: DragGesture.Value, in geometry: GeometryProxy) {
        let newPosition = max(0, min(value.location.x, geometry.size.width))
        let newEndTime = (newPosition / geometry.size.width) * duration
        endTime = max(newEndTime, startTime + 0.1) // 0.1 秒的最小间隔
    }
    
    private func loadAudioDuration() {
        Task {
            do {
                let asset = AVURLAsset(url: audio.url)
                let loadedDuration = try await asset.load(.duration)
                duration = CGFloat(loadedDuration.seconds)
                endTime = duration
            } catch {
                errorWrapper = ErrorWrapper(error: "Error loading audio duration: \(error.localizedDescription)")
            }
        }
    }

    private func saveChanges() async {
        do {
            let newURL = try await cutAudio(audio, startTime, endTime)
            audio.url = newURL
            audio.name = soundName
            await audio.updateDuration()
            modelContext.insert(audio)
            isSaving = false
            dismiss()
        } catch {
            errorWrapper = ErrorWrapper(error: "Error saving changes: \(error.localizedDescription)")
            isSaving = false
        }
    }

    // MARK: - Audio Processing
    private func cutAudio(_ audio: Audio, _ startTime: Double, _ endTime: Double) async throws -> URL {
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

// MARK: - Supporting Types
struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: String
}