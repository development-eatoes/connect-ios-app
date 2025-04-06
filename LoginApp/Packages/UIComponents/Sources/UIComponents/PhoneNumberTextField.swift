import SwiftUI
import Combine

public struct PhoneNumberTextField: View {
    @Binding private var phoneNumber: String
    private let placeholder: String
    private let keyboardType: UIKeyboardType
    private let formatter: TextFieldFormatter
    
    public init(
        phoneNumber: Binding<String>,
        placeholder: String = "Enter phone number",
        keyboardType: UIKeyboardType = .phonePad
    ) {
        self._phoneNumber = phoneNumber
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.formatter = TextFieldFormatter(maxLength: 10, allowedCharacters: .decimalDigits)
    }
    
    public var body: some View {
        TextField(placeholder, text: $phoneNumber)
            .keyboardType(keyboardType)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .onChange(of: phoneNumber) { newValue in
                phoneNumber = formatter.format(newValue)
            }
    }
}

private class TextFieldFormatter {
    private let maxLength: Int
    private let allowedCharacters: CharacterSet
    
    init(maxLength: Int, allowedCharacters: CharacterSet) {
        self.maxLength = maxLength
        self.allowedCharacters = allowedCharacters
    }
    
    func format(_ text: String) -> String {
        let filtered = text.filter { 
            guard let unicodeScalar = String($0).unicodeScalars.first else { return false }
            return allowedCharacters.contains(unicodeScalar)
        }
        
        let prefix = filtered.prefix(maxLength)
        return String(prefix)
    }
}
