import Foundation

struct EmailAccount {
    let email: String
    let provider: String
}

class EmailManager {
    func scanJunk(in account: EmailAccount) async -> Int {
        // Mock scan logic for demo
        return Int.random(in: 100...2000)
    }
}
