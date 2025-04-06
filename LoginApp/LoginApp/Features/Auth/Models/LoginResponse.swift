import Foundation

struct LoginResponse: Decodable {
    let success: Bool
    let message: String
    let sessionId: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case sessionId = "session_id"
    }
}
