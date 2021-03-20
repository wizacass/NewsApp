import Foundation

protocol ParserProtocol {
    func parseResponse<T: Decodable>(
        _ statusCode: Int,
        _ data: Data?
    ) -> (T?, APIError?)
}
