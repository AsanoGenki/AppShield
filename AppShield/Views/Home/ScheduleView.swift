import SwiftUI
import ManagedSettings
import AlertToast

struct ScheduleView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @ObservedObject var manager: ScreenLockManager = ScreenLockManager.manager
    @AppStorage("timer") var timerBool = false
    @State private var showToast = false
    let userDefaults = UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")
    var body: some View{
        if (manager.dataSource.count == 0) {
            VStack (spacing: 10){
                ZStack {
                    Circle()
                        .foregroundColor(.blue)
                        .frame(width: 90, height: 90)
                    Image(systemName: "tray.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 38))
                    
                }
                Text("Add First Schedule")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        } else{
            Form {
                ForEach(manager.dataSource.indexed(),id: \.index) { Index,item in
                    ZStack (alignment: .topTrailing){
                        ZStack {
                            if Index >= 1 &&  !purchaseManager.hasUnlockedPro {
                                ScheduleCardView(group: item)
                                    .disabled(true)
                            } else {
                                ScheduleCardView(group: item)
                            }
                            
                            
                            if Index >= 1 &&  !purchaseManager.hasUnlockedPro {
                                HStack{
                                    Image(systemName: "lock.fill")
                                    Text("Pro")
                                }
                                .foregroundColor(.blue)
                                .padding()
                                .padding(.horizontal, 30)
                                .background(.regularMaterial)
                                .cornerRadius(10)
                                
                            }
                        }
                        if userDefaults?.bool(forKey: item.name) as Any as! Bool == false {
                            Menu {
                                Button(role: .destructive,action: {
                                    withAnimation(.default) {
                                        if timerBool == false {
                                            ScreenLockManager.delete(id:item.id)
                                            ManagedSettingsStore(named: ManagedSettingsStore.Name(item.name)).clearAllSettings()
                                        } else {
                                            self.showToast.toggle()
                                        }
                                    }
                                }) {
                                    Image(systemName: "trash")
                                    Text("Delete")
                                }.animation(.easeInOut(duration: 1.0), value: false)
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color(.black))
                                    .padding(5)
                            }.onTapGesture {
                                
                            }
                        }
                    }
                    
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16)
                            .background(.clear)
                            .foregroundColor(.white)
                            .overlay(
                                userDefaults?.bool(forKey: item.name) as Any as! Bool ?
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.blue, lineWidth: 3) : RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white, lineWidth: 3)
                            )
                            .padding(
                                EdgeInsets(
                                    top: 10,
                                    leading: 3,
                                    bottom: 10,
                                    trailing: 3
                                )
                            )
                    )
                    .listRowSeparator(.hidden)
                    
                }
                .environment(\.defaultMinListRowHeight, 160)
            }
            .environment(\.defaultMinListRowHeight, 130)
            .toast(isPresenting: $showToast){
                AlertToast(displayMode: .banner(.slide), type: .systemImage("lock.shield", .blue), title: "Strict Mode")
            }
            
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
