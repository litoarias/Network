import Foundation

public extension Endpoint {
    func toData(bundle: Bundle) -> Data? {
        guard let path = bundle.path(forResource: self.mockName, ofType: "json") else {
            return nil
        }
        return try? String(contentsOfFile: path).data(using: .utf8)
    }
}

