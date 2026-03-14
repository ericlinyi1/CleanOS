import Foundation
import Vision

struct PhotoEmbedding {
    let id: String
    let vector: [Float]
}

class SimilarityEngine {
    func cosineSimilarity(v1: [Float], v2: [Float]) -> Float {
        guard v1.count == v2.count else { return 0 }
        let dotProduct = zip(v1, v2).map(*).reduce(0, +)
        let mag1 = sqrt(v1.map { $0 * $0 }.reduce(0, +))
        let mag2 = sqrt(v2.map { $0 * $0 }.reduce(0, +))
        return dotProduct / (mag1 * mag2)
    }
    
    func cluster(embeddings: [PhotoEmbedding], threshold: Float = 0.9) -> [[String]] {
        var clusters: [[String]] = []
        var visited = Set<String>()
        
        for i in 0..<embeddings.count {
            if visited.contains(embeddings[i].id) { continue }
            var currentCluster = [embeddings[i].id]
            visited.insert(embeddings[i].id)
            
            for j in (i+1)..<embeddings.count {
                if visited.contains(embeddings[j].id) { continue }
                if cosineSimilarity(v1: embeddings[i].vector, v2: embeddings[j].vector) >= threshold {
                    currentCluster.append(embeddings[j].id)
                    visited.insert(embeddings[j].id)
                }
            }
            if currentCluster.count > 1 { clusters.append(currentCluster) }
        }
        return clusters
    }
}
