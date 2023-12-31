import ManagedSettings
import UIKit
import WebKit

class ShieldActionExtension: ShieldActionDelegate, NSExtensionRequestHandling {
    
    var context: NSExtensionContext?
    
    override func handle(action: ShieldAction,
                         for application: ApplicationToken,
                         completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            print("primaryButtonPressed")
            
            let notificationName = CFNotificationName("com.example.timeout.primaryButtonPressed" as CFString)
            let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
            CFNotificationCenterPostNotification(notificationCenter, notificationName, nil, nil, true)
            
            if let context = context,
                let url = URL(string: "timeout://primary-button") {
                context.open(url, completionHandler: nil)
            }
            completionHandler(.close)
        case .secondaryButtonPressed:
            print("secondaryButtonPressed")
            completionHandler(.close)
        @unknown default:
            fatalError()
        }
    }
    
    func beginRequest(with context: NSExtensionContext) {
        print("beginRequest with: \(context)")
        self.context = context
    }
}

