import UIKit

class ArticlesTableViewController: UITableViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!

    var source: NewsSource?

    weak var communicator: NewsCommunicator?

    private var pageSize = 10
    private var viewModel: ArticlesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.title = source?.name

        viewModel = ArticlesViewModel(communicator!, source!, pageSize)
        viewModel.loadNext(onComplete: handleRetrievedArticles)
    }

    private func handleRetrievedArticles(_ error: APIError?) {
        if let error = error {
            showErrorAlert(error.message)
            return
        }

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
        return viewModel.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ViewIdentifiers.articleCell.rawValue,
            for: indexPath
        ) as? ArticleCell

        let article = getArticleViewModel(indexPath.row)
        cell?.article = article

        return cell!
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let article = getArticleViewModel(indexPath.row)

        if let vc = storyboard?.instantiateViewController(
            identifier: ViewIdentifiers.articleVC.rawValue
        ) as? ArticleViewController {
            vc.article = article

            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func getArticleViewModel(_ index: Int) -> ArticleViewModel {
        return ArticleViewModel(viewModel.article(at: index))
    }
}
