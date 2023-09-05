import ManagedSettings
import FamilyControls
import UIKit
import DeviceActivity
import SwiftUI
import BackgroundTasks

class AppGroup: Identifiable, ObservableObject {
    
    
    let store = ManagedSettingsStore()
    
    @Published var name: String
    @Published var count: Int = 0
    @Published var open: Bool {
        didSet {
            managedSettingsStore()
        }
    }
    struct Time: Codable, Identifiable {
        var startTime: String
        var id = UUID() 
        var endTime: String
        init(s: String, e: String) {
            startTime = s
            endTime = e
        }
    }

    var title: String
    var time: [Time]
    var week: [String]
    var icon: String
    var iconRGB: [CGFloat]
    
    
    var creatTime: TimeInterval
    var locationStoreName: String {
        name + "\(creatTime)"
    }
    var updateCount: Int {
        applicationTokens.count + webDomainTokens.count + activityCategoryTokens.count
    }
    
    func managedSettingsStore() {
        if open {
            ManagedSettingsStore(named: ManagedSettingsStore.Name(locationStoreName)).shield.webDomains = webDomainTokens
        } else {
            ManagedSettingsStore(named: ManagedSettingsStore.Name(locationStoreName)).clearAllSettings()
        }
    }
    func setShieldRestrictions() {

        ManagedSettingsStore(named: ManagedSettingsStore.Name(locationStoreName)).shield.applications = applicationTokens

        
        store.dateAndTime.requireAutomaticDateAndTime = true
    }
    func unsetShieldRestrictions() {

        ManagedSettingsStore(named: ManagedSettingsStore.Name(locationStoreName)).clearAllSettings()

        
        store.dateAndTime.requireAutomaticDateAndTime = true
    }
    
