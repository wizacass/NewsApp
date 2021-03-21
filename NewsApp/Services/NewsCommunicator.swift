import Foundation

class NewsCommunicator {

    private var apiClient: ApiClientProtocol

    init(_ apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }

    func retrieveSources(onComplete handleResponse: @escaping ApiData<NewsSources?>) {
        apiClient.get("/sources", handleResponse)
    }

    func retrieveArticles(_ parameters: [String: Any], onComplete handleResponse: @escaping ApiData<Articles?>) {
        var endpoint = "/everything"

        let paramsString = parameters.map {"\($0.key)=\($0.value)"}.joined(separator: "&")
        endpoint += "?\(paramsString)"

        apiClient.get(endpoint, handleResponse)
    }
}
