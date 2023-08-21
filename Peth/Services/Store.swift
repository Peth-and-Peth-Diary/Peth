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
    
    func listenForTransactions() -> Task < Void, Error > {
     // 1:
     return Task.detached {
       // 2:
       for await result in Transaction.updates {
         switch result {
           // 3:
           case let.verified(transaction):
             // 4:
             guard
             let product = self.products.first(where: {
               $0.id == transaction.productID
             })
             else {
               continue
             }
             self.purchasedNonConsumables.insert(product)
             // 5:
             await transaction.finish()
           default:
             continue
         }
       }
     }
   }
}
