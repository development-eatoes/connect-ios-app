import SwiftUI

public struct PrimaryButton: View {
    private let title: String
    private let action: () -> Void
    private let isLoading: Bool
    private let isDisabled: Bool
    
    public init(
        title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            if !isLoading && !isDisabled {
                action()
            }
        }) {
            ZStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(isLoading ? 0 : 1)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDisabled ? Color.gray.opacity(0.3) : Color.blue)
            .cornerRadius(10)
        }
        .disabled(isLoading || isDisabled)
    }
}