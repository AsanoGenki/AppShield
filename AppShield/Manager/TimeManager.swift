import Combine
import ManagedSettings
import SwiftUI

class Stopwatch: ObservableObject {
    
    var hours: Int
    var minutes: Int
    
    @Published private(set) var message = "Not running"
    @Published var result = 0.0
    @Published private(set) var isRunning = false
    @AppStorage("totalTime") var timeTotal = 0
    
    
    private var startTime: Date?{
        didSet { saveStartTime() }
    }
    
    private var timer: AnyCancellable?
    
    init(hours: Int,
         minutes: Int) {
        self.hours = hours
        self.minutes = minutes
        startTime = fetchStartTime()
        
        if startTime != nil {
            start(hours: hours, minutes: minutes)
        }
    }
    
    func getWeight(offset: CGFloat)->String{
        let startWeight = 15
        let progress = offset / 20
        
        return "\(startWeight + (Int(progress) * 1))"
    }
    
    func getSecondsToDuration(_ result: Int) -> String {
        let seconds = String(result % 60)
        let minutes = String((result / 60) % 60)
        let hours = String(result / 3600)
        let minuteStamp = minutes.count > 1 ? minutes : "0" + minutes
        let hoursStamp = hours.count > 1 ? hours : "0" + hours
        let secondsStamp = String(seconds.count > 1 ? seconds : "0" + seconds)
        if result / 3600 < 1 {
            return "\(minuteStamp) : \(secondsStamp)"
        } else {
            return "\(hoursStamp) : \(minuteStamp) : \(secondsStamp)"
        }
    }
    
    func gettimeCircle(_ result: Int) -> Double {
        return (Double(timeTotal) - Double(result)) / Double(timeTotal)
    }
}


extension Stopwatch {
    
    func start(hours: Int, minutes: Int) {
        VariableViewModel().increment()
        UserDefaults.standard.set(true, forKey: "timer")
        timer?.cancel()
        let hrs = hours * 3600, mins = minutes * 60
        let seconds = mins + hrs
        let totalTime = Double(seconds)
        
        if startTime == nil {
            startTime = Date()
        }
        @AppStorage("strictMode") var strictMode = true
        message = ""
        
        timer = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard
                    let self = self,
                    let startTime = self.startTime
                else { return }
                
                let now = Date()
                let elapsed = now.timeIntervalSince(startTime)
                
                guard elapsed < totalTime else {
                    self.stop()
                    VariableViewModel().increment2()
                    @AppStorage("strictMode") var strictMode = false
                    return
                }
                self.result = totalTime - elapsed
                
                self.message = String(format: "%0.1f", self.result)
            }
        
        isRunning = true
    }

    func stop() {
        timer?.cancel()
        timer = nil
        startTime = nil
        isRunning = false
        message = "Not running"
        UserDefaults.standard.set(false, forKey: "timer")
        VariableViewModel().increment2()
        ManagedSettingsStore(named: ManagedSettingsStore.Name("Timer")).clearAllSettings()
        @AppStorage("strictMode") var strictMode = false
    }
}


private extension Stopwatch {
    func saveStartTime() {
        if let startTime = startTime {
            UserDefaults.standard.set(startTime, forKey: "startTime")
        } else {
            UserDefaults.standard.removeObject(forKey: "startTime")
        }
    }
    
    func fetchStartTime() -> Date? {
        UserDefaults.standard.object(forKey: "startTime") as? Date
    }
}


class VariableViewModel: ObservableObject {
    @AppStorage("timer") var timerBool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    func increment() {
        timerBool = true
    }
    func increment2() {
        timerBool = false
    }
}
