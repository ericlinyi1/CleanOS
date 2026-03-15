import SwiftUI

struct OnboardingView: View {
    @State private var isShowingMain = false
    
    var body: some View {
        if isShowingMain {
            HomeView()
        } else {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 40) {
                    Spacer()
                    Image(systemName: "sparkles")
                        .font(.system(size: 80))
                        .foregroundStyle(LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                    
                    VStack(spacing: 16) {
                        Text("CleanOS")
                            .font(.system(size: 42, weight: .black))
                            .foregroundColor(.white)
                        Text("Reclaim your storage with AI-powered cleaning.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                    
                    Button(action: { isShowingMain = true }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}
