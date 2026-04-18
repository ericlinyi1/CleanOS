import Foundation
import StoreKit

/// Manages in-app purchases and premium features
@MainActor
class PremiumManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isPremium = false
    @Published var subscriptionStatus: SubscriptionStatus = .free
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: PremiumError?
    
    // Usage tracking for free tier
    @Published var cleanupsThisMonth = 0
    @Published var canUseCleanup = true
    
    // MARK: - Constants
    
    private let monthlyProductID = "com.cleanOS.premium.monthly"
    private let yearlyProductID = "com.cleanOS.premium.yearly"
    private let freeCleanupLimit = 3
    
    // UserDefaults keys
    private let lastResetDateKey = "lastMonthlyReset"
    private let cleanupsCountKey = "cleanupsThisMonth"
    private let premiumStatusKey = "isPremiumUser"
    
    // MARK: - Initialization
    
    init() {
        checkPremiumStatus()
        resetMonthlyCountIfNeeded()
        
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    // MARK: - Product Loading
    
    func loadProducts() async {
        isLoading = true
        
        do {
            products = try await Product.products(for: [monthlyProductID, yearlyProductID])
            
            // Sort: yearly first (best value)
            products.sort { product1, product2 in
                if product1.id == yearlyProductID { return true }
                if product2.id == yearlyProductID { return false }
                return product1.price < product2.price
            }
            
        } catch {
            self.error = .loadProductsFailed(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Purchase
    
    func purchase(_ product: Product) async -> Bool {
        isLoading = true
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    // Grant premium access
                    await transaction.finish()
                    await updateSubscriptionStatus()
                    isLoading = false
                    return true
                    
                case .unverified(_, let error):
                    self.error = .verificationFailed(error)
                    isLoading = false
                    return false
                }
                
            case .pending:
                // Purchase is pending (e.g., Ask to Buy)
                self.error = .purchasePending
                isLoading = false
                return false
                
            case .userCancelled:
                isLoading = false
                return false
                
            @unknown default:
                isLoading = false
                return false
            }
            
        } catch {
            self.error = .purchaseFailed(error)
            isLoading = false
            return false
        }
    }
    
    // MARK: - Restore Purchases
    
    func restorePurchases() async {
        isLoading = true
        
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
            isLoading = false
        } catch {
            self.error = .restoreFailed(error)
            isLoading = false
        }
    }
    
    // MARK: - Subscription Status
    
    func updateSubscriptionStatus() async {
        // Check for active subscriptions
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if transaction.productID == monthlyProductID || transaction.productID == yearlyProductID {
                    if !transaction.isUpgraded {
                        isPremium = true
                        subscriptionStatus = transaction.productID == yearlyProductID ? .yearlyPremium : .monthlyPremium
                        savePremiumStatus(true)
                        return
                    }
                }
                
            case .unverified:
                continue
            }
        }
        
        // No active subscription found
        isPremium = false
        subscriptionStatus = .free
        savePremiumStatus(false)
    }
    
    // MARK: - Usage Tracking
    
    func recordCleanup() {
        guard !isPremium else { return }
        
        cleanupsThisMonth += 1
        UserDefaults.standard.set(cleanupsThisMonth, forKey: cleanupsCountKey)
        
        if cleanupsThisMonth >= freeCleanupLimit {
            canUseCleanup = false
        }
    }
    
    func checkCanCleanup() -> Bool {
        if isPremium {
            return true
        }
        
        return cleanupsThisMonth < freeCleanupLimit
    }
    
    private func resetMonthlyCountIfNeeded() {
        let calendar = Calendar.current
        let now = Date()
        
        if let lastReset = UserDefaults.standard.object(forKey: lastResetDateKey) as? Date {
            // Check if we're in a new month
            if !calendar.isDate(now, equalTo: lastReset, toGranularity: .month) {
                resetMonthlyCount()
            }
        } else {
            // First launch
            UserDefaults.standard.set(now, forKey: lastResetDateKey)
        }
        
        cleanupsThisMonth = UserDefaults.standard.integer(forKey: cleanupsCountKey)
        canUseCleanup = cleanupsThisMonth < freeCleanupLimit
    }
    
    private func resetMonthlyCount() {
        cleanupsThisMonth = 0
        canUseCleanup = true
        UserDefaults.standard.set(0, forKey: cleanupsCountKey)
        UserDefaults.standard.set(Date(), forKey: lastResetDateKey)
    }
    
    // MARK: - Persistence
    
    private func checkPremiumStatus() {
        isPremium = UserDefaults.standard.bool(forKey: premiumStatusKey)
    }
    
    private func savePremiumStatus(_ status: Bool) {
        UserDefaults.standard.set(status, forKey: premiumStatusKey)
    }
    
    // MARK: - Feature Gating
    
    func canAccessFeature(_ feature: PremiumFeature) -> Bool {
        switch feature {
        case .unlimitedCleanups:
            return isPremium || checkCanCleanup()
        case .advancedSimilarity, .bulkVideoCompression, .autoCleanup, .cloudBackup:
            return isPremium
        }
    }
    
    // MARK: - Pricing Info
    
    var monthlyPrice: String {
        products.first { $0.id == monthlyProductID }?.displayPrice ?? "$4.99"
    }
    
    var yearlyPrice: String {
        products.first { $0.id == yearlyProductID }?.displayPrice ?? "$29.99"
    }
    
    var yearlyMonthlyEquivalent: String {
        guard let yearly = products.first(where: { $0.id == yearlyProductID }) else {
            return "$2.49"
        }
        
        let monthlyPrice = yearly.price / 12
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = yearly.priceFormatStyle.currencyCode
        return formatter.string(from: NSNumber(value: monthlyPrice.doubleValue)) ?? "$2.49"
    }
    
    var savingsPercentage: Int {
        guard let monthly = products.first(where: { $0.id == monthlyProductID }),
              let yearly = products.first(where: { $0.id == yearlyProductID }) else {
            return 40
        }
        
        let yearlyMonthly = yearly.price / 12
        let savings = (monthly.price - yearlyMonthly) / monthly.price
        return Int(savings.doubleValue * 100)
    }
}

