import Foundation

class NewsCommunicator {

    private var apiClient: ApiClientProtocol

    init(_ apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }

    func retrieveSources(onComplete handleResponse: @escaping ApiData<NewsSources?>) {
        apiClient.get("/sources", handleResponse)
    }
}
