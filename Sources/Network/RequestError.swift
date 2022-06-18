import Foundation

public enum RequestError: Error {
    case decode
    case invalidURL(String)
    case noResponse
    case unauthorized
    case unexpectedStatusCode(Int)
    case unknown
}

/// Should be used to developer logs on debug, never for final clients
extension RequestError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .decode:
            return "Decoding data error."
        case let .invalidURL(path):
            return "The specified \(path) could not be found."
        case .noResponse:
            return "Empty response"
        case .unauthorized:
            return "Unauthorized operation."
        case let .unexpectedStatusCode(code):
            return "An unexpected \(code) status code error."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}

/// Should be used to inform user about the human problem, maybe this extension must
/// be out ot the Core of `Network` library
extension RequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decode:
            return NSLocalizedString(
                "",
                comment: "Invalid decode"
            )
        case .invalidURL:
            return NSLocalizedString(
                "",
                comment: "Invalid URL"
            )
        case .noResponse:
            return NSLocalizedString(
                "",
                comment: "Empty response"
            )
        case .unauthorized:
            return NSLocalizedString(
                "",
                comment: "Unauthorized operation."
            )
        case .unexpectedStatusCode:
            return NSLocalizedString(
                "",
                comment: "Invalid status code response"
            )
        case .unknown:
            return NSLocalizedString(
                "",
                comment: "An unexpected error."
            )
        }
    }
}
