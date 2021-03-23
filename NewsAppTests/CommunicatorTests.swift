import XCTest
@testable import NewsApp

class CommunicatorTests: XCTestCase {

    private var communicator: NewsCommunicator?

    override func setUp() {
        communicator = CommunicatorMock()
    }

    func testRetrievingSources() {
        var sources: NewsSources?

        let expectation = self.expectation(description: "Retrieving Sources")
        communicator?.retrieveSources { newsSources, _ in
            sources = newsSources
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(sources?.sources?.count, 3)
    }
}
