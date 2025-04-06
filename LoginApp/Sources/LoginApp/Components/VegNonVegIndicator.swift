import SwiftUI

struct VegNonVegIndicator: View {
    let isVegetarian: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .stroke(isVegetarian ? Color.green : Color.red, lineWidth: 1)
                .frame(width: 16, height: 16)
            
            Circle()
                .fill(isVegetarian ? Color.green : Color.red)
                .frame(width: 8, height: 8)
        }
    }
}

struct VegNonVegIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VegNonVegIndicator(isVegetarian: true)
                .padding()
                .previewDisplayName("Vegetarian")
            
            VegNonVegIndicator(isVegetarian: false)
                .padding()
                .previewDisplayName("Non-Vegetarian")
        }
        .padding()
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}