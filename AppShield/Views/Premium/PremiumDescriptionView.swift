import SwiftUI

struct PremiumDescriptionView: View {
    var body: some View {
        HStack{
            Text("Full Access")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .foregroundColor(Color(.sRGB, red: 0.22, green: 0.22, blue: 0.23, opacity: 1.0))
            Spacer()
        }.padding(.bottom, 20)
            .padding(.horizontal, 30)
        VStack(alignment: .leading, spacing: 18){
            HStack{
                Image(systemName: "alarm.waves.left.and.right.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
                    .frame(width: 40, height: 40)
                Text("Block Apps by Timer")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                
            }
            HStack{
                Image(systemName: "square.stack.3d.up.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
                    .frame(width: 40, height: 40)
                Text("Multiple Schedules")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                
            }
            HStack{
                Image(systemName: "lock.fill")
                    .font(.title3)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                Text("Powerful Strict Mode")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                
            }
            HStack{
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                Text("No Ads")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                
            }
            
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 10)
    }
}

struct PremiumDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumDescriptionView()
    }
}
