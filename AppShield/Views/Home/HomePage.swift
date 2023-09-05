import SwiftUI
import ManagedSettings
import AlertToast

struct HomePage: View {
    @ObservedObject var manager: ScreenLockManager = ScreenLockManager.manager
    @State var showingSetting = false
    @AppStorage("uuid", store: UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")) var uuid = "uuid"
    
    var body: some View {
        NavigationView {
            ZStack{
                ScheduleView(manager: manager)
                FloatingButton()
                Text(uuid)
                    .frame(width: 0, height: 0)
            }
            .navigationTitle("Schedule" )
            .navigationBarItems(leading: Button(action: {
                showingSetting = true
            }) {
                Image(systemName: "gearshape")
            }
            )
            
        }
        .sheet(isPresented: $showingSetting) {
            SettingView()
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        
        HomePage()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
        
        HomePage()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
    }
}



