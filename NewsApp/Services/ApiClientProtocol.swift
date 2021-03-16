import Foundation

typealias ApiData<T> = (T, APIError?) -> Void

protocol ApiClientProtocol {
    func get<T: Decodable>(_ endpoint: String, _ onComplete: @escaping ApiData<T?>)
}
