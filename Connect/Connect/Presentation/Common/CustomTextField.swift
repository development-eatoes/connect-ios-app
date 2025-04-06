import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    var errorMessage: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                }
                
                if isSecure {
                    SecureField("", text: $text)
                        .keyboardType(keyboardType)
                } else {
                    TextField("", text: $text)
                        .keyboardType(keyboardType)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(errorMessage == nil ? Color.gray.opacity(0.3) : Color.red, lineWidth: 1)
            )
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
    }
}

#if DEBUG
struct CustomTextField_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var text1 = ""
        @State private var text2 = "Sample input"
        @State private var text3 = ""
        
        var body: some View {
            VStack(spacing: 20) {
                CustomTextField(placeholder: "Phone number", text: $text1, keyboardType: .phonePad)
                
                CustomTextField(placeholder: "Email", text: $text2, keyboardType: .emailAddress)
                
                CustomTextField(
                    placeholder: "Password",
                    text: $text3,
                    isSecure: true,
                    errorMessage: "Password must be at least 8 characters"
                )
            }
            .padding()
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
#endif