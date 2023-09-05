import SwiftUI

struct PremiumImageView: View {
    private let images = ["premium04"]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { item in
                ZStack(alignment: .bottom){
                    Image(item)
                        .resizable()
                        .scaledToFill()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 300)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

struct PremiumImageView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumImageView()
    }
}
