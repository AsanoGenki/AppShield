import UIKit
import BackgroundTasks
import SwiftUI

class AppDelegate:NSObject,UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.hiddenApps.refresh", using: DispatchQueue.main) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
                
        return true
    }

    func application(_ application: UIApplication,  configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self 
        return sceneConfig
    }
    
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BGAppRefreshTool.scheduleAppRefresh()
    }
    

    
    func handleAppRefresh(task: BGAppRefreshTask) {
        BGAppRefreshTool.scheduleAppRefresh()
        
        LocationManager.save("テスト", key: "test")
    }
}

