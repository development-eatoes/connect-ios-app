import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed
    case encodingFailed
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingFailed:
            return "Failed to decode response"
        case .encodingFailed:
            return "Failed to encode request"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}