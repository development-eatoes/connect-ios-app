import Foundation
import Combine

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
    case invalidRequest
    case invalidResponse
    case requestFailed(statusCode: Int, data: Data?)
    case decodingFailed
    case noInternet
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        case .invalidResponse:
            return "Invalid response from server"
        case .requestFailed(let statusCode, _):
            return "Request failed with status code: \(statusCode)"
        case .decodingFailed:
            return "Failed to decode response"
        case .noInternet:
            return "No internet connection"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, Error>
}

// MARK: - Network Service Implementation
class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder
    
    init(baseURL: URL, 
         session: URLSession = .shared, 
         decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        
        // Configure decoder date strategy if needed
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func request<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, Error> {
        guard let request = createRequest(from: endpoint) else {
            return Fail(error: NetworkError.invalidRequest)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { [weak self] result -> Data in
                guard let self = self else { throw NetworkError.unknown }
                
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw NetworkError.requestFailed(statusCode: httpResponse.statusCode, data: result.data)
                }
                
                return result.data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is DecodingError {
                    return NetworkError.decodingFailed
                } else {
                    return NetworkError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func createRequest(from endpoint: Endpoint) -> URLRequest? {
        guard var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        // Add query parameters if any
        if !endpoint.queryParameters.isEmpty {
            urlComponents.queryItems = endpoint.queryParameters.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for (key, value) in endpoint.headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // Add auth token if present
        if let token = endpoint.authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add body if present
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return request
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// MARK: - Endpoint
struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let queryParameters: [String: Any]
    let body: [String: Any]?
    let authToken: String?
    
    init(
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        queryParameters: [String: Any] = [:],
        body: [String: Any]? = nil,
        authToken: String? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = body
        self.authToken = authToken
    }
}