import SwiftUI
import StoreKit

struct PremiumPaywallView: View {
    @StateObject private var premiumManager = PremiumManager()
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedProduct: Product?
    @State private var showingError = false
    @State private var isPurchasing = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    headerSection
                    
                    // Features
                    featuresSection
                    
                    // Pricing
                    if !premiumManager.products.isEmpty {
                        pricingSection
                    }
                    
                    // Restore
                    restoreButton
                    
                    // Footer
                    footerSection
                }
                .padding(.top, 40)
                .padding(.horizontal)
            }
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                Spacer()
            }
            
            // Loading overlay
            if isPurchasing {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                    Text("Processing...")
                        .foregroundColor(.white)
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            if let error = premiumManager.error {
                Text(error.localizedDescription)
            }
        }
        .onChange(of: premiumManager.error) { newError in
            showingError = newError != nil
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .blur(radius: 30)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            
            Text("Upgrade to Premium")
                .font(.system(size: 32, weight: .black))
                .foregroundColor(.white)
            
            Text("Unlimited cleanups & advanced features")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Features Section
    
    private var featuresSection: some View {
        VStack(spacing: 16) {
            FeatureRow(
                icon: "infinity",
                title: "Unlimited Cleanups",
                description: "Clean your library as many times as you want"
            )
            
            FeatureRow(
                icon: "brain",
                title: "Advanced AI Detection",
                description: "Better similarity & blur detection algorithms"
            )
            
            FeatureRow(
                icon: "video.badge.checkmark",
                title: "Bulk Video Compression",
                description: "Compress multiple videos at once to save space"
            )
            
            FeatureRow(
                icon: "calendar.badge.clock",
                title: "Automatic Cleanup",
                description: "Schedule weekly automatic cleanups"
            )
            
            FeatureRow(
                icon: "icloud.and.arrow.up",
                title: "Cloud Backup",
                description: "Backup photos to iCloud before deletion"
            )
            
            FeatureRow(
                icon: "headphones",
                title: "Priority Support",
                description: "Get help faster from our support team"
            )
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
    
    // MARK: - Pricing Section
    
    private var pricingSection: some View {
        VStack(spacing: 16) {
            // Yearly (Best Value)
            if let yearly = premiumManager.products.first(where: { $0.id.contains("yearly") }) {
                VStack(spacing: 0) {
                    // Best Value Badge
                    HStack {
                        Spacer()
                        Text("🎉 BEST VALUE - \(premiumManager.savingsPercentage)% OFF")
                            .font(.caption.bold())
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(8)
                        Spacer()
                    }
                    .padding(.bottom, 16)
                    
                    ProductCard(
                        product: yearly,
                        monthlyEquivalent: premiumManager.yearlyMonthlyEquivalent,
                        isSelected: selectedProduct?.id == yearly.id,
                        isRecommended: true
                    ) {
                        selectedProduct = yearly
                    }
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.2), Color.pink.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
            }
            
            // Monthly
            if let monthly = premiumManager.products.first(where: { $0.id.contains("monthly") }) {
                ProductCard(
                    product: monthly,
                    isSelected: selectedProduct?.id == monthly.id,
                    isRecommended: false
                ) {
                    selectedProduct = monthly
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(20)
            }
            
            // Purchase Button
            if let selected = selectedProduct {
                Button {
                    Task {
                        isPurchasing = true
                        let success = await premiumManager.purchase(selected)
                        isPurchasing = false
                        if success {
                            dismiss()
                        }
                    }
                } label: {
                    HStack {
                        Text("Start Free Trial")
                            .font(.headline)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.white, .gray.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(16)
                }
                .disabled(isPurchasing)
            }
        }
    }
    
    // MARK: - Restore Button
    
    private var restoreButton: some View {
        Button {
            Task {
                await premiumManager.restorePurchases()
                if premiumManager.isPremium {
                    dismiss()
                }
            }
        } label: {
            Text("Restore Purchase")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    // MARK: - Footer Section
    
    private var footerSection: some View {
        VStack(spacing: 8) {
            Text("7-day free trial • Cancel anytime")
                .font(.caption)
                .foregroundColor(.gray)
            
            Text("No commitment required")
                .font(.caption2)
                .foregroundColor(.gray.opacity(0.7))
            
            HStack(spacing: 16) {
                Button("Terms") {}
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Text("•")
                    .foregroundColor(.gray)
                
                Button("Privacy") {}
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(.top, 8)
        }
        .padding(.bottom, 40)
    }
}

// MARK: - Supporting Views

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
}

struct ProductCard: View {
    let product: Product
    var monthlyEquivalent: String?
    let isSelected: Bool
    let isRecommended: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.displayName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if let monthly = monthlyEquivalent {
                        Text("\(monthly)/month")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text("Billed \(product.subscription?.subscriptionPeriod.unit == .year ? "yearly" : "monthly")")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(product.displayPrice)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)
                            .font(.title3)
                    }
                }
            }
        }
    }
}

// MARK: - Free Tier Limit View

struct FreeTierLimitView: View {
    @StateObject private var premiumManager = PremiumManager()
    @State private var showingPaywall = false
    
    let daysUntilReset: Int
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                VStack(spacing: 16) {
                    Text("Free Limit Reached")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text("You've used \(premiumManager.cleanupsThisMonth)/3 cleanups this month.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Text("Resets in \(daysUntilReset) days")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text("or")
                    .foregroundColor(.gray)
                
                VStack(spacing: 16) {
                    Text("💎 Upgrade to Premium")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                            Text("Unlimited cleanups")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                            Text("Advanced features")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                            Text("No waiting")
                                .foregroundColor(.gray)
                        }
                    }
                    .font(.subheadline)
                    
                    Button {
                        showingPaywall = true
                    } label: {
                        Text("Start Free Trial")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(20)
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingPaywall) {
            PremiumPaywallView()
        }
    }
}

#Preview("Paywall") {
    PremiumPaywallView()
}

#Preview("Free Limit") {
    FreeTierLimitView(daysUntilReset: 18)
}
