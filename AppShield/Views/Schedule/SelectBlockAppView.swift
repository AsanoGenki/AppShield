import SwiftUI
import FamilyControls
import ManagedSettings

struct SelectBlockAppView: View {
    @State var isPresented = false
    @Binding var selection: FamilyActivitySelection
    @State var applicationTokens:Set<ApplicationToken> = []
    @State var result: [ApplicationToken] = []
    var body: some View {
        Button(action: {
            isPresented = true }) {
            if selection.applicationTokens.count == 0 {
            VStack(alignment: .center)  {
                Image(systemName: "app.badge.checkmark")
                    .font(.system(size: 40))
                    .padding(6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                    .fixedSize(horizontal: true, vertical: false)
                    .foregroundColor(.blue)
                
                    .padding(.top,10)
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
                    .padding(.bottom, 10)
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
                isPresented = true
            }){
                Label(applicationToken)
            }
        }
    }
    }


struct SelectBlockAppView_Previews: PreviewProvider {
    @State static var selection: FamilyActivitySelection = FamilyActivitySelection()
    static var previews: some View {
        SelectBlockAppView(selection: $selection)
    }
}
