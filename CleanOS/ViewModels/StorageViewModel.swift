import SwiftUI
import Photos
import Combine

/// Manages storage statistics and photo library analysis
@MainActor
class StorageViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var totalStorage: Int64 = 0
    @Published var usedStorage: Int64 = 0
    @Published var photoStorage: Int64 = 0
    @Published var videoStorage: Int64 = 0
    @Published var otherStorage: Int64 = 0
    
    @Published var duplicatesSize: Int64 = 0
    @Published var similarSize: Int64 = 0
    @Published var screenshotsSize: Int64 = 0
    @Published var largeVideosSize: Int64 = 0
    @Published var blurrySize: Int64 = 0
    
    @Published var duplicatesCount: Int = 0
    @Published var similarCount: Int = 0
    @Published var screenshotsCount: Int = 0
    @Published var largeVideosCount: Int = 0
    @Published var blurryCount: Int = 0
    
    @Published var error: StorageError?
    @Published var hasPermission = false
    
    // Computed properties
    var usagePercentage: Double {
        guard totalStorage > 0 else { return 0 }
        return Double(usedStorage) / Double(totalStorage)
    }
    
    var potentialSavings: Int64 {
        duplicatesSize + similarSize + screenshotsSize + largeVideosSize + blurrySize
    }
    
    // MARK: - Initialization
    
    init() {
        checkPermission()
    }
    
    // MARK: - Permission Management
    
    func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        hasPermission = (status == .authorized || status == .limited)
    }
    
    func requestPermission() async -> Bool {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        await MainActor.run {
            hasPermission = (status == .authorized || status == .limited)
        }
        return hasPermission
    }
    
    // MARK: - Data Loading
    
    func refresh() async {
        isLoading = true
        error = nil
        
        do {
            // Load storage stats
            await loadStorageStats()
            
            // Analyze library
            await analyzeLibrary()
            
        } catch {
            self.error = .analysisFailedError(error)
        }
        
        isLoading = false
    }
    
    private func loadStorageStats() async {
        // Get device storage
        if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let totalSpace = attributes[.systemSize] as? Int64,
           let freeSpace = attributes[.systemFreeSize] as? Int64 {
            
            await MainActor.run {
                self.totalStorage = totalSpace
                self.usedStorage = totalSpace - freeSpace
            }
        }
        
        // Calculate photo library storage
        let (photoSize, videoSize) = await calculatePhotoLibrarySize()
        
        await MainActor.run {
            self.photoStorage = photoSize
            self.videoStorage = videoSize
            self.otherStorage = self.usedStorage - photoSize - videoSize
        }
    }
    
    private func calculatePhotoLibrarySize() async -> (photos: Int64, videos: Int64) {
        var photoSize: Int64 = 0
        var videoSize: Int64 = 0
        
        let fetchOptions = PHFetchOptions()
        let allAssets = PHAsset.fetchAssets(with: fetchOptions)
        
        // Use semaphore to synchronize async operations
        await withCheckedContinuation { continuation in
            allAssets.enumerateObjects { asset, _, _ in
                let resources = PHAssetResource.assetResources(for: asset)
                let assetSize = resources.compactMap { 
                    $0.value(forKey: "fileSize") as? Int64 
                }.reduce(0, +)
                
                if asset.mediaType == .image {
                    photoSize += assetSize
                } else if asset.mediaType == .video {
                    videoSize += assetSize
                }
            }
            continuation.resume()
        }
        
        return (photoSize, videoSize)
    }
    
    private func analyzeLibrary() async {
        // Run analysis in parallel
        async let duplicates = findDuplicates()
        async let screenshots = findScreenshots()
        async let largeVideos = findLargeVideos()
        
        let (dupResults, screenshotResults, videoResults) = await (duplicates, screenshots, largeVideos)
        
        await MainActor.run {
            self.duplicatesCount = dupResults.count
            self.duplicatesSize = dupResults.size
            
            self.screenshotsCount = screenshotResults.count
            self.screenshotsSize = screenshotResults.size
            
            self.largeVideosCount = videoResults.count
            self.largeVideosSize = videoResults.size
            
            // Similar and blurry require more complex analysis - set to 0 for now
            // Will be calculated on-demand in their respective views
            self.similarCount = 0
            self.similarSize = 0
            self.blurryCount = 0
            self.blurrySize = 0
        }
    }
    
    // MARK: - Analysis Functions
    
    private func findDuplicates() async -> (count: Int, size: Int64) {
        // Simplified duplicate detection
        // Full implementation would use hash-based detection
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var hashMap: [String: (asset: PHAsset, size: Int64)] = [:]
        var duplicateSize: Int64 = 0
        var duplicateCount = 0
        
        await withCheckedContinuation { continuation in
            allAssets.enumerateObjects { asset, _, _ in
                // Use creation date + dimensions as simple hash
                // Real implementation would use image hash
                let simpleHash = "\(asset.pixelWidth)x\(asset.pixelHeight)_\(asset.creationDate?.timeIntervalSince1970 ?? 0)"
                
                let resources = PHAssetResource.assetResources(for: asset)
                let size = resources.compactMap { $0.value(forKey: "fileSize") as? Int64 }.reduce(0, +)
                
                if let existing = hashMap[simpleHash] {
                    // Found potential duplicate
                    duplicateSize += size
                    duplicateCount += 1
                } else {
                    hashMap[simpleHash] = (asset, size)
                }
            }
            continuation.resume()
        }
        
        return (duplicateCount, duplicateSize)
    }
    
    private func findScreenshots() async -> (count: Int, size: Int64) {
        let screenshots = ScreenshotDetector.fetchScreenshots()
        let size = ScreenshotDetector.calculateTotalSize(screenshots)
        return (screenshots.count, size)
    }
    
    private func findLargeVideos() async -> (count: Int, size: Int64) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        let videos = PHAsset.fetchAssets(with: fetchOptions)
        
        var largeVideoSize: Int64 = 0
        var largeVideoCount = 0
        let sizeThreshold: Int64 = 1024 * 1024 * 1024 // 1 GB
        
        await withCheckedContinuation { continuation in
            videos.enumerateObjects { asset, _, _ in
                let resources = PHAssetResource.assetResources(for: asset)
                let size = resources.compactMap { $0.value(forKey: "fileSize") as? Int64 }.reduce(0, +)
                
                if size > sizeThreshold {
                    largeVideoSize += size
                    largeVideoCount += 1
                }
            }
            continuation.resume()
        }
        
        return (largeVideoCount, largeVideoSize)
    }
    
    // MARK: - Formatting
    
    func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        formatter.includesUnit = true
        formatter.isAdaptive = true
        return formatter.string(fromByteCount: bytes)
    }
    
    func formatPercentage(_ value: Double) -> String {
        String(format: "%.0f%%", value * 100)
    }
}

// MARK: - Error Types

enum StorageError: LocalizedError {
    case permissionDenied
    case analysisFailedError(Error)
    case loadingFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Permission to access photos was denied"
        case .analysisFailedError(let error):
            return "Analysis failed: \(error.localizedDescription)"
        case .loadingFailed(let message):
            return "Loading failed: \(message)"
        }
    }
}
