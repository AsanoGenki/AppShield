import SwiftUI
import StoreKit
import Purchases

struct PremiumView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var purchaseManager: PurchaseManager
    var body: some View {
            ZStack(alignment: .topTrailing){
                ZStack (alignment: .bottom){
                    ScrollView{
                        VStack{
                            ZStack(alignment: .topTrailing){
                                PremiumImageView()
                                
                            }.padding(.bottom, 40)
                            
                            PremiumDescriptionView()
                            
                            TermOfUseView()
                            
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 200, height: 180)
                            Spacer()
                        }
                    }.ignoresSafeArea()
                    PurchaseButtonView()
                    
                }
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .foregroundColor(Color.gray.opacity(0.5))
                            .frame(width: 27, height: 27)
                    )
                    .padding(.trailing, 30)
                    .padding(.top, 25)
                    .onTapGesture{
                        dismiss()
                    }
            }
        }
    
}
struct PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumView()
    }
}
