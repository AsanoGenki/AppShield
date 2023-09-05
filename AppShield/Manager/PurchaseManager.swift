import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {

    private let productIds = ["unPlug.Subscription.month"]
    

    @Published
    private(set) var products: [Product] = []
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    init() {
            updates = observeTransactionUpdates()
        }
    deinit {
            updates?.cancel()
        }

    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }

    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
        case let .success(.unverified(_, error)):
            break
        case .pending:
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }
    
    @Published
        private(set) var purchasedProductIDs = Set<String>()

        var hasUnlockedPro: Bool {
           return !self.purchasedProductIDs.isEmpty
        }

        func updatePurchasedProducts() async {
            for await result in Transaction.currentEntitlements {
                guard case .verified(let transaction) = result else {
                    continue
                }

                if transaction.revocationDate == nil {
                    self.purchasedProductIDs.insert(transaction.productID)
                } else {
                    self.purchasedProductIDs.remove(transaction.productID)
                }
            }
        }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
            Task(priority: .background) { [unowned self] in
                for await verificationResult in Transaction.updates {
                    await self.updatePurchasedProducts()
                }
            }
        }
    
}

