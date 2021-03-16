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
            showErrorAlert(error.message)
            return
        }

        loadData(sources)
    }

    private func loadData(_ sources: NewsSources?) {
        guard let retrievedSources = sources?.sources else { return }

        newsSources = retrievedSources
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath)
        let source = newsSources[indexPath.row]

        cell.textLabel?.text = source.name
        cell.detailTextLabel?.text = source.sourceDescription

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let source = newsSources[indexPath.row]
        if let vc = storyboard?.instantiateViewController(identifier: "ArticlesVC") as? ArticlesTableViewController {
            vc.source = source

            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
