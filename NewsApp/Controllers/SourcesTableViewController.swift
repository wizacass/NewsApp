import UIKit

class SourcesTableViewController: UITableViewController {

    private var newsSources: [NewsSource] = []

    private weak var communicator: NewsCommunicator?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        communicator = appDelegate.communicator
        communicator?.retrieveSources(onComplete: handleRetrievedSources)
    }

    private func handleRetrievedSources(_ sources: NewsSources?, _ error: APIError?) {
        if let error = error {
            let alert = UIAlertController.fatalAlert(error.message)
            present(alert, animated: true)

            return
        }

        loadData(sources)
    }

    private func loadData(_ sources: NewsSources?) {
        guard let retrievedSources = sources?.sources else { return }

        newsSources = retrievedSources
        tableView.reloadData()
    }
}

// MARK: - Table view data source
extension SourcesTableViewController {

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return newsSources.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ViewIdentifiers.sourceCell.rawValue,
            for: indexPath
        )
        let source = newsSources[indexPath.row]

        cell.textLabel?.text = source.name
        cell.detailTextLabel?.text = source.sourceDescription

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let source = newsSources[indexPath.row]
        if let vc = storyboard?.instantiateViewController(
            identifier: ViewIdentifiers.articlesVC.rawValue
        ) as? ArticlesTableViewController {
            vc.source = source
            vc.communicator = communicator

            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
