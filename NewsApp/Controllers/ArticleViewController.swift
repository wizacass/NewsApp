import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    var article: ArticleViewModel?

    private let dateFormat = "yyyy-MM-dd"

    override func viewDidLoad() {
        super.viewDidLoad()

        displayArticle()
    }

    private func displayArticle() {
        titleLabel.text = article?.title
        imageView.downloadImage(article?.imageUrl)
        dateLabel.text = "Published at: \(article?.publishedAt ?? "")"
        contentLabel.text = article?.description.htmlToString
    }

    @IBAction func articleButtonPressed(_ sender: UIButton) {
        if let url = article?.url {
            UIApplication.shared.open(url)
        }
    }
}
