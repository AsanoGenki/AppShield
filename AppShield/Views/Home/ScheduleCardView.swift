import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity
import AlertToast

struct ScheduleCardView: View {
    @ObservedObject var group :AppGroup
    @State var selection = FamilyActivitySelection(includeEntireCategory: true)
    @State var isSheeted = false
    @State private var showToast = false
    @State private var showToast2 = false
    let userDefaults = UserDefaults(suiteName: "group.com.DeviceActivityMonitorExtension")
   
    var body : some View {
        VStack (spacing: 4){
            HStack{
                Image(systemName: group.icon)
                    .foregroundColor(Color(.sRGB, red: group.iconRGB[0], green: group.iconRGB[1], blue: group.iconRGB[2], opacity: 1.0))
                    .font(.largeTitle)
                    .padding(.leading, -10)
                    .frame(maxWidth: 60, maxHeight: 60)
                    .foregroundColor(.white)
                VStack(spacing: 5) {
                    HStack{
                        if group.week == ["Sunday",
                                          "Monday",
                                          "Tuesday",
                                          "Wednesday",
                                          "Thursday",
                                          "Friday" ,
                                          "Saturday"]{
                            Text("Everyday")
                        } else if group.week == ["Monday",
                                                 "Tuesday",
                                                 "Wednesday",
                                                 "Thursday",
                                                 "Friday" ]{
                            Text("Weekdays")
                        }else if group.week == ["Sunday",
                                                "Saturday" ]{
                            Text("Weekends")
                        } else{
                            Text(group.week.map{$0.prefix(3)}.joined(separator: ","))
                        }
                        Spacer()
                    }
                    HStack {
                        Text(group.title)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        
                        Image(systemName: "timer")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                            .isHidden(userDefaults?.bool(forKey: group.name) as Any as! Bool == false, remove: true)
                    }
                    HStack{
                        if group.time.count == 1{
                            Text("\(group.time[0].startTime) - \(group.time[0].endTime)")
                                .font(.subheadline)
                        }
                        else if group.time.count == 2{
                            Text("\(group.time[0].startTime) - \(group.time[0].endTime), \(group.time[1].startTime) - \(group.time[1].endTime)")
                                .font(.subheadline)
                        }else if group.time.count > 2{
                            Text("\(group.time[0].startTime) - \(group.time[0].endTime), \(group.time[1].startTime) - \(group.time[1].endTime) ...")
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                }
                
                .contentShape(RoundedRectangle(cornerRadius: 20))
                
                .onTapGesture {
                    if userDefaults?.bool(forKey: group.name) as Any as! Bool == false {
                        isSheeted = true
                    } else {
                        showToast2 = true
                    }
                    
                }
                .sheet(isPresented: $isSheeted) {
                    EditScheduleView(group: group, selection2: $selection)
                }
                .onAppear {
                    ScreenLockManager.loadLocatinData(selection: &selection, groupName: group.name)
                }
                
            }
            .toast(isPresenting: $showToast){
                AlertToast(displayMode: .banner(.slide), type: .systemImage("lock.shield", .blue), title: "Strict Mode")
            }
            .toast(isPresenting: $showToast2){
                AlertToast(displayMode: .banner(.slide), type: .systemImage("lock.shield", .blue), title: "Active")
            }
            .onChange(of: selection) { newSelection in
                self.group.objectWillChange.send()
            }
        }
    }
}

