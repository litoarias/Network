import Foundation

@available(iOS 13.0.0, *)
public protocol HTTPClient {
    var session: URLSession { get }
    func request<E: Endpoint, C: Codable>(endpoint: E, responseModel: C.Type) async -> Result<C, RequestError>
}

@available(iOS 13.0.0, *)
public extension HTTPClient {
    var session: URLSession {
        URLSession.shared
    }

    
    /// Returns a generic Result response as an `async` way, can be returns a
    /// `RequestError`.
    ///
    /// The URL will be automated constructed by data provided on `Endpoint`
    /// parameters, take in account that the url like
    /// `https://api.github.com/search/repositories?q=some_thing` for any GET
    ///  requests should be formed adding `queryItems` property on `Endpoint`.
    ///
    /// - Parameters:
    ///   - endpoint: full data of endpoint of type `Endpoint`.
    ///   - responseModel: `Type` of `Codable` object to handle
    func request<E: Endpoint, C: Codable>(endpoint: E, responseModel: C.Type) async -> Result<C, RequestError> {
        
        guard let request = buildRequest(with: endpoint) else {
            return .failure(.invalidURL(endpoint.path))
        }
        
        do {
            let (data, response): (Data, URLResponse)
            if #available(iOS 15.0, *) {
                (data, response) = try await session.data(for: request, delegate: nil)
            } else {
                (data, response) = try await session.data(from: request)
            }
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
        
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode(response.statusCode))
            }
        } catch {
            return .failure(.unknown)
        }
    }
}

@available(iOS 13.0.0, *)
private extension HTTPClient {
    func buildRequest<E: Endpoint>(with endpoint: E) -> URLRequest? {
        guard let url = endpoint.constructor() else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        return request
    }
}
