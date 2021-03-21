import UIKit
import SDWebImage

extension UIImageView {
    func downloadImage(_ url: URL?) {
        guard let url = url else { return }

        self.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "xmark.square")
        )
    }
}
