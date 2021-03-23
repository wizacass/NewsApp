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

    init(
        id: String,
        name: String,
        sourceDescription: String? = nil,
        url: String? = nil,
        category: String? = nil,
        language: String? = nil,
        country: String? = nil
    ) {
        self.id = id
        self.name = name
        self.sourceDescription = sourceDescription
        self.url = url
        self.category = category
        self.language = language
        self.country = country
    }
}
