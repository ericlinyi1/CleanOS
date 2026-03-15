import SwiftUI

struct SwipeReviewView: View {
    @State private var offset: CGSize = .zero
    @State private var photos = ["photo_1", "photo_2", "photo_3"] // 模拟数据
    @State private var decisionText: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Text(decisionText)
                    .font(.title2.bold())
                    .foregroundColor(offset.width > 0 ? .green : .red)
                    .opacity(abs(offset.width) / 100)
                
                ZStack {
                    ForEach(photos.indices, id: \.self) { index in
                        CardView(imageName: photos[index])
                            .offset(index == photos.count - 1 ? offset : .zero)
                            .rotationEffect(.degrees(Double(offset.width / 20)))
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if index == photos.count - 1 {
                                            offset = gesture.translation
                                            decisionText = offset.width > 0 ? "KEEP" : "DELETE"
                                        }
                                    }
                                    .onEnded { _ in
                                        if abs(offset.width) > 150 {
                                            withAnimation(.spring()) {
                                                photos.removeLast()
                                                offset = .zero
                                            }
                                        } else {
                                            withAnimation(.spring()) {
                                                offset = .zero
                                            }
                                        }
                                    }
                            )
                    }
                }
                .padding()
            }
        }
    }
}

struct CardView: View {
    let imageName: String
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(Color.white.opacity(0.1))
            .overlay(
                VStack {
                    Image(systemName: "photo")
                        .font(.system(size: 80))
                    Text(imageName)
                        .font(.headline)
                }
            )
            .frame(height: 500)
            .shadow(radius: 10)
    }
}
