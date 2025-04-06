import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    let isDisabled: Bool
    
    init(
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
    
    var body: some View {
        Button(action: {
            if !isLoading && !isDisabled {
                action()
            }
        }) {
            ZStack {
                // Button background
                RoundedRectangle(cornerRadius: 10)
                    .fill(isDisabled ? Color.gray.opacity(0.3) : Color.blue)
                
                // Content
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.0)
                } else {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                }
            }
        }
        .disabled(isLoading || isDisabled)
        .frame(maxWidth: .infinity, minHeight: 50)
    }
}

#if DEBUG
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            PrimaryButton(title: "Continue") {
                print("Button tapped")
            }
            
            PrimaryButton(title: "Loading", isLoading: true) {
                print("Button tapped")
            }
            
            PrimaryButton(title: "Disabled", isDisabled: true) {
                print("Button tapped")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif