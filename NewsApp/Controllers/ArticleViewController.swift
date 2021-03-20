import UIKit
import SDWebImage

class ArticleViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var article: Article?

    private let dateFormat = "yyyy-MM-dd"

    override func viewDidLoad() {
        super.viewDidLoad()

        displayArticle()
    }

    private func displayArticle() {
        titleLabel.text = article?.title
        dateLabel.text = "Published at: \(formatDate())"
        descriptionLabel.text = article?.description.htmlToString

        loadImage()
    }

    private func loadImage() {
        guard let urlString = article?.urlToImage else { return }

        imageView.sd_setImage(
            with: URL(string: urlString)!,
            placeholderImage: UIImage(named: "xmark.square")
        )
    }

    private func formatDate() -> String {
        guard let date = article?.publishedAt else { return "" }

        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat

        return formatter.string(from: date)
    }

    @IBAction func articleButtonPressed(_ sender: UIButton) {
        guard let articleUrl = article?.url else { return }
        if let url = URL(string: articleUrl) {
            UIApplication.shared.open(url)
        }
    }
}
