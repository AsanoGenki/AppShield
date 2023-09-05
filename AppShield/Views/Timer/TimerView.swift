import SwiftUI
import Combine
import FamilyControls
import ManagedSettings

struct TimerView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @ObservedObject var stopwatch: Stopwatch
    
    @State var hour = 0
    @State var minute = 3
    @State var offset: CGFloat = 0
    
    @AppStorage("hour") var savehour = 0
    @AppStorage("minute") var saveminute = 0
    
    var body: some View {
        NavigationView{
            ZStack{
                TimerCircleView(stopwatch: Stopwatch(hours: savehour, minutes: saveminute), offset: $offset, result: $stopwatch.result)
                    
                VStack{
                    Spacer()
                    TimeSliderView(stopwatch: Stopwatch(hours: savehour, minutes: saveminute), offset: $offset, hour: $hour, minute: $minute)
                    TimerBottomView(stopwatch: Stopwatch(hours: savehour, minutes: saveminute), hour: $hour, minute: $minute)
                }
                .scrollDisabled(true)
                .scrollContentBackground(.hidden)
                .padding(.top, 10)
            }
        }
    }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(stopwatch: Stopwatch(hours: 1, minutes: 0))
    }
}
