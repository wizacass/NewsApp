import Foundation

class NewsApiClient: ApiClientProtocol {

    private let apiUrl = "https://newsapi.org/v2/"
    private let session = URLSession.shared

    private var apiKey: String

    init() {
        guard let key: String = try? Configuration.value(for: .apiKey) else {
            NSLog("API key is missing from info.plist file!")
            exit(-1)
        }

        apiKey = key
    }

    func get<T>(_ endpoint: String, _ onComplete: @escaping ApiData<T?>) where T: Decodable {

        let url = URL(string: "\(apiUrl)\(endpoint)")!
        let request = createGetRequest(url)

        let task = session.dataTask(with: request) { [unowned self] data, response, error in

            if error != nil {
                DispatchQueue.main.async { onComplete(nil, APIError.noConnectionError) }
                return
            }

            guard let statusCode = self.getStatusCode(response) else {
                DispatchQueue.main.async { onComplete(nil, APIError.invalidRequest) }
                return
            }

            let (dataObject, apiError): (T?, APIError?) = self.parseResponse(statusCode, data)

            DispatchQueue.main.async { onComplete(dataObject, apiError) }
        }

        task.resume()
    }

    private func getStatusCode(_ response: URLResponse?) -> Int? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return nil
        }

        return httpResponse.statusCode
    }

    private func createGetRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }

    private func parseResponse<T: Decodable>(
        _ statusCode: Int,
        _ data: Data?
    ) -> (T?, APIError?) {
        var dataObject: T?
        var apiError: APIError?

        switch statusCode {
        case 200:
            dataObject = tryParse(data)
        default:
            apiError = tryParse(data)
        }

        return (dataObject, apiError)
    }

    private func tryParse<T: Decodable>(_ data: Data?) -> T? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
