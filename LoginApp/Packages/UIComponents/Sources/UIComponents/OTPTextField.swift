import SwiftUI
import Combine

public struct OTPTextField: View {
    @Binding private var otp: String
    private let otpLength: Int
    
    public init(otp: Binding<String>, otpLength: Int = 6) {
        self._otp = otp
        self.otpLength = otpLength
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<otpLength, id: \.self) { index in
                OTPDigitField(
                    value: digitBindingForIndex(index),
                    isFocused: index == min(otp.count, otpLength - 1)
                )
            }
        }
    }
    
    private func digitBindingForIndex(_ index: Int) -> Binding<String> {
        return Binding<String>(
            get: {
                guard index < otp.count else { return "" }
                return String(otp[otp.index(otp.startIndex, offsetBy: index)])
            },
            set: { newValue in
                var updatedOTP = otp
                
                // Ensure we're only accepting single digits
                let singleDigit = newValue.filter { $0.isNumber }.prefix(1)
                
                if singleDigit.isEmpty {
                    // Handle backspace/delete
                    if index < updatedOTP.count {
                        let startIndex = updatedOTP.index(updatedOTP.startIndex, offsetBy: index)
                        let endIndex = updatedOTP.index(after: startIndex)
                        updatedOTP.removeSubrange(startIndex..<endIndex)
                    }
                } else {
                    // Add or replace the digit
                    if index < updatedOTP.count {
                        let digitIndex = updatedOTP.index(updatedOTP.startIndex, offsetBy: index)
                        updatedOTP.replaceSubrange(digitIndex...digitIndex, with: singleDigit)
                    } else if index == updatedOTP.count {
                        updatedOTP.append(contentsOf: singleDigit)
                    }
                }
                
                otp = updatedOTP
            }
        )
    }
}

private struct OTPDigitField: View {
    @Binding var value: String
    var isFocused: Bool
    
    @State private var isActive = false
    @FocusState private var fieldFocus: Bool
    
    var body: some View {
        TextField("", text: $value)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .frame(width: 50, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? Theme.primaryColor : Color.gray, lineWidth: 2)
            )
            .onChange(of: isFocused) { focused in
                fieldFocus = focused
            }
            .focused($fieldFocus)
    }
}
