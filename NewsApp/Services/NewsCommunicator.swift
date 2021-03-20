import Foundation

class NewsCommunicator {

    private var apiClient: ApiClientProtocol

    init(_ apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }

    func retrieveSources(onComplete handleResponse: @escaping ApiData<NewsSources?>) {
        apiClient.get("/sources", handleResponse)
    }

    func retrieveArticles(_ source: String, onComplete handleResponse: @escaping ApiData<Articles?>) {
        var endpoint = "/everything"
        endpoint += "?sources=\(source)"
//        endpoint += "&pageSize=10"
//        endpoint += "&page=1"

        apiClient.get(endpoint, handleResponse)
    }
}
