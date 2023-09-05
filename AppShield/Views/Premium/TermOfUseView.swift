import SwiftUI
import Purchases

struct TermOfUseView: View {
    var body: some View {
        HStack{
            Spacer()
            HStack(spacing: 4){
                Link(destination: URL(string: "https://detoxbear.super.site/term-of-use")!, label: {
                    Text("Term of Use")
                        .underline()
                })
                Text("&")
                Link(destination: URL(string: "https://detoxbear.super.site/privacy-policy")!, label: {
                    Text("Privacy Policy")
                        .underline()
                })
                
            }
            .font(.system(size: 12))
            .foregroundColor(.gray)
            Spacer()
            Button {
                Task {
                    do {
                        try await AppStore.sync()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Restore Purchases")
                    .font(.system(size: 12))
            }
            
            Spacer()
        }.padding(.top, 20)
    }
}

struct TermOfUseView_Previews: PreviewProvider {
    static var previews: some View {
        TermOfUseView()
    }
}
