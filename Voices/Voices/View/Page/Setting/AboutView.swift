import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("App Name: Cat Sounds")
                .font(.headline)
            Text("Version: 1.0.0")
                .font(.subheadline)
            Text("This app allows users to record and manage sounds for their cats. It supports multiple languages and themes.")
                .padding(.top, 10)
            Spacer()
        }
        .padding()
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
