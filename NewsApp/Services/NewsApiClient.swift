import Foundation

class NewsApiClient: ApiClientProtocol {

    private let apiUrl = "https://newsapi.org/v2"
    private let session = URLSession.shared

    private var apiKey: String
    private var parser: ParserProtocol

    init(_ apiKey: String, _ parser: ParserProtocol) {
        self.apiKey = apiKey
        self.parser = parser
    }

    func get<T>(_ endpoint: String, _ onComplete: @escaping ApiData<T?>) where T: Decodable {

        let url = URL(string: "\(apiUrl)\(endpoint)")!
        let request = createGetRequest(url)

        session.dataTask(with: request) { [unowned self] data, response, error in

            if error != nil {
                DispatchQueue.main.async { onComplete(nil, APIError.noConnectionError) }
                return
            }

            guard let statusCode = self.getStatusCode(response) else {
                DispatchQueue.main.async { onComplete(nil, APIError.invalidRequest) }
                return
            }

            let (dataObject, apiError): (T?, APIError?) = self.parser.parseResponse(statusCode, data)

            DispatchQueue.main.async { onComplete(dataObject, apiError) }
        }.resume()
    }

    private func getStatusCode(_ response: URLResponse?) -> Int? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return nil
        }

        return httpResponse.statusCode
    }

    private func createGetRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = HTTPRequestMethod.get.rawValue
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
}
