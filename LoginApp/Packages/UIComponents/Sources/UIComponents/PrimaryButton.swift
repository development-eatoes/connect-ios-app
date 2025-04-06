import SwiftUI

public struct PrimaryButton: View {
    private let title: String
    private let isLoading: Bool
    private let action: () -> Void
    
    public init(title: String, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(isLoading ? 0 : 1)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Theme.primaryColor)
            .cornerRadius(10)
            .disabled(isLoading)
        }
        .disabled(isLoading)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButton(title: "Login", action: {})
            PrimaryButton(title: "Loading", isLoading: true, action: {})
        }
        .padding()
    }
}
