import SwiftUI

struct TimeSliderView: View {
    @ObservedObject var stopwatch: Stopwatch
    @Binding var offset: CGFloat
    @Binding var hour: Int
    @Binding var minute: Int
    @AppStorage("timer") var timerBool = false
    var body: some View {
        VStack(spacing: 15){
            let pickerCount = 45
            
            CustomSlider(pickerCount: pickerCount, offset: $offset, content: {
                
                HStack(spacing: 0){
                    
                    ForEach(1...pickerCount,id: \.self){index in
                        
                        VStack{
                            Rectangle()
                                .cornerRadius(20)
                                .frame(width: 3, height: 30)
                            
                            if 10 + (index * 5) < 200 {
                                Text("\(10 + (index * 5))")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            } else {
                                Text("\(10 + (index * 5))")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 20)
                        
                        ForEach(1...4,id: \.self){subIndex in
                            
                            Rectangle()
                                .cornerRadius(20)
                                .frame(width: 3, height: 15)
                                .frame(width: 20)
                        }
                    }
                    
                    VStack{
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 3, height: 30)
                        Text("\(240)")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 20)
                }
            })
            .frame(height: 50)
            .overlay(
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 1, height: 50)
                    .offset(x: 0.8, y: -30)
            )
            .padding()
            .onChange(of: stopwatch.getWeight(offset: offset)) { newSelection in
                let selectionFeedback = UISelectionFeedbackGenerator()
                selectionFeedback.selectionChanged()
                if Int(stopwatch.getWeight(offset: offset))! < 60 {
                    hour = 0
                    minute =  (Int(stopwatch.getWeight(offset: offset))!) / 5
                } else {
                    hour = Int(stopwatch.getWeight(offset: offset))! / 60
                    let minute1 = hour * 60
                    minute = (Int(stopwatch.getWeight(offset: offset))! - minute1) / 5
                }
            }
            .isHidden(timerBool, remove: true)
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .padding(.bottom, -75)
    }
}

struct TimeSliderView_Previews: PreviewProvider {
    @State static var offset: CGFloat = 0
    @State static var hour: Int = 0
    @State static var minute: Int = 0
    static var previews: some View {
        TimeSliderView(stopwatch: Stopwatch(hours: 1, minutes: 0), offset: $offset, hour: $hour, minute: $minute)
    }
}
