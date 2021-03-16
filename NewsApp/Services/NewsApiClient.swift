import Foundation

class NewsApiClient: ApiClientProtocol {

    private let apiUrl = "https://newsapi.org/v2/"

    private var apiKey: String

    init() {
        guard let key: String = try? Configuration.value(for: .apiKey) else {
            NSLog("API key is missing from info.plist file!")
            exit(-1)
        }

        apiKey = key
    }

    func get<T>(_ endpoint: String, _ onComplete: @escaping ApiData<T?>) where T: Decodable {

        DispatchQueue.main.async {
            onComplete(nil, nil)
        }
    }
}
