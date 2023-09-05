import SwiftUI
import Combine
import FamilyControls
import ManagedSettings

struct TimerBottomView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @AppStorage("timerAppSelecton") var timerAppSelecton = FamilyActivitySelection()
    @ObservedObject var stopwatch: Stopwatch
    
    @State var isPresented = false
    @State var showPremium = false
    @Binding var hour: Int
    @Binding var minute: Int
    @State var levelSheet = false
    
    @AppStorage("hour") var savehour = 0
    @AppStorage("minute") var saveminute = 0
    @AppStorage("timer") var timerBool = false
    @AppStorage("totalTime") var timeTotal = 0
    @AppStorage("strictMode") var strictMode = false
    @AppStorage("level") var level = 0
    var body: some View {
        HStack {
            Spacer()
            HStack{
                Image(systemName: "square.stack.3d.up.fill")
                    .foregroundColor(.blue)
                if timerAppSelecton.applicationTokens.count != 0 && purchaseManager.hasUnlockedPro{
                    Text(String(timerAppSelecton.applications.count))
                        .foregroundColor(.blue)
                } else {
                    Text("0")
                        .foregroundColor(.blue)
                }
            }
            .onTapGesture{
                if !purchaseManager.hasUnlockedPro {
                    showPremium = true
                } else {
                    isPresented = true
                }
            }
            .fullScreenCover(isPresented: $showPremium) {
                PremiumView()
            }
            .familyActivityPicker(isPresented: $isPresented, selection: $timerAppSelecton)
            Spacer()
            Image(systemName: "arrowtriangle.right.fill")
                .font(.system(size: 28))
                .foregroundColor(.blue)
                .background(
                    Circle()
                        .stroke(Color.blue, lineWidth: 3)
                        .frame(width: 60, height: 60)
                )
                .foregroundColor(!timerBool  ? .white : .gray)
                .onTapGesture {
                    savehour = hour
                    if hour == 0 {
                        saveminute = minute * 5
                    } else if hour >= 1{
                        saveminute = minute * 5
                    }
                    timeTotal = (hour * 3600) + (saveminute * 60)
                    if !timerBool{
                        stopwatch.start(hours: savehour, minutes: saveminute)
                        strictMode = true
                    } else if timerBool{
                        ManagedSettingsStore(named: ManagedSettingsStore.Name("Timer")).clearAllSettings()
                        stopwatch.stop()
                        timerBool = false
                    }
                    if purchaseManager.hasUnlockedPro {
                        ManagedSettingsStore(named: ManagedSettingsStore.Name("Timer")).shield.applications = timerAppSelecton.applicationTokens
                    }
                }
            
            Spacer()
            if level == 0 {
                Image("emoji01")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture{
                        levelSheet = true
                    }
                    .sheet(isPresented: $levelSheet) {
                        SelectLevelView(level: $level)
                            .presentationDetents([ .small2])
                    }
            } else if level == 1 {
                Image("emoji02")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture{
                        levelSheet = true
                    }
                    .sheet(isPresented: $levelSheet) {
                        SelectLevelView(level: $level)
                            .presentationDetents([ .small2])
                    }
            }
            Spacer()
        }
        .listRowSeparator(.hidden)
        .isHidden(timerBool)
        .padding(.vertical, 30)
        .padding(.horizontal, 10)
    }
}

struct TimerBottomView_Previews: PreviewProvider {
    @State static var hour: Int = 0
    @State static var minute: Int = 0
    static var previews: some View {
        TimerBottomView(stopwatch: Stopwatch(hours: 1, minutes: 0), hour: $hour, minute: $minute)
    }
}

extension PresentationDetent {
    static let small = Self.height(230)
    static let small2 = Self.height(250)
}
