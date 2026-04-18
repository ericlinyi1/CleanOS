import SwiftUI

struct AnalysisProgressView: View {
    @StateObject private var viewModel: AnalysisProgressViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(categories: [AnalysisCategory]) {
        _viewModel = StateObject(wrappedValue: AnalysisProgressViewModel(categories: categories))
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                headerSection
                
                // Overall Progress
                overallProgressSection
                
                // Activity Log
                activityLogSection
                
                Spacer()
                
                // Actions
                actionButtonsSection
            }
            .padding()
        }
        .task {
            await viewModel.startAnalysis()
        }
        .alert("Analysis Complete", isPresented: $viewModel.showingComplete) {
            Button("View Results") {
                dismiss()
            }
        } message: {
            Text("Found \(viewModel.totalItemsFound) items using \(viewModel.totalSizeFound)")
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: viewModel.isComplete ? "checkmark.circle.fill" : "hourglass")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: viewModel.isComplete ? [.green, .cyan] : [.blue, .cyan],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .symbolEffect(.pulse, isActive: !viewModel.isComplete)
            }
            
            Text(viewModel.isComplete ? "Analysis Complete!" : "Scanning Library...")
                .font(.title2.bold())
                .foregroundColor(.white)
            
            if !viewModel.isComplete {
                Text(viewModel.currentActivity)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    // MARK: - Overall Progress
    
    private var overallProgressSection: some View {
        VStack(spacing: 16) {
            // Progress Bar
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 12)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: viewModel.overallProgress * UIScreen.main.bounds.width * 0.85, height: 12)
                    .animation(.linear(duration: 0.3), value: viewModel.overallProgress)
            }
            
            // Stats
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(viewModel.formatPercentage(viewModel.overallProgress)) Complete")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("\(viewModel.itemsProcessed) / \(viewModel.totalItems) items")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if let timeRemaining = viewModel.estimatedTimeRemaining {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Est. Time")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(timeRemaining)
                            .font(.headline)
                            .foregroundColor(.cyan)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
    
    // MARK: - Activity Log
    
    private var activityLogSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.activities) { activity in
                        ActivityRow(activity: activity)
                    }
                }
            }
            .frame(maxHeight: 300)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
    
    // MARK: - Action Buttons
    
    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            if !viewModel.isComplete {
                if viewModel.isPaused {
                    Button {
                        viewModel.resume()
                    } label: {
                        Label("Resume", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                } else {
                    Button {
                        viewModel.pause()
                    } label: {
                        Label("Pause", systemImage: "pause.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                
                Button {
                    viewModel.cancel()
                    dismiss()
                } label: {
                    Label("Cancel", systemImage: "xmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.red)
            } else {
                Button {
                    dismiss()
                } label: {
                    Label("Done", systemImage: "checkmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.bottom)
    }
}

// MARK: - Activity Row

struct ActivityRow: View {
    let activity: AnalysisActivity
    
    var body: some View {
        HStack(spacing: 12) {
            // Status Icon
            Image(systemName: activity.status.icon)
                .foregroundColor(activity.status.color)
                .font(.title3)
                .frame(width: 30)
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                
                if let detail = activity.detail {
                    Text(detail)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Result
            if let result = activity.result {
                Text(result)
                    .font(.caption.bold())
                    .foregroundColor(activity.status.color)
            } else if activity.status == .inProgress {
                ProgressView()
                    .tint(.blue)
                    .scaleEffect(0.8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.03))
        .cornerRadius(12)
    }
}

// MARK: - View Model

@MainActor
class AnalysisProgressViewModel: ObservableObject {
    @Published var activities: [AnalysisActivity] = []
    @Published var overallProgress: Double = 0
    @Published var itemsProcessed = 0
    @Published var totalItems = 0
    @Published var currentActivity = "Starting..."
    @Published var isComplete = false
    @Published var isPaused = false
    @Published var showingComplete = false
    
    @Published var totalItemsFound = 0
    @Published var totalSizeFound = ""
    
    private var startTime: Date?
    private var categories: [AnalysisCategory]
    private var isCancelled = false
    
    var estimatedTimeRemaining: String? {
        guard let start = startTime, itemsProcessed > 0, !isComplete else { return nil }
        
        let elapsed = Date().timeIntervalSince(start)
        let rate = Double(itemsProcessed) / elapsed
        let remaining = Double(totalItems - itemsProcessed) / rate
        
        if remaining < 60 {
            return "\(Int(remaining))s"
        } else if remaining < 3600 {
            return "\(Int(remaining / 60))m"
        } else {
            return "\(Int(remaining / 3600))h"
        }
    }
    
    init(categories: [AnalysisCategory]) {
        self.categories = categories
    }
    
    func startAnalysis() async {
        startTime = Date()
        
        // Calculate total work
        totalItems = await calculateTotalItems()
        
        for category in categories where !isCancelled && !isPaused {
            await analyzeCategory(category)
        }
        
        if !isCancelled {
            isComplete = true
            showingComplete = true
        }
    }
    
    private func analyzeCategory(_ category: AnalysisCategory) async {
        let activity = AnalysisActivity(
            id: UUID(),
            title: category.displayName,
            detail: "Scanning...",
            status: .inProgress
        )
        activities.append(activity)
        currentActivity = activity.title
        
        // Simulate analysis (replace with actual logic)
        let result = await performAnalysis(for: category)
        
        // Update activity
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities[index].status = .completed
            activities[index].result = result.summary
            activities[index].detail = result.detail
        }
        
        // Update progress
        itemsProcessed += result.itemsProcessed
        totalItemsFound += result.itemsFound
        overallProgress = Double(itemsProcessed) / Double(max(1, totalItems))
    }
    
    private func performAnalysis(for category: AnalysisCategory) async -> AnalysisResult {
        // This would be replaced with actual analysis logic
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        return AnalysisResult(
            itemsProcessed: 100,
            itemsFound: Int.random(in: 10...50),
            sizeFound: Int64.random(in: 1_000_000...100_000_000),
            summary: "\(Int.random(in: 10...50)) found",
            detail: "Completed"
        )
    }
    
    private func calculateTotalItems() async -> Int {
        // Placeholder - would fetch actual library size
        return categories.count * 100
    }
    
    func pause() {
        isPaused = true
    }
    
    func resume() {
        isPaused = false
        Task {
            await startAnalysis()
        }
    }
    
    func cancel() {
        isCancelled = true
    }
    
    func formatPercentage(_ value: Double) -> String {
        String(format: "%.0f%%", value * 100)
    }
}

// MARK: - Supporting Types

struct AnalysisActivity: Identifiable {
    let id: UUID
    let title: String
    var detail: String?
    var status: ActivityStatus
    var result: String?
}

enum ActivityStatus {
    case pending
    case inProgress
    case completed
    case failed
    
    var icon: String {
        switch self {
        case .pending: return "clock"
        case .inProgress: return "arrow.clockwise"
        case .completed: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .pending: return .gray
        case .inProgress: return .blue
        case .completed: return .green
        case .failed: return .red
        }
    }
}

enum AnalysisCategory {
    case duplicates
    case similar
    case blurry
    case screenshots
    case largeVideos
    
    var displayName: String {
        switch self {
        case .duplicates: return "Finding Duplicates"
        case .similar: return "Detecting Similar Photos"
        case .blurry: return "Analyzing Blur"
        case .screenshots: return "Finding Screenshots"
        case .largeVideos: return "Identifying Large Videos"
        }
    }
}

struct AnalysisResult {
    let itemsProcessed: Int
    let itemsFound: Int
    let sizeFound: Int64
    let summary: String
    let detail: String
}

#Preview {
    AnalysisProgressView(categories: [.duplicates, .similar, .blurry, .screenshots, .largeVideos])
}
