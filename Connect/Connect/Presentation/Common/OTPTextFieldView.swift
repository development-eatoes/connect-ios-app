import SwiftUI
import Combine

struct OTPTextFieldView: View {
    @Binding var otp: String
    let numberOfFields: Int
    let errorMessage: String?
    
    @State private var individualTexts: [String]
    @FocusState private var focusedField: Int?
    
    init(otp: Binding<String>, numberOfFields: Int = 6, errorMessage: String? = nil) {
        self._otp = otp
        self.numberOfFields = numberOfFields
        self.errorMessage = errorMessage
        self._individualTexts = State(initialValue: Array(repeating: "", count: numberOfFields))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ForEach(0..<numberOfFields, id: \.self) { index in
                    TextField("", text: $individualTexts[index])
                        .keyboardType(.numberPad)
                        .frame(width: 45, height: 50)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .focused($focusedField, equals: index)
                        .onChange(of: individualTexts[index]) { newValue in
                            limitText(index)
                            updateOTP()
                            handleTextField(index)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(errorMessage != nil ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            // Set initial values from OTP string
            if !otp.isEmpty {
                let otpArr = Array(otp)
                for i in 0..<min(otpArr.count, numberOfFields) {
                    individualTexts[i] = String(otpArr[i])
                }
            }
            // Set focus to first field if OTP is empty
            if otp.isEmpty {
                focusedField = 0
            }
        }
    }
    
    private func limitText(_ index: Int) {
        if individualTexts[index].count > 1 {
            individualTexts[index] = String(individualTexts[index].prefix(1))
        }
    }
    
    private func handleTextField(_ index: Int) {
        // Move to next field if current field is filled
        if !individualTexts[index].isEmpty && index < numberOfFields - 1 {
            focusedField = index + 1
        }
        
        // Move to previous field if current field is cleared
        if individualTexts[index].isEmpty && index > 0 {
            focusedField = index - 1
        }
    }
    
    private func updateOTP() {
        otp = individualTexts.joined()
    }
}