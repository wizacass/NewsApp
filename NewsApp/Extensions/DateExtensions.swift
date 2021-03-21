import Foundation

extension Date {
    func format(_ dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat

        return formatter.string(from: self)
    }
}
