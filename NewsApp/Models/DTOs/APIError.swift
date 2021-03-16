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
