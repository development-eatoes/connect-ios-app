import Foundation

public struct ApiEndpoint {
    public let path: String
    public let method: HttpMethod
    public let headers: [String: String]
    public let body: [String: Any]?
    
    public init(
        path: String,
        method: HttpMethod = .get,
        headers: [String: String] = [:],
        body: [String: Any]? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
    }
}
