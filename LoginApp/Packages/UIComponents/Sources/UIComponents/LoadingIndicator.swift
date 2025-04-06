import SwiftUI

public struct LoadingIndicator: View {
    private let color: Color
    private let size: CGFloat
    
    public init(color: Color = .blue, size: CGFloat = 40) {
        self.color = color
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: 3)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(color, lineWidth: 3)
                .frame(width: size, height: size)
                .rotationEffect(Angle(degrees: 360))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: UUID())
        }
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}
