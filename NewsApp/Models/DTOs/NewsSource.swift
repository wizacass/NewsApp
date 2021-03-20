import Foundation

struct NewsSource: Codable {
    let id: String
    let name: String
    let sourceDescription: String?
    let url: String?
    let category: String?
    let language: String?
    let country: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sourceDescription = "description"
        case url
        case category
        case language
        case country
    }
}
