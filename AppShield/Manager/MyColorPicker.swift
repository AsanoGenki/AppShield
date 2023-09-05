import SwiftUI

struct MyColorPicker: View {
    @Binding var selectedColor: Color
    private let colors:[Color] = [.pink, .orange, .yellow, .green, .mint, .cyan, .blue, .indigo, .purple, .gray]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 45, height: 45)
                        .opacity(color == selectedColor ? 0.5 : 1.0)
                        .scaleEffect(color == selectedColor ? 1.1 : 1.0)
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(20)
            

        }
    }
}

struct MyColorPicker_Previews: PreviewProvider {
    
    static var previews: some View {
        MyColorPicker(selectedColor: .constant(.blue))
    }
}

