import SwiftUI

public struct VegNonVegIndicator: View {
    private let isVegetarian: Bool
    private let size: CGFloat
    
    public init(isVegetarian: Bool, size: CGFloat = 16) {
        self.isVegetarian = isVegetarian
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 1)
                .stroke(isVegetarian ? Color.green : Color.red, lineWidth: 1)
                .frame(width: size, height: size)
            
            Circle()
                .fill(isVegetarian ? Color.green : Color.red)
                .frame(width: size/2, height: size/2)
        }
    }
}

// Preview Helpers
struct VegNonVegIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VegNonVegIndicator(isVegetarian: true)
                .padding()
            
            VegNonVegIndicator(isVegetarian: false)
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}