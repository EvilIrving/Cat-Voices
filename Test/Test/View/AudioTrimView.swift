import AVFoundation
import SwiftUI

struct AudioTrimView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let audio: Audio?
    
    init(audio: Audio?) {
        print("audio: \(audio?.name)")
        self.audio = audio
    }

    var body: some View {
        VStack {
            Text("Trim Audio: \(audio?.name)")
                .font(.headline)
        }
    }
}
