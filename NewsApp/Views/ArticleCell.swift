import UIKit
import SDWebImage

class ArticleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!

    var article: Article? {
        didSet {
            titleLabel.text = article?.title
            descriptionLabel.text = article?.description
            dateLabel.text = "Published at: \(article?.publishedAt.description)"

            loadImage()
        }
    }

    private func loadImage() {
        let url = URL(string: article?.urlToImage ?? "")!

        thumbnailView.sd_setImage(with: url)
    }
}
