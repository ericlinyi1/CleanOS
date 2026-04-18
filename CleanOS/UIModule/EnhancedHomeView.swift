import SwiftUI

struct EnhancedHomeView: View {
    @StateObject private var viewModel = StorageViewModel()
    @State private var showingPermissionAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if !viewModel.hasPermission {
                    permissionView
                } else if viewModel.isLoading {
                    loadingView
                } else {
                    mainContent
                }
            }
            .navigationTitle("CleanOS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Settings
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                    }
                }
            }
            .task {
                if viewModel.hasPermission {
                    await viewModel.refresh()
                }
            }
            .alert("Permission Required", isPresented: $showingPermissionAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("CleanOS needs access to your photos to help you clean up storage.")
            }
        }
    }
    
    // MARK: - Permission View
    
    private var permissionView: some View {
        VStack(spacing: 30) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 80))
                .foregroundStyle(LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            VStack(spacing: 16) {
                Text("Photo Access Required")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text("CleanOS needs permission to scan your photo library and help you reclaim storage space.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button {
                Task {
                    let granted = await viewModel.requestPermission()
                    if granted {
                        await viewModel.refresh()
                    } else {
                        showingPermissionAlert = true
                    }
                }
            } label: {
                Text("Grant Permission")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal, 40)
            }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .tint(.white)
                .scaleEffect(1.5)
            
            Text("Analyzing your library...")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Storage Circle
                storageCircleSection
                
                // Storage Breakdown
                storageBreakdownSection
                
                // Potential Savings
                potentialSavingsSection
                
                // Quick Actions
                quickActionsSection
            }
            .padding(.top, 20)
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    // MARK: - Storage Circle Section
    
    private var storageCircleSection: some View {
        VStack(spacing: 20) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 15)
                    .frame(width: 200, height: 200)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: viewModel.usagePercentage)
                    .stroke(
                        LinearGradient(
                            colors: viewModel.usagePercentage > 0.8 ? [.red, .orange] : [.blue, .cyan],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.5), value: viewModel.usagePercentage)
                
                // Center text
                VStack(spacing: 4) {
                    Text(viewModel.formatPercentage(viewModel.usagePercentage))
                        .font(.system(size: 40, weight: .black))
                        .foregroundColor(.white)
                    
                    Text("USED")
                        .font(.caption2.bold())
                        .foregroundColor(.gray)
                    
                    Text("\(viewModel.formatBytes(viewModel.usedStorage)) / \(viewModel.formatBytes(viewModel.totalStorage))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Storage Breakdown Section
    
    private var storageBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Storage Breakdown")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                StorageBarRow(
                    icon: "photo",
                    label: "Photos",
                    size: viewModel.formatBytes(viewModel.photoStorage),
                    percentage: Double(viewModel.photoStorage) / Double(viewModel.totalStorage),
                    color: .blue
                )
                
                StorageBarRow(
                    icon: "video",
                    label: "Videos",
                    size: viewModel.formatBytes(viewModel.videoStorage),
                    percentage: Double(viewModel.videoStorage) / Double(viewModel.totalStorage),
                    color: .purple
                )
                
                StorageBarRow(
                    icon: "folder",
                    label: "Other",
                    size: viewModel.formatBytes(viewModel.otherStorage),
                    percentage: Double(viewModel.otherStorage) / Double(viewModel.totalStorage),
                    color: .green
                )
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
    
    // MARK: - Potential Savings Section
    
    private var potentialSavingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
                Text("Potential Savings")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text(viewModel.formatBytes(viewModel.potentialSavings))
                    .font(.title3.bold())
                    .foregroundStyle(LinearGradient(colors: [.green, .cyan], startPoint: .leading, endPoint: .trailing))
            }
            .padding(.horizontal)
            
            VStack(spacing: 0) {
                if viewModel.duplicatesCount > 0 {
                    NavigationLink(destination: PhotoSelectionView(category: "Duplicates")) {
                        CleanupRow(
                            icon: "doc.on.doc",
                            title: "Duplicates",
                            count: viewModel.duplicatesCount,
                            size: viewModel.formatBytes(viewModel.duplicatesSize),
                            color: .blue
                        )
                    }
                    Divider().background(Color.white.opacity(0.1))
                }
                
                if viewModel.screenshotsCount > 0 {
                    NavigationLink(destination: PhotoSelectionView(category: "Screenshots")) {
                        CleanupRow(
                            icon: "iphone.and.arrow.forward",
                            title: "Screenshots",
                            count: viewModel.screenshotsCount,
                            size: viewModel.formatBytes(viewModel.screenshotsSize),
                            color: .green
                        )
                    }
                    Divider().background(Color.white.opacity(0.1))
                }
                
                if viewModel.largeVideosCount > 0 {
                    NavigationLink(destination: VideoCleanupView()) {
                        CleanupRow(
                            icon: "video.badge.waveform",
                            title: "Large Videos",
                            count: viewModel.largeVideosCount,
                            size: viewModel.formatBytes(viewModel.largeVideosSize),
                            color: .orange
                        )
                    }
                }
                
                // Placeholder for similar (requires analysis)
                NavigationLink(destination: PhotoSelectionView(category: "Similar")) {
                    CleanupRow(
                        icon: "photo.on.rectangle",
                        title: "Similar Photos",
                        count: 0,
                        size: "Tap to scan",
                        color: .purple
                    )
                }
                
                Divider().background(Color.white.opacity(0.1))
                
                // Placeholder for blurry (requires analysis)
                NavigationLink(destination: PhotoSelectionView(category: "Blurry")) {
                    CleanupRow(
                        icon: "eye.slash",
                        title: "Blurry Photos",
                        count: 0,
                        size: "Tap to scan",
                        color: .red
                    )
                }
            }
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
    
    // MARK: - Quick Actions Section
    
    private var quickActionsSection: some View {
        HStack(spacing: 16) {
            Button {
                Task {
                    await viewModel.refresh()
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Rescan")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.3))
                .cornerRadius(12)
            }
            
            Button {
                // Quick clean action
            } label: {
                HStack {
                    Image(systemName: "trash")
                    Text("Quick Clean")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.3))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

// MARK: - Supporting Views

struct StorageBarRow: View {
    let icon: String
    let label: String
    let size: String
    let percentage: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 20)
                Text(label)
                    .foregroundColor(.white)
                Spacer()
                Text(size)
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 6)
                        .cornerRadius(3)
                        .animation(.spring(), value: percentage)
                }
            }
            .frame(height: 6)
        }
    }
}

struct CleanupRow: View {
    let icon: String
    let title: String
    let count: Int
    let size: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                if count > 0 {
                    Text("\(count) items • \(size)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text(size)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding()
    }
}

#Preview {
    EnhancedHomeView()
}
