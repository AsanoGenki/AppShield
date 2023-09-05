import Foundation
import SwiftUI
import FamilyControls
import DeviceActivity

struct MainViewFactory {
    @ObservedObject var center = AuthorizationCenter.shared
    @ObservedObject var launchManager = LaunchManager.shared
    
    @ViewBuilder
    func mainView() -> some View{
            MainView()
                .onAppear {
                    gotoRequestAuthorization()
                    ScreenLockManager.update()
                }
                .onReceive(launchManager.$updateAuthority) { bool in
                    gotoRequestAuthorization()
                }
                .onReceive(center.$authorizationStatus) { status in
                    launchManager.showAuthority = status == .approved
                }
    }
    
    func gotoRequestAuthorization() {
        Task {
            do {
                try await center.requestAuthorization(for: .individual)
            } catch {
                launchManager.showAuthority = false
            }
        }
    }
}
