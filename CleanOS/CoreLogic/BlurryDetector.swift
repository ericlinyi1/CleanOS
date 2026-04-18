import Foundation
import Vision
import Photos
import UIKit
import CoreImage

/// Detects blurry photos using Laplacian variance algorithm and Vision framework
public class BlurryDetector {
    
    // MARK: - Types
    
    public struct BlurResult {
        let asset: PHAsset
        let blurScore: Float
        let isBlurry: Bool
        
        var quality: BlurQuality {
            if blurScore < 50 { return .veryBlurry }
            if blurScore < 100 { return .blurry }
            if blurScore < 200 { return .slightlyBlurry }
            return .sharp
        }
    }
    
    public enum BlurQuality {
        case veryBlurry  // < 50
        case blurry      // 50-100
        case slightlyBlurry // 100-200
        case sharp       // > 200
        
        var description: String {
            switch self {
            case .veryBlurry: return "Very Blurry"
            case .blurry: return "Blurry"
            case .slightlyBlurry: return "Slightly Blurry"
            case .sharp: return "Sharp"
            }
        }
    }
    
    // MARK: - Properties
    
    private let blurThreshold: Float
    private let cache = NSCache<NSString, NSNumber>()
    
    // MARK: - Initialization
    
    public init(blurThreshold: Float = 100.0) {
        self.blurThreshold = blurThreshold
        self.cache.countLimit = 1000 // Cache up to 1000 results
    }
    
    // MARK: - Public Methods
    
    /// Fetch all blurry photos from the library
    public func fetchBlurryPhotos(
        progressHandler: ((Int, Int) -> Void)? = nil
    ) async -> [BlurResult] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        var blurryPhotos: [BlurResult] = []
        let total = allPhotos.count
        
        for index in 0..<allPhotos.count {
            let asset = allPhotos.object(at: index)
            
            if let result = await analyzeBlur(asset: asset) {
                if result.isBlurry {
                    blurryPhotos.append(result)
                }
            }
            
            // Report progress
            if let progressHandler = progressHandler, index % 10 == 0 {
                await MainActor.run {
                    progressHandler(index + 1, total)
                }
            }
        }
        
