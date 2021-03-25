import UIKit

extension UIAlertController {

    static func fatalAlert(_ message: String?) -> UIAlertController {
        let alert = alertBase(message)

        alert.addAction(
            UIAlertAction(
                title: "Close",
                style: .destructive,
                handler: { _ in exit(-1) }
            )
        )

        return alert
    }

    static func informationalAlert(_ message: String?, handler: @escaping () -> Void) -> UIAlertController {
        let alert = alertBase(message)

        alert.addAction(
            UIAlertAction(
                title: "Back",
                style: .cancel,
                handler: { _ in handler() }
            )
        )

        return alert
    }

    private static func alertBase(_ message: String? = nil) -> UIAlertController {
        return UIAlertController(
            title: "Error!",
            message: message,
            preferredStyle: .alert
        )
    }
}
