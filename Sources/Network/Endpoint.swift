import Foundation

/// The Endpoint protocol has a default implementation of
/// baseURL as it is normally just one for all endpoints; therefore,
/// it is not necessary to implement it all the time.
///
/// - Properties:
///     - baseURL: default implementation of `baseURL`
///     - path: will be used as a complement to the baseURL to form the endpoint
///      URL. It works like this: `baseURL + path`. For instance: suppose the
///       endpoint URL is https://api.example.org/cinema/movie/top_rated, then the
///       path should be `cinema/movie/top_rated`.
///     - method: The type of the method variable is `RequestMethod`
///       and represents the `HTTP` methods of the endpoint, which can be: GET,
///       POST, PUT, DELETE, PATCH, HEAD, etc..
///     - header: The variable should return a `dictionary`
///       with all the header information that the endpoint documentation
///       asks for, when needed. This is usually where authentication is
///       performed through Authorization.
///     - body: Like the `header` variable, when necessary, the
///       `body` is also a dictionary that must contain the body
///       information that the endpoint documentation asks to be sent.
///  
///  - Note: No notes.
public protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: [String: String]? { get }
    var method: RequestMethod { get }
    
    func constructor() -> URL?
}

public extension Endpoint {
    /// Overriden for default
    var scheme: String {
        "https"
    }

    /// Returns a URL composed by `URLComponents` properties from `Self`
    func constructor() -> URL? {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        components.queryItems = self.queryItems
        return components.url
    }
}
