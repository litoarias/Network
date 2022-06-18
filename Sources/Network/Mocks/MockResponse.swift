import Foundation

public struct MockResponse {
    /// The desired status code to expect from the request.
    let statusCode: SupportedStatusCode
    
    /// The desired http version to include in the response.
    let httpVersion: RequestMethod
    
    /// The expected response data, if any.
    let data: Data?
    
    /// Custom headers to add to the mocked response.
    let headers: [String: String]
    
    public init(statusCode: SupportedStatusCode,
                httpVersion: RequestMethod,
                data: Data?,
                headers: [String: String]) {
        self.statusCode = statusCode
        self.httpVersion = httpVersion
        self.data = data
        self.headers = headers
    }
}
