import SwiftUI

public struct StyledTextField: View {
    private let placeholder: String
    private let keyboardType: UIKeyboardType
    @Binding private var text: String
    private let onSubmit: (() -> Void)?
    
    public init(
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        onSubmit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .submitLabel(.done)
            .onSubmit {
                onSubmit?()
            }
    }
}

// Preview Helpers
struct StyledTextField_Previews: PreviewProvider {
    static var previews: some View {
        StyledTextField(placeholder: "Enter text", text: .constant(""))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}