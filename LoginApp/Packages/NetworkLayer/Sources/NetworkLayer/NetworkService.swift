import Foundation
import Combine

public class NetworkService {
    private let baseURL: String
    private let session: URLSession
    
    public init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    public func request<T: Decodable>(_ endpoint: ApiEndpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: "\(baseURL)\(endpoint.path)") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add headers
        endpoint.headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // Add body if needed
        if let body = endpoint.body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return Fail(error: NetworkError.encodingFailed).eraseToAnyPublisher()
            }
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.httpError(statusCode: httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is DecodingError {
                    return NetworkError.decodingFailed
                } else {
                    return NetworkError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
