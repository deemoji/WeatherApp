import Foundation

enum ResponceError: Error {
    case connectionError
    case badStatusCode(Int)
    case buildRequestError
}

extension ResponceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .connectionError:
            return NSLocalizedString("Network error. Please check for internet connection.", comment: "ResponceError")
        case .badStatusCode(let code):
            return NSLocalizedString("Network error. Connection has ended with bad status code: \(code).", comment: "ResponceError")
        case .buildRequestError:
            return NSLocalizedString("Network error. Internal error.", comment: "ResponceError")
        }
    }
}