// MARK: - Supporting Types

enum SubscriptionStatus {
    case free
    case monthlyPremium
    case yearlyPremium
    
    var displayName: String {
        switch self {
        case .free: return "Free"
        case .monthlyPremium: return "Premium (Monthly)"
        case .yearlyPremium: return "Premium (Yearly)"
        }
    }
}

enum PremiumFeature {
    case unlimitedCleanups
    case advancedSimilarity
    case bulkVideoCompression
    case autoCleanup
    case cloudBackup
    
    var displayName: String {
        switch self {
        case .unlimitedCleanups: return "Unlimited Cleanups"
        case .advancedSimilarity: return "Advanced AI Detection"
        case .bulkVideoCompression: return "Bulk Video Compression"
        case .autoCleanup: return "Automatic Weekly Cleanup"
        case .cloudBackup: return "Cloud Backup Before Delete"
        }
    }
    
    var icon: String {
        switch self {
        case .unlimitedCleanups: return "infinity"
        case .advancedSimilarity: return "brain"
        case .bulkVideoCompression: return "video.badge.checkmark"
        case .autoCleanup: return "calendar.badge.clock"
        case .cloudBackup: return "icloud.and.arrow.up"
        }
    }
}

enum PremiumError: LocalizedError {
    case loadProductsFailed(Error)
    case purchaseFailed(Error)
    case verificationFailed(VerificationResult<Transaction>.VerificationError)
    case purchasePending
    case restoreFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .loadProductsFailed(let error):
            return "Failed to load products: \(error.localizedDescription)"
        case .purchaseFailed(let error):
            return "Purchase failed: \(error.localizedDescription)"
        case .verificationFailed(let error):
            return "Verification failed: \(error.localizedDescription)"
        case .purchasePending:
            return "Purchase is pending approval"
        case .restoreFailed(let error):
            return "Restore failed: \(error.localizedDescription)"
        }
    }
}
