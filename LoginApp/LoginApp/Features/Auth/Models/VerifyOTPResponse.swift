import Foundation

struct VerifyOTPResponse: Decodable {
    let success: Bool
    let message: String
    let token: String?
    let user: User?
    
    struct User: Decodable {
        let id: String
        let phoneNumber: String
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case phoneNumber = "phone_number"
            case name
        }
    }
}
