import Foundation
import CryptoKit

struct PhotoAsset: Identifiable {
    let id: String
    let data: Data
    let size: Int64
}

class PhotoProcessor {
    func findExactDuplicates(assets: [PhotoAsset]) -> [[String]] {
        var groups: [String: [String]] = [:]
        for asset in assets {
            let hash = SHA256.hash(data: asset.data).map { String(format: "%02x", $0) }.joined()
            groups[hash, default: []].append(asset.id)
        }
        return groups.values.filter { $0.count > 1 }
    }
}
