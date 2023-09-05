import UIKit
import BackgroundTasks
class BGAppRefreshTool: NSObject {
    static func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.hiddenApps.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}
