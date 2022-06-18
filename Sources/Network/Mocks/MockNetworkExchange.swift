import Foundation

enum MockNetworkExchangeError: Error {
    case routeNotFound
}

/// The supported `HTTP` status codes to test for.
public enum SupportedStatusCode: Int {
  /// `OK`.
  case code200 = 200

  /// `Not Found`.
  case code404 = 404
}

public struct MockNetworkExchange {
    /// The `URLRequest` associated to the request.
    let urlRequest: URLRequest
    
    /// The mocked response inside of the exchange.
    let response: MockResponse
    
    /// The expected `HTTPURLResponse`.
    var urlResponse: HTTPURLResponse {
        HTTPURLResponse(
            url: urlRequest.url!,
            statusCode: response.statusCode.rawValue,
            httpVersion: response.httpVersion.rawValue,
            // Merges existing headers, if any, with the custom mock headers favoring the latter.
            headerFields: (urlRequest.allHTTPHeaderFields ?? [:]).merging(response.headers) { $1 }
        )!
    }
    
    public init(urlRequest: URLRequest, response: MockResponse) {
        self.urlRequest = urlRequest
        self.response = response
    }
}

extension MockNetworkExchange: Hashable {
    public static func == (lhs: MockNetworkExchange, rhs: MockNetworkExchange) -> Bool {
        return lhs.urlRequest == rhs.urlRequest
    }
    
    public func hash(into hasher: inout Hasher) {
        hashables.forEach { hasher.combine($0) }
    }
    
    var hashables: [AnyHashable] {
        Mirror(reflecting: self).children
            .compactMap { $0.value as? AnyHashable }
    }
}
