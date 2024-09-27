import AVFoundation
import PlaygroundSupport

// Allows playground to continue execution after async tasks
PlaygroundPage.current.needsIndefiniteExecution = true

/**
  Trim an audio file from `fromTime` to `toTime`.
  
  - Parameters:
    - audioPath: The path of the original audio file.
    - fromTime: The starting point for trimming (in seconds).
    - toTime: The ending point for trimming (in seconds).
    - outputPath: The path where the trimmed audio will be saved.
*/
func cutAudio(audioPath: String, fromTime: TimeInterval, toTime: TimeInterval, outputPath: String) {
    
    // 1. Load the audio file from the given path
    let asset = AVURLAsset(url: URL(fileURLWithPath: audioPath))
    
    // 2. Create an export session to export audio as M4A format
    guard let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
        print("Failed to create export session")
        return
    }
    
    // 3. Set the output file type and output URL for the trimmed file
    session.outputFileType = .m4a
    session.outputURL = URL(fileURLWithPath: outputPath)
    
    // 4. Define the time range to trim the audio (start and end points in seconds)
    let startTime = CMTime(seconds: fromTime, preferredTimescale: 1)
    let endTime = CMTime(seconds: toTime, preferredTimescale: 1)
    session.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
    
    // 5. Start exporting the trimmed audio asynchronously
    session.exportAsynchronously {
        switch session.status {
        case .completed:
            print("Audio trimming completed successfully. Output saved at \(outputPath)")
        case .failed:
            if let error = session.error {
                print("Export failed with error: \(error.localizedDescription)")
            }
        default:
            print("Export status: \(session.status.rawValue)")
        }
        
        // Stop playground execution when task completes
        PlaygroundPage.current.finishExecution()
    }
}

// Paths for audio input and output
if let inputPath = Bundle.main.path(forResource: "School", ofType: "m4a") {
    // Set up a path for the trimmed audio output (in the playground directory)
    let outputPath = NSTemporaryDirectory() + "trimmed.m4a"
    
    // Call the audio trimming function
    cutAudio(audioPath: inputPath, fromTime: 0.0, toTime: 10.0, outputPath: outputPath)
} else {
    print("Failed to find the input audio file.")
}
