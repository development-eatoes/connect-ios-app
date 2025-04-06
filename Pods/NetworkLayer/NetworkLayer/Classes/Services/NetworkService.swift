import Foundation
import Combine

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError
    case serverError(String)
    case unknownError
}

public protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(from endpoint: String, method: HTTPMethod, parameters: [String: Any]?) -> AnyPublisher<T, NetworkError>
    func fetch<T: Decodable>(from endpoint: String, method: HTTPMethod) -> AnyPublisher<T, NetworkError>
}

public class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    private let session: URLSession
    private var authToken: String?
    
    public init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    public func setAuthToken(_ token: String?) {
        self.authToken = token
    }
    
    public func fetch<T: Decodable>(from endpoint: String, method: HTTPMethod) -> AnyPublisher<T, NetworkError> {
        return fetch(from: endpoint, method: method, parameters: nil)
    }
    
    public func fetch<T: Decodable>(from endpoint: String, method: HTTPMethod, parameters: [String: Any]? = nil) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
            }
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                if httpResponse.statusCode >= 400 {
                    throw NetworkError.httpError(httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is DecodingError {
                    return NetworkError.decodingError
                } else {
                    return NetworkError.unknownError
                }
            }
            .eraseToAnyPublisher()
    }
}