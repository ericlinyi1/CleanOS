import Foundation

struct EmailCleanupStats {
    let junkCount: Int
    let largeAttachmentsSize: Int64
}

class EmailManager {
    static let shared = EmailManager()
    
    func scanForCleanup() async -> EmailCleanupStats {
        // Real-world: Connect to IMAP/Gmail API
        // For project scope: Mock intelligent scan result
        return EmailCleanupStats(junkCount: 1240, largeAttachmentsSize: 3500 * 1024 * 1024)
    }
}
