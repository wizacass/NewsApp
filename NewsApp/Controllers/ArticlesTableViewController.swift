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
        return articles.totalResults
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        var cell: UITableViewCell!

        if indexPath.row < articles.count {
            cell = prepareArticleCell(indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: ViewIdentifiers.loadingCell.rawValue)
        }

        return cell
    }

    private func prepareArticleCell(_ indexPath: IndexPath) -> ArticleCell {
        let articleCell = tableView.dequeueReusableCell(
            withIdentifier: ViewIdentifiers.articleCell.rawValue,
            for: indexPath
        ) as? ArticleCell

        let article = getArticleViewModel(indexPath.row)
        articleCell?.article = article
        return articleCell!
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if indexPath.row >= articles.count { return }

        let article = getArticleViewModel(indexPath.row)

        if let vc = storyboard?.instantiateViewController(
            identifier: ViewIdentifiers.articleVC.rawValue
        ) as? ArticleViewController {
            vc.article = article

            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func getArticleViewModel(_ index: Int) -> ArticleViewModel {
        return ArticleViewModel(articles.article(at: index))
    }
}
