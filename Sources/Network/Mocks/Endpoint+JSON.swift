import Foundation

public extension Endpoint {
    func toData(bundle: Bundle) -> Data? {
        let resource = self.path.replacingOccurrences(of: "/", with: "_")
        guard let path = bundle.path(forResource: resource, ofType: "json") else {
            return nil
        }
        return try? String(contentsOfFile: path).data(using: .utf8)
    }
}

