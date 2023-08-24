//
//  Store.swift
//  Peth
//
//  Created by masbek mbp-m2 on 21/08/23.
//

import Foundation
// 1:
import StoreKit
// 2:
class Store: ObservableObject {
    // 3:
    private var productIDs = ["UnlimitedWords"]
    // 4:
    @Published var products = [Product]()
    
    @Published var purchasedNonConsumables = Set<Product>()
    
    var transacitonListener: Task<Void, Error>?
    
    init() {
        transacitonListener = listenForTransactions()
        Task {
            await requestProducts()
            // Must be called after the products are already fetched
            await updateCurrentEntitlements()
        }
    }
    
    // 6:
    @MainActor
    func requestProducts() async {
        do {
            // 7:
            products = try await Product.products(for: productIDs)
        } catch {
            // 8:
            print(error)
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async throws -> Transaction? {
        // 1:
        let result =
        try await product.purchase()
        switch result {
            // 2:
        case .success(.verified(let transaction)):
            // 3:
            purchasedNonConsumables.insert(product)
            // 4:
            await transaction.finish()
            return transaction
        default:
            return nil
        }
    }
    
    @MainActor
    private func handle(transactionVerification result: VerificationResult <Transaction> ) async {
        switch result {
        case let.verified(transaction):
            guard
                let product = self.products.first(where: {
                    $0.id == transaction.productID
                })
            else {
                return
            }
            self.purchasedNonConsumables.insert(product)
            await transaction.finish()
        default:
            return
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                await self.handle(transactionVerification: result)
            }
        }
    }
    
    private func updateCurrentEntitlements() async {
        for await result in Transaction.currentEntitlements {
            await self.handle(transactionVerification: result)
        }
    }
}
