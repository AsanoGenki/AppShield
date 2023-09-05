import DeviceActivity
import ManagedSettings
import Foundation
import UserNotifications
import SwiftUI
import FamilyControls

class DeviceActivityMonitorExtension: DeviceActivityMonitor, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        print("beginRequest with: \(context)")
        self.context = context
    }
    
    @AppStorage("shieldedApps", store: UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")) var shieldedApps = FamilyActivitySelection()
    @AppStorage("locationName", store: UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")) var locationName = ""

    let userDefaults = UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")
    
    let store = ManagedSettingsStore()
    var context: NSExtensionContext?
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        let strictMode = userDefaults?.bool(forKey: "testKey")
        if strictMode == true {
            let store = ManagedSettingsStore()
            store.application.denyAppRemoval = true
            StrictAppStorage().toTrue()
        }else {
            let strictGroupName = userDefaults?.string(forKey: "strictGroupName")
            let LName = userDefaults?.string(forKey: "testKey")
            userDefaults?.set(true, forKey: strictGroupName!)
            uuid().changeUUID()
            ManagedSettingsStore(named: ManagedSettingsStore.Name(LName!)).clearAllSettings()
            
            ManagedSettingsStore(named: ManagedSettingsStore.Name(LName!)).shield.applications = shieldedApps.applicationTokens
        }
        
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        var strictMode = userDefaults?.bool(forKey: "testKey")
        let LName = userDefaults?.string(forKey: "testKey")
        let strictGroupName = userDefaults?.string(forKey: "strictGroupName")
        if strictMode == true {
            let store = ManagedSettingsStore()
            store.application.denyAppRemoval = false
            @AppStorage("timer", store: UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")) var timerBool = false
            StrictAppStorage().toFalse()
            strictMode = false
        }else {
            ManagedSettingsStore(named: ManagedSettingsStore.Name(LName!)).clearAllSettings()
            @AppStorage(strictGroupName!, store: UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")) var strictMode2 = false
            let strictGroupName = userDefaults?.string(forKey: "strictGroupName")
            userDefaults?.set(false, forKey: strictGroupName!)
            uuid().changeUUID()
        }
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        print("intervalDidStart")

        let content = UNMutableNotificationContent()
        content.title = "Time's Up!"
        content.subtitle = "Answer questions to get more time."
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        let notificationName = CFNotificationName("com.example.timeout.eventDidReachThreshold" as CFString)
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        CFNotificationCenterPostNotification(notificationCenter, notificationName, nil, nil, true)

        if let context = context,
            let url = URL(string: "timeout://event-did-reach-threshold") {
            context.open(url, completionHandler: nil)
        }
        let strictMode = userDefaults?.bool(forKey: "testKey")
        if strictMode == true {
            let store = ManagedSettingsStore()
            store.application.denyAppRemoval = true
            StrictAppStorage().toTrue()
        }else {
            let strictGroupName = userDefaults?.string(forKey: "strictGroupName")
            let LName = userDefaults?.string(forKey: "testKey")
            userDefaults?.set(true, forKey: strictGroupName!)
            uuid().changeUUID()
            ManagedSettingsStore(named: ManagedSettingsStore.Name(LName!)).clearAllSettings()
            
            ManagedSettingsStore(named: ManagedSettingsStore.Name(LName!)).shield.applications = shieldedApps.applicationTokens
        }

        
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        let notificationName = CFNotificationName("com.example.timeout.eventWillReachThresholdWarning" as CFString)
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        CFNotificationCenterPostNotification(notificationCenter, notificationName, nil, nil, true)
        
        if let context = context,
            let url = URL(string: "timeout://event-will-reach-threshold") {
            context.open(url, completionHandler: nil)
        }
    }
}


