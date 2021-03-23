import Foundation
@testable import NewsApp

class ApiClientMock: ApiClientProtocol {
    func get<T>(
        _ endpoint: String,
        _ onComplete: @escaping ApiData<T?>)
    where T: Decodable { }
}
