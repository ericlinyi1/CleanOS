import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 30) {
                    // Header with Progress
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 15)
                                .frame(width: 200, height: 200)
                            Circle()
                                .trim(from: 0, to: 0.72)
                                .stroke(LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(-90))
                            VStack {
                                Text("72%")
                                    .font(.system(size: 40, weight: .black))
                                    .foregroundColor(.white)
                                Text("USED")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(.gray)
                            }
                        }
                        Text("CleanOS")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)

                    // Action Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        CategoryCard(title: "Duplicates", subtitle: "2.4 GB", icon: "clone", color: .blue)
                        CategoryCard(title: "Similar", subtitle: "4.1 GB", icon: "photo.on.rectangle", color: .purple)
                        CategoryCard(title: "Blurry", subtitle: "850 MB", icon: "eye.slash", color: .orange)
                        CategoryCard(title: "Screenshots", subtitle: "1.2 GB", icon: "iphone", color: .green)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct CategoryCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
            }
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            Text(subtitle)
                .font(.system(size: 12))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
}
