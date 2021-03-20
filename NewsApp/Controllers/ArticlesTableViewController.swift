import UIKit

class ArticlesTableViewController: UITableViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!

    var source: NewsSource?

    weak var communicator: NewsCommunicator?

    private var articles: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.title = source?.name

        communicator?.retrieveArticles(source?.id ?? "", onComplete: handleRetrievedArticles)
    }

    private func handleRetrievedArticles(_ articles: Articles?, _ error: APIError?) {
        if let error = error {
            showErrorAlert(error.message)
            return
        }

        loadData(articles)
    }

    private func loadData(_ articles: Articles?) {
        guard let retrievedSArticles = articles?.articles else { return }

        self.articles = retrievedSArticles
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ViewIdentifiers.articleCell.rawValue,
            for: indexPath
        ) as? ArticleCell

        let article = ArticleViewModel(articles[indexPath.row])
        cell?.article = article
        
        return cell!
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let article = ArticleViewModel(articles[indexPath.row])
        if let vc = storyboard?.instantiateViewController(
            identifier: ViewIdentifiers.articleVC.rawValue
        ) as? ArticleViewController {
            vc.article = article

            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
