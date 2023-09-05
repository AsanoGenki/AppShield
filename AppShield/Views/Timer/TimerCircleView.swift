import Combine
import ManagedSettings
import SwiftUI

struct TimerCircleView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @ObservedObject var stopwatch: Stopwatch
    @Binding var offset: CGFloat
    @Binding var result: Double
    @AppStorage("timer") var timerBool = false
    @AppStorage("totalTime") var timeTotal = 0
    
    var body: some View {
        ZStack(alignment: .center){
            
            Circle()
                .stroke(Color(.sRGB, red: 0.58, green: 0.807, blue: 1.0, opacity: 1.0), style: StrokeStyle(lineWidth:10))
                .scaledToFit()
                .padding(10)
                .onAppear{
                    if !purchaseManager.hasUnlockedPro {
                        ManagedSettingsStore(named: ManagedSettingsStore.Name("Timer")).clearAllSettings()
                    }
                }
            Circle()
                .trim(from: 0.0, to: 1.0 - stopwatch.gettimeCircle(Int(result)))
                .stroke(timerBool ? Color.blue : Color(.sRGB, red: 0.58, green: 0.807, blue: 1.0, opacity: 1.0), style: StrokeStyle(lineWidth:10, lineCap: .round))
                .scaledToFit()
                .padding(10)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: result)
            
            if timerBool {
                Text(stopwatch.getSecondsToDuration(Int(result)))
                    .font(.system(size: 52).monospacedDigit())
                    .foregroundColor(.blue)
            } else {
                if Int(stopwatch.getWeight(offset: offset))! < 60 {
                    Text("\(stopwatch.getWeight(offset: offset)):00")
                        .font(.system(size: 52).monospacedDigit())
                        .foregroundColor(.blue)
                } else {
                    let hours = Int(stopwatch.getWeight(offset: offset))! / 60
                    let minutes = Int(stopwatch.getWeight(offset: offset))! - (Int(stopwatch.getWeight(offset: offset))! / 60) * 60
                    let minuteStamp = String(String(minutes).count > 1 ? String(minutes) : "0" + String(minutes))
                    
                    Text("\(hours):\(minuteStamp):00")
                        .font(.system(size: 52).monospacedDigit())
                        .foregroundColor(.blue)
                    
                }
            }
        }.frame(minHeight: 330)
            .padding(24)
            .padding(.top, -100)
        
    }
    
}

struct TimerCircleView_Previews: PreviewProvider {
    @State static var offset: CGFloat = 0
    @State static var result: Double = 0
    static var previews: some View {
        TimerCircleView(stopwatch: Stopwatch(hours: 1, minutes: 0), offset: $offset, result: $result)
    }
}
