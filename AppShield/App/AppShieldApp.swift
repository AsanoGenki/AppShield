import SwiftUI
import FamilyControls
import DeviceActivity
import Purchases

@main
struct AppShieldApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    @ObservedObject var center = AuthorizationCenter.shared
    @ObservedObject var launchManager = LaunchManager.shared
    @StateObject private var purchaseManager = PurchaseManager()
    var factory = MainViewFactory()
    init(){
            Purchases.logLevel = .debug
            Purchases.configure(withAPIKey: "appl_AlfILITxKozbYjIakQlpmyqSznk")
        
        }
    var body: some Scene {
        WindowGroup {
            
            self.factory.mainView()
                .environmentObject(center)
                .environmentObject(launchManager)
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
                .onAppear {
                    
                  UINavigationController().navigationBar.backItem?.title = "Back"
                }
                .environment(\.locale, .init(identifier: "en_US"))
                        
        }
        
    }
}
