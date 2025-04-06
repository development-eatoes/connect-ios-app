import SwiftUI

struct VegNonVegIndicator: View {
    let isVegetarian: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .stroke(isVegetarian ? Color.green : Color.red, lineWidth: 1)
                .frame(width: 18, height: 18)
            
            Rectangle()
                .fill(isVegetarian ? Color.green : Color.red)
                .frame(width: 10, height: 10)
        }
    }
}