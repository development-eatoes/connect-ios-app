import SwiftUI
import Combine

struct OTPField: View {
    @Binding var otp: String
    @State private var focusedField: Int = 0
    let otpLength: Int
    var errorMessage: String?
    
    // Array of one-character strings for each digit
    private var otpDigits: [String] {
        let characters = Array(otp)
        var result = [String](repeating: "", count: otpLength)
        
        for (index, char) in characters.prefix(otpLength).enumerated() {
            result[index] = String(char)
        }
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ForEach(0..<otpLength, id: \.self) { index in
                    OTPDigitField(
                        text: otpDigits[index],
                        isFocused: focusedField == index,
                        onTap: { focusedField = index }
                    )
                }
            }
            
            // Hidden text field to capture input
            TextField("", text: $otp)
                .keyboardType(.numberPad)
                .frame(width: 0, height: 0)
                .opacity(0)
                .onReceive(Just(otp)) { newValue in
                    // Only allow up to otpLength digits
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        otp = filtered
                    }
                    
                    // Limit to otpLength characters
                    if filtered.count > otpLength {
                        otp = String(filtered.prefix(otpLength))
                    }
                    
                    // Update focus position
                    if !otp.isEmpty {
                        focusedField = min(otp.count, otpLength - 1)
                    }
                }
            
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
    }
}

struct OTPDigitField: View {
    let text: String
    let isFocused: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? Color.blue : Color.gray, lineWidth: 1)
                .background(Color(.systemGray6).cornerRadius(8))
                .frame(width: 50, height: 60)
            
            Text(text)
                .font(.title)
                .foregroundColor(.primary)
        }
        .onTapGesture {
            onTap()
        }
    }
}