import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity
import SymbolPicker
struct NewScheduleView: View {
    
    @State var groupName: String = "Title"
    @ObservedObject var group :AppGroup
    @State var selection = FamilyActivitySelection()
    @State private var showingModal = false
    @Environment(\.dismiss) private var dismiss
    @State var editTime = false
    @State var index = 0
    @State var testID = UUID()
    @State private var showingAlert = false
    @State var weekDays: [String] = []
    @State private var iconPickerPresented = false
    @State private var icon = "bed.double"
    @Environment(\.editMode) var editMode
    @State private var selectedColor: Color = .blue
    @State var time2 : [AppGroup.Time] = [AppGroup.Time(s: "00:00", e: "01:00")]
    
    
    let weekDayNumbers = [
        "Sunday": 0,
        "Monday": 1,
        "Tuesday": 2,
        "Wednesday": 3,
        "Thursday": 4,
        "Friday": 5,
        "Saturday": 6,
    ]
    var isEditing: Bool {
        if group.time.count > 1 {
            editMode?.wrappedValue = .active
            return true
        }else {
            editMode?.wrappedValue = .inactive
            return false
        }
    }
    let uuid = UUID()
    let fmt = DateFormatter().weekdaySymbols
    
    var taskNameIsValid: Bool {
        if !groupName.isEmpty && !ScreenLockManager.compare(selection: selection, group: group) && !weekDays.isEmpty{
            return true
        } else {
            return false
        }
    }
    func rowRemove(offsets: IndexSet) {
        group.time.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView{
            Form{
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: icon)
                            .foregroundColor(selectedColor)
                            .font(.largeTitle)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .contentShape(RoundedRectangle(cornerRadius: 20))
                    .onTapGesture {
                        iconPickerPresented = true
                    }
                    
                    .sheet(isPresented: $iconPickerPresented) {
                        SymbolPicker(symbol: $icon)
                    }
                    MyColorPicker(selectedColor: $selectedColor)
                }
                Section {
                    TextField("Enter a title", text: $groupName)
                }
                Section{
                    HStack{
                        Text(testID.uuidString)
                            .frame(width: 0, height: 0)
                        
                        ForEach(fmt!, id: \.self) { element in
                            Spacer()
                            Text(element.prefix(1))
                                .padding(-2)
                                .foregroundColor(weekDays.contains(element) ?Color.white: Color.black)
                                .font(.title3)
                                .bold()
                                .background(
                                    weekDays.contains(element) ?
                                    Circle()
                                        .foregroundColor(Color.blue)
                                        .frame(width: 35, height: 35)
                                    : Circle()
                                        .foregroundColor(Color.white)
                                        .frame(width: 35, height: 35)
                                )
                                .onTapGesture {
                                    if !weekDays.contains(element){
                                        weekDays.append(element)
                                    } else {
                                        weekDays.removeAll(where: {$0 == element})
                                    }
                                }
                            
                            Spacer()
                        }.padding(.vertical, 8)
                    }
                    .padding(.vertical, 7)
                }
            header: {
                Text("Days Active")
                    .textCase(.none)
                    .font(.title2)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 0))
            }
                Section {
                    ForEach(time2.indexed(),id: \.index) { timeIndex,times in
                        HStack{
                            VStack(alignment: .leading, spacing: 3){
                                HStack(spacing: 4){
                                    Image(systemName:"arrowtriangle.right.circle.fill")
                                        .foregroundColor(.blue)
                                    Text("START")
                                        .font(.caption)
                                        .bold()
                                }.padding(.bottom, 0)
                                Text(times.startTime)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                            }
                            Spacer()
                            VStack(alignment: .leading, spacing: 3){
                                HStack(spacing: 4){
                                    Image(systemName:"iphone.gen2.radiowaves.left.and.right")
                                        .foregroundColor(.blue)
                                    Text("END")
                                        .font(.caption)
                                        .bold()
                                }.padding(.bottom, 0)
                                Text(times.endTime)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                            }
                            Spacer()
                        }
                        .frame(minHeight: 55)
                        .onTapGesture {
                            print("\(index)")
                            editTime = true
                            index = timeIndex
                            
                            self.showingModal.toggle()
                        }
                        
                    }
                    .onDelete(perform:rowRemove)
                    
                    
                    .sheet(isPresented: $showingModal) {
                        Home(editTime: $editTime,index: $index, time2: $time2, testID: $testID)
                    }
                    
                    Button(action: {
                        editTime = false
                        self.showingModal.toggle()
                    })
                    {
                        HStack{
                            Image(systemName:"plus")
                                .foregroundColor(.blue)
                            Text("Add time")
                                .font(.system(size: 16))
                                .bold()
                        }
                    }
                    .sheet(isPresented: $showingModal) {
                        Home(editTime: $editTime,index: $index, time2: $time2, testID: $testID)
                    }
                    
                }
            header: {
                Text("Active time")
                    .textCase(.none)
                    .font(.title2)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 0))
            }
                SelectBlockAppView(selection: $selection)
            }
            
            .navigationBarTitle("New Schedule", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showingAlert = true
            }, label: {
                Text("Cancel")
            }).alert(isPresented: $showingAlert) {
                Alert(title: Text("Really discard all changes?"),
                      primaryButton: .default(Text("Keep")),
                      secondaryButton: .destructive(Text("Discard"),
                                                    action: {
                    dismiss()
                }))
            }, trailing: HStack {
                Button(action: {
                    if ScreenLockManager.compare(selection: selection, group: group) {
                        return
                    }
                    
                    let applicationsTokens = selection.applicationTokens
                    let categoryTokens = selection.categoryTokens
                    
                    group.count = applicationsTokens.count
                    group.title = groupName
                    group.name = uuid.uuidString
                    weekDays.sort(by: { (weekDayNumbers[$0] ?? 7) < (weekDayNumbers[$1] ?? 7) })
                    group.week = weekDays
                    
                    group.creatTime = Date().timeIntervalSince1970
                    
                    group.applicationTokens = applicationsTokens
                    group.activityCategoryTokens = categoryTokens;
                    group.count = group.updateCount
                    if group.count == 0 {
                        group.open = false
                    } else {
                        group.open = true
                    }
                    group.iconRGB = UIColor(selectedColor).cgColor.components!
                    
                    group.creatTime = Date().timeIntervalSince1970
                    group.icon = icon
                    group.time = time2
                    print(group.time)
                    print(time)
                    
                    
                    ScreenLockManager.save(group: group)
                    group.initiateMonitoring()
                    dismiss()
                    
                }, label: {
                    Text("Done")
                }).disabled(!taskNameIsValid)
                
            })
            .environment(\.defaultMinListRowHeight, 60)
        }
        
    }
    
}

struct NewScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        NewScheduleView(group: AppGroup(name: "appGroup1", open: true, count: 0, creatTime: Date().timeIntervalSince1970 + 4, title: "Title", week: [""], time: [AppGroup.Time(s: "00:00", e: "01:00")], icon: "🚀", iconRGB: [0,0,0]))
    }
}

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        
#if canImport(UIKit)
        typealias NativeColor = UIColor
#elseif canImport(AppKit)
        typealias NativeColor = NSColor
#endif
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }
        
        return (r, g, b, o)
    }
}
