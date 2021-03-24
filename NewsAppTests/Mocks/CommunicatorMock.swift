import Foundation
@testable import NewsApp

class CommunicatorMock: NewsCommunicator {

    private let allSources = [
        NewsSource(id: "test-1", name: "News Source 1", country: "us"),
        NewsSource(id: "test-2", name: "News Source 2", country: "us"),
        NewsSource(id: "test-3", name: "News Source 3", country: "lt")
    ]

    private let invalidParametersError = APIError(
        status: "error",
        code: "invalidParameters",
        message: ""
    )

    private let missingError = APIError(
        status: "error",
        code: "parametersMissing",
        message: ""
    )

    private var allArticles: [Article] = []

    init() {
        super.init(ApiClientMock())

        populateArticles()
    }

    private func populateArticles() {
        for i in 1...10 {
            allArticles.append(Article(
                source: allSources[0],
                author: "Author \(i)",
                title: "Clickbait \(i)",
                description: "Lorem Ipsum",
                url: "https://localhost",
                urlToImage: "https://localhost",
                publishedAt: Date.init(timeIntervalSinceNow: 0),
                content: "Lorem Ipsum"
            ))
        }

        for i in 1..<3 {
            allArticles.append(Article(
                source: allSources[2],
                author: "Author \(i)",
                title: "News \(i)",
                description: "Lorem Ipsum",
                url: "https://localhost",
                urlToImage: "https://localhost",
                publishedAt: Date.init(timeIntervalSinceNow: 0),
                content: "Lorem Ipsum"
            ))
        }
    }

    override func retrieveSources(onComplete handleResponse: @escaping ApiData<NewsSources?>) {
        let newsSources = NewsSources(status: "ok", sources: allSources)
        DispatchQueue.main.async {
            handleResponse(newsSources, nil)
        }
    }

    override func retrieveArticles(
        _ parameters: [String: Any],
        onComplete handleResponse: @escaping ApiData<Articles?>
    ) {
        guard let source = parameters["sources"] as? String else {
            DispatchQueue.main.async {
                handleResponse(nil, self.invalidParametersError)
            }

            return
        }

        if allSources.map({$0.id}).contains(source) {
            let articles = prepareArticles(
                source,
                parameters["page"] as? Int,
                parameters["pageSize"] as? Int
            )

            DispatchQueue.main.async {
                handleResponse(articles, nil)
            }
        } else {
            DispatchQueue.main.async {
                handleResponse(nil, self.missingError)
            }
        }
    }

    private func prepareArticles(_ source: String, _ page: Int?, _ pageSize: Int?) -> Articles {
        var articles = allArticles.filter({$0.source.id == source})
        let count = articles.count

        if let page = page, let pageSize = pageSize {
            let from = (page - 1) * pageSize
            let to = min(from + pageSize, articles.count)
            articles = Array(articles[from ..< to])
        }

        return Articles(
            status: "ok",
            totalResults: count,
            articles: articles
        )
    }
}
