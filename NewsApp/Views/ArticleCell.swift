import UIKit
import SDWebImage

class ArticleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!

    private let dateFormat = "yyyy-MM-dd"

    var article: Article? {
        didSet {
            titleLabel.text = article?.title
            descriptionLabel.attributedText = article?.description.htmlToAttributedString
            dateLabel.text = "Published at: \(formatDate())"

            loadImage()
        }
    }

    private func loadImage() {
        guard let urlString = article?.urlToImage else { return }

        thumbnailView.sd_setImage(
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
}
