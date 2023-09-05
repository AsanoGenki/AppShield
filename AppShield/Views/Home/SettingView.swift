import SwiftUI

struct SettingView: View {
    @State var showPremium = false

    var body: some View {
        NavigationView{
            List{
                Section{
                    HStack{
                        VStack(alignment: .leading, spacing: 3){
                            HStack(spacing: 2){
                                Text("AppShield Pro")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 22))
                                    .fontWeight(.semibold)
                                Image(systemName: "checkerboard.shield")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 26))
                            }
                            Text("7-DAY FREE TRIAL")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .padding(.vertical, 5)
                                .padding(.horizontal, 8)
                                .background(.blue)
                                .cornerRadius(7)
                            
                        }
                        Spacer()

                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 20))
                    .onTapGesture{
                        showPremium = true
                    }
                    .fullScreenCover(isPresented: $showPremium) {
                        PremiumView()
                    }
                }
                .frame(height : 100)
                
                Section{
                    HStack{
                    Label(
                        title: {
                            Text("Notification")
                                .font(.title3)
                                .fontWeight(.semibold)
                        },
                        icon: {
                            Image(systemName: "bell.fill")
                                .font(.title2)
                                .foregroundColor(Color.blue)
                        }).frame(height: 40)
                        Spacer()
                    }
                }
            }.navigationBarTitle("Setting", displayMode: .inline)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var image2 = Image("profile")
    static var previews: some View {
        SettingView()
    }
}
