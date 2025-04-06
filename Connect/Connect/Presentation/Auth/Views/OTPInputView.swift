import SwiftUI
import Combine

struct OTPInputView: View {
    @Binding var otpString: String
    let otpCount: Int
    
    init(otpString: Binding<String>, otpCount: Int = 6) {
        self._otpString = otpString
        self.otpCount = otpCount
    }
    
    // Focus control
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<otpCount, id: \.self) { index in
                OTPDigitBox(digit: index < otpString.count ? String(otpString[otpString.index(otpString.startIndex, offsetBy: index)]) : "")
            }
        }
        .overlay(
            TextField("", text: $otpString)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .opacity(0.001)  // Almost invisible but still functional
                .onReceive(Just(otpString)) { _ in
                    validateOTP()
                }
        )
        .onTapGesture {
            isFocused = true
        }
    }
    
    private func validateOTP() {
        // Limit to otpCount digits and only allow numbers
        let filtered = otpString.filter { "0123456789".contains($0) }
        
        if filtered.count > otpCount {
            otpString = String(filtered.prefix(otpCount))
        } else if filtered != otpString {
            otpString = filtered
        }
    }
}

struct OTPDigitBox: View {
    let digit: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                .background(Color.white)
            
            if !digit.isEmpty {
                Text(digit)
                    .font(.title)
                    .foregroundColor(.primary)
            }
        }
        .frame(width: 50, height: 60)
    }
}

#if DEBUG
struct OTPInputView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var otp = "123"
        
        var body: some View {
            VStack {
                OTPInputView(otpString: $otp)
                
                Text("Current OTP: \(otp)")
                    .padding(.top, 20)
            }
            .padding()
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
#endif