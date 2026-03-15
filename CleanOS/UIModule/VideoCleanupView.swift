import SwiftUI

struct VideoCleanupView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Large Videos")
                .font(.title).bold()
            
            List {
                ForEach(0..<5) { i in
                    HStack {
                        Image(systemName: "video.fill")
                            .foregroundColor(.orange)
                        VStack(alignment: .leading) {
                            Text("Video_\(i).mp4")
                                .font(.headline)
                            Text("1.2 GB • 4K")
                                .font(.subheadline).foregroundColor(.gray)
                        }
                        Spacer()
                        Button("Compress") {
                            // Trigger HEVC compression
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.black.ignoresSafeArea())
    }
}
