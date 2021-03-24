import UIKit

class ArticlesTableViewController: UITableViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!

    var source: NewsSource?

    weak var communicator: NewsCommunicator?

    private var pageSize = 10
    private var articles: ArticlesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.title = "Loading..."

        articles = ArticlesViewModel(communicator!, source!, pageSize)
        articles.loadNext(onComplete: handleRetrievedArticles)
    }

    private func handleRetrievedArticles(_ error: APIError?) {
        if let error = error {
            showErrorAlert(error.message)
            return
        }

        tableView.reloadData()
        navigationBar.title = source?.name
    }

    func showErrorAlert(_ message: String?) {
        let alert = UIAlertController(
            title: "Error!",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Close",
                style: .destructive,
                handler: { _ in exit(-1) }
            )
        )

        present(alert, animated: true)
    }
}

// MARK: - Table view data source
extension ArticlesTableViewController {
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return articles.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        return prepareArticleCell(indexPath)
    }

    private func prepareArticleCell(_ indexPath: IndexPath) -> ArticleCell {
        let articleCell = tableView.dequeueReusableCell(
            withIdentifier: ViewIdentifiers.articleCell.rawValue,
            for: indexPath
        ) as? ArticleCell

        articleCell?.article = getArticleViewModel(indexPath.row)

        return articleCell!
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if indexPath.row >= articles.count { return }

        if let vc = storyboard?.instantiateViewController(
            identifier: ViewIdentifiers.articleVC.rawValue
        ) as? ArticleViewController {
            vc.article = getArticleViewModel(indexPath.row)

            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func getArticleViewModel(_ index: Int) -> ArticleViewModel {
        return ArticleViewModel(articles.article(at: index))
    }

    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if shouldUpdate(indexPath.row) {
            articles.loadNext(onComplete: handleRetrievedArticles)
        }
    }

    private func shouldUpdate(_ index: Int) -> Bool {
        return index + 1 == articles.count && articles.count < articles.totalResults
    }
}
