import SwiftUI
import ManagedSettings

struct SelectLevelView: View {
    @Binding var level: Int
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @State var showPremium = false
    var body: some View {
        VStack {
            HStack{
                Text("Strictness")
                    .font(.title2)
                    .bold()
                Spacer()
            }.padding(.leading, 15)
            
            HStack{
                Image("emoji01_green")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.leading, 20)
                VStack(alignment: .leading, spacing: 5){
                    Text("Level 1")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.green)
                        .padding(.top, 10)
                    Text("You can't edit / stop existing blockings.")
                        .font(.subheadline)
                        .padding(.bottom, 10)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("Gray"))
            .cornerRadius(14)
            .padding(.horizontal, 15)
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture {
                level = 0
                dismiss()
            }
            HStack{
                Image("emoji02_orange")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.leading, 20)
                VStack(alignment: .leading, spacing: 5){
                    Text("Level 2")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.orange)
                        .padding(.top, 10)
                    Text("You can't edit / stop existing blockings.\nunPlug cannot be uninstalled.")
                        .font(.subheadline)
                        .padding(.bottom, 10)
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("Gray"))
            .cornerRadius(14)
            .padding(.horizontal, 15)
            .padding(.top,10)
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture {
                if !purchaseManager.hasUnlockedPro {
                    showPremium = true
                } else {
                    level = 1
                    dismiss()
                }

            }.fullScreenCover(isPresented: $showPremium) {
                PremiumView()
            }
        }
    }
}

struct SelectLevelView_Previews: PreviewProvider {
    @State static var level: Int = 0
    static var previews: some View {
        SelectLevelView(level: $level)
    }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