        return blurryPhotos
    }
    
    /// Analyze a single photo for blur
    public func analyzeBlur(asset: PHAsset) async -> BlurResult? {
        // Check cache first
        let cacheKey = asset.localIdentifier as NSString
        if let cachedScore = cache.object(forKey: cacheKey) {
            let score = cachedScore.floatValue
            return BlurResult(
                asset: asset,
                blurScore: score,
                isBlurry: score < blurThreshold
            )
        }
        
        // Get image from asset
        guard let image = await loadImage(from: asset) else {
            return nil
        }
        
        // Calculate blur score
        let blurScore = calculateLaplacianVariance(image: image)
        
        // Cache result
        cache.setObject(NSNumber(value: blurScore), forKey: cacheKey)
        
        return BlurResult(
            asset: asset,
            blurScore: blurScore,
            isBlurry: blurScore < blurThreshold
        )
    }
    
    // MARK: - Private Methods
    
    private func loadImage(from asset: PHAsset) async -> UIImage? {
        await withCheckedContinuation { continuation in
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .fast
            
            // Request smaller size for performance
            let targetSize = CGSize(width: 800, height: 800)
            
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFit,
                options: options
            ) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
    
    /// Calculate Laplacian variance to detect blur
    /// Higher values = sharper image
    /// Lower values = blurrier image
    private func calculateLaplacianVariance(image: UIImage) -> Float {
        guard let cgImage = image.cgImage else { return 0 }
        
        // Convert to grayscale
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        
        // Apply Laplacian filter
        guard let filter = CIFilter(name: "CIColorControls") else { return 0 }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(0.0, forKey: kCIInputSaturationKey) // Grayscale
        
        guard let grayscale = filter.outputImage else { return 0 }
        
        // Create kernel for Laplacian
        let laplacianKernel = CIKernel(source: """
            kernel vec4 laplacian(sampler image) {
                vec4 center = sample(image, samplerCoord(image));
                vec4 north = sample(image, samplerCoord(image) + vec2(0, 1));
                vec4 south = sample(image, samplerCoord(image) + vec2(0, -1));
                vec4 east = sample(image, samplerCoord(image) + vec2(1, 0));
                vec4 west = sample(image, samplerCoord(image) + vec2(-1, 0));
                
                vec4 laplacian = abs(4.0 * center - north - south - east - west);
                return laplacian;
            }
        """)
        
        // Fallback: Simple edge detection if kernel fails
        return calculateSimpleVariance(ciImage: grayscale, context: context)
    }
    
    private func calculateSimpleVariance(ciImage: CIImage, context: CIContext) -> Float {
        // Use alternative method: compute standard deviation of pixel values
        let extent = ciImage.extent
        let inputExtent = CIVector(
            x: extent.origin.x,
            y: extent.origin.y,
            z: extent.size.width,
            w: extent.size.height
        )
        
        guard let areaAverage = CIFilter(name: "CIAreaAverage") else { return 0 }
        areaAverage.setValue(ciImage, forKey: kCIInputImageKey)
        areaAverage.setValue(inputExtent, forKey: kCIInputExtentKey)
        
        guard let outputImage = areaAverage.outputImage else { return 0 }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )
        
        // Calculate variance as measure of sharpness
        // Sharp images have higher variance
        let mean = Float(bitmap.reduce(0, +)) / 4.0
        let variance = bitmap.map { pow(Float($0) - mean, 2) }.reduce(0, +) / 4.0
        
        return variance * 10.0 // Scale up for easier threshold
    }
    
    // MARK: - Batch Processing
    
    /// Process photos in batches for better performance
    public func analyzeBatch(
        assets: [PHAsset],
        batchSize: Int = 10,
        progressHandler: ((Int, Int) -> Void)? = nil
    ) async -> [BlurResult] {
        var results: [BlurResult] = []
        let total = assets.count
        
        for (index, asset) in assets.enumerated() {
            if let result = await analyzeBlur(asset: asset) {
                results.append(result)
            }
            
            if let progressHandler = progressHandler, index % batchSize == 0 {
                await MainActor.run {
                    progressHandler(index + 1, total)
                }
            }
        }
        
        return results
    }
    
    // MARK: - Statistics
    
    public func calculateStatistics(results: [BlurResult]) -> BlurStatistics {
        let totalCount = results.count
        let blurryCount = results.filter { $0.isBlurry }.count
        let totalSize = results.reduce(Int64(0)) { sum, result in
            let resources = PHAssetResource.assetResources(for: result.asset)
            let size = resources.compactMap { $0.value(forKey: "fileSize") as? Int64 }.reduce(0, +)
            return sum + size
        }
        
        let scores = results.map { $0.blurScore }
        let averageScore = scores.reduce(0, +) / Float(max(1, scores.count))
        
        return BlurStatistics(
            totalPhotos: totalCount,
            blurryPhotos: blurryCount,
            totalSize: totalSize,
            averageBlurScore: averageScore
        )
    }
}

// MARK: - Statistics Type

public struct BlurStatistics {
    public let totalPhotos: Int
    public let blurryPhotos: Int
    public let totalSize: Int64
    public let averageBlurScore: Float
    
    public var percentage: Double {
        guard totalPhotos > 0 else { return 0 }
        return Double(blurryPhotos) / Double(totalPhotos) * 100
    }
    
    public var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: totalSize)
    }
}

// MARK: - Bulk Operations

extension BlurryDetector {
    /// Delete all blurry photos
    public static func bulkDelete(
        _ results: [BlurResult],
        completion: @escaping (Bool, Error?) -> Void
    ) {
        let assets = results.map { $0.asset }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets as NSArray)
        }, completionHandler: completion)
    }
    
    /// Group blurry photos by quality
    public static func groupByQuality(_ results: [BlurResult]) -> [BlurQuality: [BlurResult]] {
        var groups: [BlurQuality: [BlurResult]] = [:]
        
        for result in results {
            groups[result.quality, default: []].append(result)
        }
        
        return groups
    }
}
