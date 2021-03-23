import Foundation

class ArticlesViewModel {

    var count: Int {
        return allArticles.count
    }

    var totalResults: Int {
        return totalArticles
    }

    private var itemsPerPage: Int
    private var communicator: NewsCommunicator
    private var source: NewsSource

    private var currentPage = 1
    private var totalArticles: Int = 0
    private var allArticles: [Article] = []
    private var isFetching: Bool = false

    init(
        _ communicator: NewsCommunicator,
        _ source: NewsSource,
        _ itemsPerPage: Int
    ) {
        self.communicator = communicator
        self.source = source
        self.itemsPerPage = itemsPerPage
    }

    func article(at index: Int) -> Article {
        return allArticles[index]
    }
}

// MARK: - Data fetching
extension ArticlesViewModel {
    func loadAll(onComplete: @escaping (APIError?) -> Void) {
        if isFetching { return }

        isFetching = true

        let parameters: [String: Any] = [
            "sources": source.id
        ]

        communicator.retrieveArticles(parameters) { [weak self] articles, error in
            guard let articles = articles else {
                DispatchQueue.main.async { onComplete(error) }
                return
            }

            self?.allArticles = articles.articles
            self?.totalArticles = articles.totalResults
            self?.currentPage = 1
            self?.isFetching = false

            DispatchQueue.main.async { onComplete(nil) }
        }
    }

    func loadNext(onComplete: @escaping (APIError?) -> Void) {
        if isFetching { return }

        isFetching = true

        let parameters: [String: Any] = [
            "sources": source.id,
            "pageSize": itemsPerPage,
            "page": currentPage
        ]

        communicator.retrieveArticles(parameters) { [weak self] articles, error in
            guard let articles = articles else {
                DispatchQueue.main.async { onComplete(error) }
                return
            }

            self?.allArticles.append(contentsOf: articles.articles)
            self?.totalArticles = articles.totalResults
            self?.currentPage += 1
            self?.isFetching = false

            DispatchQueue.main.async { onComplete(nil) }
        }
    }
}
