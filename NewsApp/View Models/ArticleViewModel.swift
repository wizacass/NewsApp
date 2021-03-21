import Foundation

struct ArticleViewModel {
    let author: String
    let title: String
    let description: String
    let url: URL?
    let imageUrl: URL?
    let publishedAt: String
    let content: String

    private let dateFormat = "yyyy-MM-dd"

    init(_ article: Article) {
        author = article.author
        title = article.title
        description = article.description.htmlToString
        url = URL(string: article.url)
        imageUrl = URL(string: article.urlToImage)
        publishedAt = article.publishedAt?.format(dateFormat) ?? ""
        content = article.content ?? article.description
    }
}
