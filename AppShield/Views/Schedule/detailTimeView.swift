import SwiftUI

struct Home: View {
    
    @State var startAngle: Double = 0
    @State var toAngle: Double = 90
    
    @State var startProgress: CGFloat = 0
    @State var toProgress: CGFloat = 0.25
    @Environment(\.dismiss) private var dismiss
    @Binding var editTime: Bool
    @Binding var index: Int
    @Binding var time2 : [AppGroup.Time]
    @Binding var testID: UUID
    @State private var showingAlert = false
    

    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter
    }()

    
    var body: some View {
        
        NavigationView{
            VStack{
                HStack(spacing: 25){
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Label {
                            Text("From")
                                .foregroundColor(.black)
                        } icon: {
                            Image(systemName: "arrowtriangle.right.fill")
                                .foregroundColor(Color("Blue"))
                        }
                        .font(.callout)
                        
                        Text(getTime(angle: startAngle).formatted(date: .omitted, time: .shortened))
                            .font(.title2.bold())
                    }
                    .frame(maxWidth: .infinity,alignment: .center)
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Label {
                            Text("To")
                                .foregroundColor(.black)
                        } icon: {
                            Image(systemName: "stop.fill")
                                .foregroundColor(Color("Blue"))
                        }
                        .font(.callout)
                        
                        Text(getTime(angle: toAngle).formatted(date: .omitted, time: .shortened))
                            .font(.title2.bold())
                    }
                    .frame(maxWidth: .infinity,alignment: .center)
                }
                .padding()
                .background(.black.opacity(0.06),in: RoundedRectangle(cornerRadius: 15))
                .padding(.top,15)
                
                SleepTimeSlider()
                    .padding(.top,70)
                    .onChange(of: getTime(angle: startAngle).formatted(date: .omitted, time: .shortened)) { newSelection in

                            let selectionFeedback = UISelectionFeedbackGenerator()
                            selectionFeedback.selectionChanged()
                    }
                    .onChange(of: getTime(angle: toAngle).formatted(date: .omitted, time: .shortened)) { newSelection in
                            let selectionFeedback = UISelectionFeedbackGenerator()
                            selectionFeedback.selectionChanged()
                    }
            }
            .onAppear{
                getTime()
            }
            
            .padding()
            .frame(maxHeight: .infinity,alignment: .top)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }, label: {
                Text("Cancel")
            }),trailing: Button(action: {
                if toAngle - startAngle >= 5 || toAngle - startAngle <= -5 {
                    if editTime == false {
                        
                        time2.append(AppGroup.Time(s: dateFormatter.string(from: getTime(angle: startAngle)), e: dateFormatter.string(from: getTime(angle: toAngle))))
                        testID = UUID()
                        dismiss()
                    } else if editTime == true {
                        
                        time2[index] = AppGroup.Time(s: dateFormatter.string(from: getTime(angle: startAngle)), e: dateFormatter.string(from: getTime(angle: toAngle)))
                        testID = UUID()
                        
                    }
                    dismiss()
                } else {
                    self.showingAlert = true
                }

            }, label: {
                Text("Save")
                
            }))
            .navigationBarTitle("Edit time", displayMode: .inline)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Interval is too short"),
                      message: Text("The system requires intervals longer than 20 minutes to work properly"),
                      dismissButton: .default(Text("OK")))
            }
        }
        
    }
    
    func getTime() {
        let dateFormatter = DateFormatter()

        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "HH:mm"
        let date0 = dateFormatter.date(from: "00:00")
        
        
        let date1 = time2[index].startTime
        let date2 = time2[index].endTime
        
        let startTimeValue = dateFormatter.date(from: date1)
        let endTimeValue = dateFormatter.date(from: date2)
        
        let timeInterval1 = date0!.distance(to: startTimeValue!) / 3600
        let timeInterval2 = date0!.distance(to: endTimeValue!) / 3600
    startAngle = timeInterval1 * 15
    toAngle = timeInterval2 * 15
    startProgress = timeInterval1 / 24
    toProgress = timeInterval2 / 24
    
    }
    
    
    @ViewBuilder
    func SleepTimeSlider()->some View{
        
        GeometryReader{proxy in
            
            let width = proxy.size.width
            
            ZStack{
                
                ZStack{
                    
                    ForEach(1...60,id: \.self){index in
                        Rectangle()
                            .fill(index % 5 == 0 ? .black : .gray)
                            .frame(width: 2, height: index % 5 == 0 ? 10 : 5)
                            .offset(y: (width - 60) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 6))
                    }
                    
                    let texts = [12,14,16,18,20,22,0,2,4,6,8,10]
                    ForEach(texts.indices,id: \.self){index in
                        
                        Text("\(texts[index])")
                            .font(.caption.bold())
                            .foregroundColor(.black)
                            .rotationEffect(.init(degrees: Double(index) * -30))
                            .offset(y: (width - 90) / 2)
                        // 360/4 = 90
                            .rotationEffect(.init(degrees: Double(index) * 30))
                    }
                }
                
                Circle()
                    .stroke(.black.opacity(0.06),lineWidth: 45)
                
                let reverseRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360) : 0
                Circle()
                    .trim(
                        from: startProgress > toProgress ? 0 : startProgress, to: toProgress + (-reverseRotation / 360))
                    .stroke(Color("Blue"),style: StrokeStyle(lineWidth: 45, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                
                Image(systemName: "arrowtriangle.right.fill")
                    .font(.callout)
                    .foregroundColor(Color("Blue"))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -startAngle))
                    .background(.white,in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: startAngle))
                    .gesture(
                    
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value,fromSlider: true)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                
                Image(systemName: "stop.fill")
                    .font(.callout)
                    .foregroundColor(Color("Blue"))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -toAngle))
                    .background(.white,in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: toAngle))
                    .gesture(
                    
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                     
                VStack(spacing: 6){
                    if startAngle <= toAngle {
                        Text("\(getTimeDifference().0)hr")
                            .font(.largeTitle.bold())
                    }
                    if startAngle > toAngle {
                        Text("\(getTimeDifference().0 + 24 )hr")
                            .font(.largeTitle.bold())
                    }
                        
                    if startAngle <= toAngle {
                        Text("\(getTimeDifference().1)min")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                    if startAngle > toAngle {
                        Text("\(-getTimeDifference().1)min")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                }
                .scaleEffect(1.1)
            }
        }
        .frame(width: screenBounds().width / 1.3, height: screenBounds().width / 1.3)
        .interactiveDismissDisabled()
        
    }
    
    func onDrag(value: DragGesture.Value,fromSlider: Bool = false){
        
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        
        var angle = radians * 180 / .pi
        if angle < 0{angle = 360 + angle}
        
        let progress = angle / 360
        
        if fromSlider{
            
            self.startAngle = angle
            self.startProgress = progress
        }
        else{
            
            self.toAngle = angle
            self.toProgress = progress
        }
    }
    
    // MARK: Returning Time based on Drag
    func getTime(angle: Double)->Date{
        
        // 360 / 15 = 24
        // 24 = Hours
        let progress = angle / 15
        
        let hour = Int(progress)
        let remainder = (progress.truncatingRemainder(dividingBy: 1) * 12).rounded()
        
        var minute = remainder * 5
        minute = (minute > 55 ? 55 : minute)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month,.day,.year], from: Date())
          
        let rawDay = (components.day ?? 0)
        var day: Int = 0
        
        if angle == toAngle{
            day = rawDay 
        }
        else{
            day = (startAngle > toAngle) ? rawDay : rawDay
            
        }
        if let date = formatter.date(from: "\(components.year ?? 0)-\(components.month ?? 0)-\(day) \(hour == 24 ? 0 : hour):\(Int(minute)):00"){
            return date
        }
        return .init()
    }
    
    func getTimeDifference()->(Int,Int){
        
        let calendar = Calendar.current
        
        let result = calendar.dateComponents([.hour,.minute], from: getTime(angle: startAngle), to: getTime(angle: toAngle))
        
        return (result.hour ?? 0,result.minute ?? 0)
    }
    
}

struct Home_Previews: PreviewProvider {

    @State static var time2 = [AppGroup.Time(s: "00:00", e: "01:00")]

    @State static var editTime = false
    @State static var index = 0
    @State static var testID = UUID()
    static var previews: some View {
        Home(editTime: $editTime,index: $index, time2: $time2, testID: $testID)
    }
}

extension View{
    
    func screenBounds()->CGRect{
        return UIScreen.main.bounds
    }
}
