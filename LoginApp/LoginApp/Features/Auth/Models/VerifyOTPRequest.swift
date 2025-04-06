import Foundation

struct VerifyOTPRequest: Encodable {
    let sessionId: String
    let otp: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case otp
    }
}
