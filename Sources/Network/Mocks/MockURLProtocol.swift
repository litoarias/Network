import Foundation

public class MockURLProtocol: URLProtocol {
    public static var mockRequests: Set<MockNetworkExchange> = []
    static var shouldCheckQueryParameters = false
    static var simulatedDelay = 2
    
    public override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    public override func stopLoading() {}
    
    public override func startLoading() {
        defer {
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Self.simulatedDelay)) { [unowned self] in
                client?.urlProtocolDidFinishLoading(self)
            }
        }
        let foundRequest = Self.mockRequests.first { [unowned self] in
            request.url?.path == $0.urlRequest.url?.path &&
            request.httpMethod == $0.urlRequest.httpMethod &&
            (Self.shouldCheckQueryParameters ? request.url?.query == $0.urlRequest.url?.query : true)
        }
        
        guard let mockExchange = foundRequest else {
            client?.urlProtocol(self, didFailWithError: MockNetworkExchangeError.routeNotFound)
            return
        }
        
        if let data = mockExchange.response.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocol(self,
                            didReceive: mockExchange.urlResponse,
                            cacheStoragePolicy: .notAllowed)
        
    }
}
