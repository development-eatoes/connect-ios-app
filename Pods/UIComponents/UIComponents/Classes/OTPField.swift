import SwiftUI

public struct OTPField: View {
    @Binding private var otpText: String
    private let codeLength: Int
    private let onCompleted: (String) -> Void
    
    @FocusState private var isFocused: Bool
    
    public init(
        otpText: Binding<String>,
        codeLength: Int = 4,
        onCompleted: @escaping (String) -> Void
    ) {
        self._otpText = otpText
        self.codeLength = codeLength
        self.onCompleted = onCompleted
    }
    
    public var body: some View {
        ZStack {
            // Fake text field to handle keyboard and focus
            TextField("", text: $otpText)
                .keyboardType(.numberPad)
                .frame(width: 0, height: 0, alignment: .center)
                .focused($isFocused)
                .opacity(0.001)
                .onChange(of: otpText) { newValue in
                    // Only allow digits
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered != newValue {
                        otpText = filtered
                    }
                    
                    // Limit to code length
                    if filtered.count > codeLength {
                        otpText = String(filtered.prefix(codeLength))
                    }
                    
                    // Check if completed
                    if filtered.count == codeLength {
                        onCompleted(filtered)
                    }
                }
            
            HStack(spacing: 12) {
                ForEach(0..<codeLength, id: \.self) { index in
                    OTPDigitView(digit: digitForIndex(index))
                        .onTapGesture {
                            isFocused = true
                        }
                }
            }
        }
        .onAppear {
            isFocused = true
        }
    }
    
    private func digitForIndex(_ index: Int) -> String {
        guard index < otpText.count else {
            return ""
        }
        
        let stringIndex = otpText.index(otpText.startIndex, offsetBy: index)
        return String(otpText[stringIndex])
    }
}

private struct OTPDigitView: View {
    let digit: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
                .frame(width: 50, height: 60)
            
            if digit.isEmpty {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(width: 50, height: 60)
            } else {
                Text(digit)
                    .font(.title)
                    .foregroundColor(.primary)
            }
        }
    }
}

// Preview Helpers
struct OTPField_Previews: PreviewProvider {
    static var previews: some View {
        OTPField(otpText: .constant("123"), onCompleted: { _ in })
            .padding()
            .previewLayout(.sizeThatFits)
    }
}