import SwiftUI

struct PhotoSelectionView: View {
    let category: String
    @State private var selectedPhotos: Set<String> = []
    
    var body: some View {
        VStack {
            HStack {
                Text(category)
                    .font(.largeTitle).bold()
                Spacer()
                Button("Delete (\(selectedPhotos.count))") {
                    // Logic to delete selected assets
                }
                .disabled(selectedPhotos.isEmpty)
                .foregroundColor(.red)
            }
            .padding()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                    ForEach(0..<20) { i in
                        ZStack(alignment: .topTrailing) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(10)
                                .onTapGesture {
                                    if selectedPhotos.contains("\(i)") {
                                        selectedPhotos.remove("\(i)")
                                    } else {
                                        selectedPhotos.insert("\(i)")
                                    }
                                }
                            
                            if selectedPhotos.contains("\(i)") {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .padding(5)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}
