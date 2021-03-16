import Foundation

struct APIError: Codable {
    let status: String
    let code: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
    }
}

extension APIError {
    static let noConnectionError = APIError(
        status: "error",
        code: "noConnection",
        message: "Please connect to the Internet!"
    )

    static let invalidRequest = APIError(
        status: "error",
        code: "invalidRequest",
        message: "Invalid request!"
    )
}
