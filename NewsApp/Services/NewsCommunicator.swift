import Foundation

class NewsCommunicator {

    private var apiClient: ApiClientProtocol

    init(_ apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}
