import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sourcesLabel: UILabel!

    private weak var communicator: NewsCommunicator?

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        communicator = appDelegate.communicator
    }

    @IBAction func sourcesButtonPressed(_ sender: UIButton) {
        sourcesLabel.text = "Retrieving sources..."
        sourcesLabel.isHidden = false
    }
}
