import Foundation
import Photos

class ScreenshotManager {
    static let shared = ScreenshotManager()
    
    func fetchScreenshots() -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        // Filter for screenshots subtype
        fetchOptions.predicate = NSPredicate(format: "mediaSubtype == %d", PHAssetMediaSubtype.photoScreenshot.rawValue)
        let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        var assets: [PHAsset] = []
        result.enumerateObjects { (asset, _, _) in
            assets.append(asset)
        }
        return assets
    }
}
