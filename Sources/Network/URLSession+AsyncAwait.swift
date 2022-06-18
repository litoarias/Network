import Foundation

@available(iOS 13.0.0, *)
extension URLSession {
    /// Although we can use Swift's concurrency system with earlier versions
    /// of the operating systems, Apple did not provide any async APIs for
    /// its SDKs.
    ///
    /// Those are available only for the latest version of the SDKs. So, for
    /// example, we cannot use async methods for URLSession. Fortunately, we can
    /// quite easily write such method ourself
    ///
    /// - Parameters:
    ///   - url: URLRequest to use in this bridge.
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func data(from url: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
}
