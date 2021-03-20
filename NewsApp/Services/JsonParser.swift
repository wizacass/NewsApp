import Foundation

class JsonParser: ParserProtocol {

    func parseResponse<T: Decodable>(
        _ statusCode: Int,
        _ data: Data?
    ) -> (T?, APIError?) {
        var dataObject: T?
        var apiError: APIError?

        switch statusCode {
        case 200..<299:
            dataObject = tryParse(data)
        default:
            apiError = tryParse(data)
        }

        return (dataObject, apiError)
    }

    private func tryParse<T: Decodable>(_ data: Data?) -> T? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try? decoder.decode(T.self, from: data)
    }
}
