import Foundation

struct NewsSources: Codable {
    let status: String
    let sources: [NewsSource]?

    enum CodingKeys: String, CodingKey {
        case status
        case sources
    }
}
