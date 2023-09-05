import UIKit
import BackgroundTasks

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func sceneWillEnterForeground(_ scene: UIScene) {
        LaunchManager.shared.updateAuthority = true;
    }
    
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        BGTaskScheduler.shared.cancelAllTaskRequests()
        BGAppRefreshTool.scheduleAppRefresh()
    }
}
