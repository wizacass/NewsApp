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
        self.author = article.author
        self.title = article.title
        self.description = article.description.htmlToString
        self.url = URL(string: article.url)
        self.imageUrl = URL(string: article.urlToImage)
        self.publishedAt = article.publishedAt.format(dateFormat)
        self.content = article.content
    }
}