    func initiateMonitoring() {
        @AppStorage("shieldedApps", store: UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")) var shieldedApps = FamilyActivitySelection()
        @AppStorage("locationName", store: UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")) var locationName = ""
        @AppStorage(name, store: UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")) var strictMode2 = false
        
        let userDefaults = UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")
        userDefaults?.set(locationStoreName, forKey: "testKey")
        userDefaults?.set(false, forKey: "testKey")
        userDefaults?.set(name, forKey: "strictGroupName")
        userDefaults?.set(false, forKey: name) //←groupアクティブか否か
        
        userDefaults?.synchronize()
        
        shieldedApps.applicationTokens = applicationTokens
        locationName = locationStoreName
        DeviceActivityName.daily.rawValue = name
        DeviceActivityEvent.Name.encouraged.rawValue = name
        let event = DeviceActivityEvent(applications: shieldedApps.applicationTokens,
                                        categories: shieldedApps.categoryTokens,
                                        threshold: DateComponents(second: 10))
        let center = DeviceActivityCenter()
        
        print("dailyname: \(DeviceActivityName.daily.rawValue)")
        
        do {
            center.stopMonitoring([DeviceActivityName.daily])
            for weeks in week {
                for times in time {
                    
                    if times.startTime.prefix(2) <= times.endTime.prefix(2) {
                        let schedule = DeviceActivitySchedule(
                            intervalStart: DateComponents(hour: Int(times.startTime.prefix(2)), minute: Int(times.startTime.suffix(2)), weekday: DateFormatter().weekdaySymbols.firstIndex(of: weeks)! + 1),
                            intervalEnd: DateComponents(hour: Int(times.endTime.prefix(2)), minute: Int(times.endTime.suffix(2)),weekday: DateFormatter().weekdaySymbols.firstIndex(of: weeks)! + 1),
                            
                            repeats: true
                        )
                        
                        try center.startMonitoring(.daily, during: schedule, events: [.encouraged : event]
                        )
                    } else {
                        let schedule = DeviceActivitySchedule(
                            intervalStart: DateComponents(hour: Int(times.startTime.prefix(2)), minute: Int(times.startTime.suffix(2)), weekday: DateFormatter().weekdaySymbols.firstIndex(of: weeks)! + 1),
                            intervalEnd: DateComponents(hour: Int(times.endTime.prefix(2)), minute: Int(times.endTime.suffix(2)),weekday: DateFormatter().weekdaySymbols.firstIndex(of: weeks)! + 2),
                            
                            repeats: true
                        )
                        
                        try center.startMonitoring(.daily, during: schedule, events: [.encouraged : event]
                        )
                    }
                    
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var applicationTokens: Set<ApplicationToken>
    var webDomainTokens: Set<WebDomainToken>
    var activityCategoryTokens: Set<ActivityCategoryToken>
    
    var id: TimeInterval {
        return self.creatTime
    }
    
    init(name: String,
         open: Bool,
         count: Int,
         creatTime: TimeInterval,
         applicationTokens: Set<ApplicationToken> = Set<ApplicationToken>(),
         webDomainTokens: Set<WebDomainToken> = Set<WebDomainToken>(),
         
         title: String,
         week: [String],
         time: [Time],
         icon: String,
         iconRGB: [CGFloat],
         activityCategoryTokens: Set<ActivityCategoryToken> = Set<ActivityCategoryToken>()) {
        self.name = name
        self.open = open
        self.count = count
        self.creatTime = creatTime
        self.applicationTokens = applicationTokens
        self.webDomainTokens = webDomainTokens
        self.activityCategoryTokens = activityCategoryTokens
        self.title = title
        self.time = time
        self.week = week
        self.icon = icon
        self.iconRGB = iconRGB
        managedSettingsStore()
    }
}


extension DeviceActivityName {
    
    static var daily = Self("daily")
}
extension DeviceActivityEvent.Name {
    static var encouraged = Self("encouraged")
}


extension AppGroup {
    
    struct Location: Codable {
        
        var name: String
        var open: Bool
        var creatTime: TimeInterval
        
        var title: String
        var time: [Time]
        var week: [String]
        var icon: String
        var iconRGB: [CGFloat]
        
        var applicationTokens: Set<ApplicationToken>
        var webDomainTokens: Set<WebDomainToken>
        var activityCategoryTokens: Set<ActivityCategoryToken>
        
        var count: Int {
            applicationTokens.count + webDomainTokens.count + activityCategoryTokens.count
        }
        var id: TimeInterval {
            return creatTime
        }
        
    }
    
    func toStruct() -> Location {
        Location(name: name,
                 open: open,
                 creatTime: creatTime,
                 title: title,
                 time: time,
                 week: week,
                 icon: icon,
                 iconRGB: iconRGB,
                 applicationTokens: applicationTokens,
                 webDomainTokens: webDomainTokens,
                 activityCategoryTokens: activityCategoryTokens)
    }
}



class ScreenLockManager: ObservableObject {
    static var manager = ScreenLockManager()
    
    @Published var authorization: Bool = false
    @Published var dataSource : [AppGroup] = [AppGroup]()
    
    static func update() {
        let list = LocationManager.find([AppGroup.Location].self, key: "group_key")
        LocationManager.save(list, key: "group_key")
        manager.dataSource = list?.map({
            AppGroup(name: $0.name, open: $0.open, count: $0.count,creatTime: $0.creatTime , applicationTokens: $0.applicationTokens, webDomainTokens: $0.webDomainTokens, title: $0.title, week: $0.week, time: $0.time, icon: $0.icon, iconRGB: $0.iconRGB, activityCategoryTokens: $0.activityCategoryTokens)
        }) ?? [AppGroup]()
    }
    
    static func delete(id: TimeInterval) {
        let restoreList = manager.dataSource.filter({$0.id == id})
        if restoreList.count > 0 {
            for index in 0..<restoreList.count {
                restoreList[index].open = false
            }
        }
        manager.dataSource = manager.dataSource.filter({$0.id != id})
        let list = LocationManager.find([AppGroup.Location].self, key: "group_key") ?? [AppGroup.Location]()
        let saveList = list.filter({$0.id != id})
        LocationManager.save(saveList, key: "group_key")
        ScreenLockManager.update()
    }
    
    static func save(group: AppGroup) {
        var list = LocationManager.find([AppGroup.Location].self, key: "group_key") ?? [AppGroup.Location]()
        if let index = list.firstIndex(where: {$0.id == group.id}) {
            list[index] = group.toStruct()
        } else {
            list.append(group.toStruct())
        }
        LocationManager.save(list, key: "group_key")
        ScreenLockManager.update()
    }
    static func save2(group: AppGroup) {
        var list = LocationManager.find([AppGroup.Location].self, key: "group_key") ?? [AppGroup.Location]()
        let index = list.firstIndex(where: {$0.id == group.id})
        list[index!] = group.toStruct()
        
        AppGroupData.save(list, key: "group_key")
        ScreenLockManager.update()
    }
    
    static func closeAll() {
        var list = LocationManager.find([AppGroup.Location].self, key: "group_key") ?? [AppGroup.Location]()
        for index in 0..<list.count {
            list[index].open = false
        }
        LocationManager.save(list, key: "group_key")
        ScreenLockManager.update()
    }
    
    static func compare(selection : FamilyActivitySelection, group: AppGroup) -> Bool{
        var isSame = 0
        if (selection.categoryTokens == group.activityCategoryTokens) {
            isSame = isSame + 1
        }
        
        if (selection.applicationTokens == group.applicationTokens) {
            isSame = isSame + 1
        }
        
        if (selection.webDomainTokens == group.webDomainTokens) {
            isSame = isSame + 1
        }
        if isSame == 3 {
            return true
        }
        
        return false
    }
    
    static func loadLocatinData(selection : inout  FamilyActivitySelection, groupName:String){
        
        if let locationGroup = LocationManager.find([AppGroup.Location].self,key: "group_key")?.filter({$0.name == groupName }).first {
            selection.applicationTokens = locationGroup.applicationTokens
            selection.webDomainTokens = locationGroup.webDomainTokens
            selection.categoryTokens = locationGroup.activityCategoryTokens
        }
    }
}
extension FamilyActivitySelection: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
class StrictMode: ObservableObject {
    
    let store = ManagedSettingsStore()
    var hours: Int
    var minutes: Int
    
    init(
        hours: Int,
        minutes: Int
    ){
        self.hours = hours
        self.minutes = minutes
    }
    func setLevel() {
        store.application.denyAppRemoval = false
        let userDefaults = UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")
                userDefaults?.set(true, forKey: "testKey")
                userDefaults?.synchronize()
        let calendar = Calendar(identifier: .gregorian)
        let startTime = Calendar.current.dateComponents([.day, .hour, .minute], from: Date())
        
        let endTime1 = calendar.date(byAdding: DateComponents(hour: hours, minute: minutes + 15), to: Date())
        print(endTime1!)
        let endTime = Calendar.current.dateComponents([.day, .hour, .minute], from: endTime1!)
        
        UserDefaults.standard.set(endTime.hour, forKey: "hour")
        UserDefaults.standard.set(endTime.minute, forKey: "minute")
        
        let request = BGAppRefreshTaskRequest(identifier: "strictMode")
        request.earliestBeginDate = endTime1
        try? BGTaskScheduler.shared.submit(request)

        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: startTime.hour, minute: startTime.minute),
            intervalEnd: DateComponents(hour: endTime.hour, minute: endTime.minute),
            repeats: true
        )
        let center = DeviceActivityCenter()
        DeviceActivityName.daily.rawValue = "Strict"
        do {
            center.stopMonitoring([DeviceActivityName.daily])
            try center.startMonitoring(.daily, during: schedule)
            StrictAppStorage().toTrue()
            print(startTime)
            print(endTime)
        }catch {
            print(error.localizedDescription)
        }
    }
}
class StrictAppStorage: ObservableObject {
    @AppStorage("timer", store: UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")) var timerBool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    func toTrue() {
        timerBool = true
    }
    func toFalse() {
        let center = DeviceActivityCenter()
        DeviceActivityName.daily.rawValue = "Strict"
        timerBool = false
        center.stopMonitoring([DeviceActivityName.daily])
    }
}
class uuid: ObservableObject {
    @AppStorage("uuid", store: UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")) var uuid = "uuid" {
        didSet {
            self.objectWillChange.send()
        }
    }
        func changeUUID() {
            uuid = UUID().uuidString
        }
    }








