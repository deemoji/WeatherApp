import Foundation

enum BuildRequestError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingUrl = "URL is nil."
}
