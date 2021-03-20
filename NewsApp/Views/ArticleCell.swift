import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!

    var article: ArticleViewModel? {
        didSet {
            titleLabel.text = article?.title
            descriptionLabel.text = article?.description.htmlToString
            thumbnailView.downloadImage(article?.imageUrl)
            dateLabel.text = "Published at: \(article?.publishedAt ?? "")"
        }
    }
}
