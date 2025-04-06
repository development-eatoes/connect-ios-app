import Foundation
import Combine

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
}

public protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(from endpoint: String, method: HTTPMethod, parameters: [String: Any]?) -> AnyPublisher<T, NetworkError>
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    private let session: URLSession
    
    public init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    public func fetch<T: Decodable>(from endpoint: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let parameters = parameters {
            if method == .get {
                // Add query parameters for GET requests
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
                components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.url = components.url
            } else {
                // Add JSON body for other requests
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    return Fail(error: NetworkError.unknown(error)).eraseToAnyPublisher()
                }
            }
        }
        
        return session.dataTaskPublisher(for: request)
            .mapError { NetworkError.unknown($0) }
            .flatMap { data, response -> AnyPublisher<T, NetworkError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    return Fail(error: NetworkError.httpError(statusCode: httpResponse.statusCode)).eraseToAnyPublisher()
                }
                
                let decoder = JSONDecoder()
                
                return Just(data)
                    .decode(type: T.self, decoder: decoder)
                    .mapError { NetworkError.decodingError($0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}