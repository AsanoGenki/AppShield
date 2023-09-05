import SwiftUI

struct PurchaseButtonView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    var body: some View {
        VStack{
            if purchaseManager.hasUnlockedPro {
                Text("Purchased")
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: 300, minHeight: 60)
                    .padding(.horizontal, 30)
                    .accentColor(Color.white)
                    .background(Color.gray)
                    .cornerRadius(100)
                
            } else {
                ForEach(purchaseManager.products.indexed(),id: \.index) { Index,product in
                    
                    Button {
                        Task {
                            do {
                                try await purchaseManager.purchase(product)
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Try Free")
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: 300, minHeight: 60)
                            .padding(.horizontal, 30)
                            .accentColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(100)
                    }
                    Text("7 days free, then \(product.displayPrice) /month")
                }
            }
        }.task {
            Task {
                do {
                    try await purchaseManager.loadProducts()
                } catch {
                    print(error)
                }
            }
        }
        
        .padding(.top, 20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

struct PurchaseButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseButtonView()
    }
}
