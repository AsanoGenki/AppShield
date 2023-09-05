import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity
import Algorithms
import AlertToast
import SymbolPicker

struct EditScheduleView: View {
    
    @ObservedObject var group :AppGroup
    @Binding var selection2: FamilyActivitySelection
    @State var selection = FamilyActivitySelection()
    @State private var name = ""
    @State var editTime = false
    @State private var showingModal = false
    @State var isPresented = false
    @State var testID : UUID = UUID()

    @State var index = 0
    @State var applicationTokens:Set<ApplicationToken> = []
    @State var result: [ApplicationToken] = []
    @State private var showingAlert = false
    @State var weekDays: [String] = []
    @State private var showingWeekView = false
    @State private var showToast = false
    @State private var iconPickerPresented = false
    @State private var icon = "pencil"
    @State private var selectedColor: Color = .blue
    @AppStorage("timer") var timerBool = false
    @Environment(\.dismiss) private var dismiss
    var taskNameIsValid: Bool {
        if !name.isEmpty && !selection.applicationTokens.isEmpty && !weekDays.isEmpty{
            return true
        } else {
            return false
        }
      }
    
    let weekDayNumbers = [
        "Sunday": 0,
        "Monday": 1,
        "Tuesday": 2,
        "Wednesday": 3,
        "Thursday": 4,
        "Friday": 5,
        "Saturday": 6,
    ]
    let fmt = DateFormatter().weekdaySymbols
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter
    }()
    var body: some View {
        NavigationView{
            Form{
                VStack {
                    HStack {
                    Spacer()
                        Text(testID.uuidString)
                            .frame(width: 0, height: 0)
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
                    .onAppear{
                        icon = group.icon
                        selectedColor = Color(.sRGB, red: group.iconRGB[0], green: group.iconRGB[1], blue: group.iconRGB[2], opacity: 1.0)
                        name = group.title
                        weekDays = group.week
                        selection = selection2
                        
                }
                    MyColorPicker(selectedColor: $selectedColor)
                }
                Section {TextField("Enter a title", text: $name)
                } header: {
                    Text("")
                }
                Section{
                    HStack(){
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
                                    if timerBool == false {
                                        if !weekDays.contains(element){
                                            weekDays.append(element)
                                        } else {
                                            weekDays.removeAll(where: {$0 == element})
                                        }
                                    } else {
                                        self.showToast.toggle()
                                    }
                                }
                            
                            Spacer()
                        }.padding(.vertical, 8)
                    }
                    .padding(.vertical, 7)
                }header: {
                    Text("Days Active")
                        .textCase(.none)
                        .font(.title2)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 0))
                }
                Section {
                    ForEach(group.time.indexed(),id: \.index) { timeIndex,times in
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
                            print(timerBool)
                            if timerBool == false {
                                self.showingModal.toggle()
                            } else {
                                self.showToast.toggle()
                            }
                        }
                        
                    }
                    .sheet(isPresented: $showingModal) {
                        Home(editTime: $editTime,index: $index, time2: $group.time, testID: $testID)
                    }
                    
                    Button(action: {
                        editTime = false
                        self.showingModal.toggle()
                    })
                    {
                        Text("Add time")
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $showingModal) {
                        Home(editTime: $editTime,index: $index, time2: $group.time, testID: $testID)
                    }
                    
                }
            header: {
                Text("Active time")
                    .textCase(.none)
                    .font(.title2)
                    .foregroundColor(.black)
                
                    .frame(height: 40)
                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            }
                Button(action: {
                    if timerBool == false {
                        isPresented = true
                    } else {
                        self.showToast.toggle()
                    }
                }) {if selection.applicationTokens.count == 0 {
                    VStack(alignment: .center)  {
                        Text("Add something to block")
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .bold()
                            .padding(.top,5)
                            .padding(.bottom,1)
                        
                        
                        Text("Select which application you")
                            .foregroundColor(Color.gray)
                        Text("want to block")
                            .foregroundColor(Color.gray)
                        Text("Add")
                            .bold()
                            .padding()
                            .frame(width: 100, height: 40)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    
                    
                }
                    else {
                        HStack{
                            Text("Block List")
                                .font(.title2)
                                .foregroundColor(Color.black)
                            Spacer()
                        }
                    }
                }
                
                .familyActivityPicker(isPresented: $isPresented, selection: $selection)
                .onChange(of: selection) { newSelection in
                    
                    applicationTokens = selection.applicationTokens
                    result = Array(Set(applicationTokens))
                }
                
                
                ForEach(result, id: \.self) { applicationToken in
                    Button(action: {
                        if timerBool == false {
                            isPresented = true
                        } else if timerBool == true {
                            self.showToast.toggle()
                        }
                    }){
                        Label(applicationToken)
                    }
                }
            }.familyActivityPicker(isPresented: $isPresented, selection: $selection)
                .onChange(of: selection) { newSelection in
                    applicationTokens = selection.applicationTokens
                    result = Array(Set(applicationTokens))
                }
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
                        
                        let applicationsTokens = selection.applicationTokens
                        let categoryTokens = selection.categoryTokens
                        group.count = applicationsTokens.count
                        group.title = name
                        selection2 = selection
                        group.week = weekDays
                        weekDays.sort(by: { (weekDayNumbers[$0] ?? 7) < (weekDayNumbers[$1] ?? 7) })
                        group.week = weekDays
                        group.applicationTokens = applicationsTokens
                        group.activityCategoryTokens = categoryTokens;
                        group.count = group.updateCount
                        if group.count == 0 {
                            group.open = false
                        } else {
                            group.open = true
                        }
                        group.iconRGB = UIColor(selectedColor).cgColor.components!
                        group.icon = icon
                        ScreenLockManager.save(group: group)
                        group.initiateMonitoring()
                        dismiss()
                        
                    }, label: {
                        Text("Save")
                    }).disabled(!taskNameIsValid)
                    
                })
            
        }.environment(\.defaultMinListRowHeight, 60)
        .toast(isPresenting: $showToast){
            AlertToast(type: .systemImage("lock.shield", .blue), title: Optional("Strict Mode"))
        }

    }
}

struct EditScheduleView_Previews: PreviewProvider {
    @State static var groupName = "Title"
    static var previews: some View {
        EditScheduleView(group: AppGroup(name: "appGroup1", open: true, count: 0, creatTime: Date().timeIntervalSince1970 + 4, title: "Title", week: [""], time: [AppGroup.Time(s: "00:00", e: "01:00")], icon: "", iconRGB: [0,0,0]),selection2: .constant(FamilyActivitySelection(includeEntireCategory: true)), weekDays: [])
    }
}
