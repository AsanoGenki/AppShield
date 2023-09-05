import SwiftUI

struct FloatingButton: View {
    @ObservedObject var manager: ScreenLockManager = ScreenLockManager.manager
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @State private var showingModal = false
    @State var showPremium = false
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if manager.dataSource.count < 1 || purchaseManager.hasUnlockedPro {
                        self.showingModal.toggle()
                    } else {
                        showPremium = true
                    }
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: 24)) 
                })
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .cornerRadius(30.0)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
                .sheet(isPresented: $showingModal) {
                    NewScheduleView(group: AppGroup(name: "appGroup1", open: true, count: 0, creatTime: Date().timeIntervalSince1970 + 4, title: "Title", week: [""], time:[AppGroup.Time(s: "00:00", e: "01:00")], icon: "", iconRGB: [0,0,0]))
                }
                .fullScreenCover(isPresented: $showPremium) {
                    PremiumView()
                }
            }
        }
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton()
    }
}
