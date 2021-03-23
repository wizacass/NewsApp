import XCTest
@testable import NewsApp

class ArticlesTests: XCTestCase {

    private var communicator: NewsCommunicator!

    private let defaultPageSize = 4
    private let defaultSourceName = "Test Source"

    override func setUp() {
        communicator = CommunicatorMock()
    }

    func testRetrieveNoArticles() {
        let source = NewsSource(id: "test-2", name: defaultSourceName)
        let articles = ArticlesViewModel(communicator, source, defaultPageSize)
        let expectation = self.expectation(description: "Loading articles")

        var error: APIError?

        articles.loadAll { apiError in
            error = apiError
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(articles.count, 0)
        XCTAssertNil(error)
    }

    func testInvalidSource() {
        let source = NewsSource(id: "test", name: defaultSourceName)
        let articles = ArticlesViewModel(communicator, source, defaultPageSize)
        let expectation = self.expectation(description: "Loading articles")

        var error: APIError?

        articles.loadAll { apiError in
            error = apiError
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(articles.count, 0)
        XCTAssertNotNil(error)
    }

    func testRetrieveAllArticles() {
        let source = NewsSource(id: "test-1", name: defaultSourceName)
        let articles = ArticlesViewModel(communicator, source, defaultPageSize)
        let expectation = self.expectation(description: "Loading articles")

        var error: APIError?

        articles.loadAll { apiError in
            error = apiError
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(articles.count, articles.totalResults)
        XCTAssertNil(error)
    }

    func testPagedArticles() {
        let source = NewsSource(id: "test-1", name: defaultSourceName)
        let articles = ArticlesViewModel(communicator, source, defaultPageSize)
        let expectation = self.expectation(description: "Loading articles")

        var error: APIError?

        articles.loadNext { apiError in
            error = apiError
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(articles.count, defaultPageSize)
        XCTAssertNil(error)
    }

    func test2Pages() {
        let source = NewsSource(id: "test-1", name: defaultSourceName)
        let articles = ArticlesViewModel(communicator, source, defaultPageSize)
        let expectation1 = self.expectation(description: "Loading page 1")
        let expectation2 = self.expectation(description: "Loading page 2")

        var error: APIError?

        articles.loadNext { apiError in
            error = apiError
            expectation1.fulfill()

            articles.loadNext { apiError in
                error = apiError
                expectation2.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(articles.count, defaultPageSize * 2)
        XCTAssertNil(error)
    }

    func test2IncompletePages() {
        let source = NewsSource(id: "test-1", name: defaultSourceName)
        let articles = ArticlesViewModel(communicator, source, 6)
        let expectation1 = self.expectation(description: "Loading page 1")
        let expectation2 = self.expectation(description: "Loading page 2")

        var error: APIError?

        articles.loadNext { apiError in
            error = apiError
            expectation1.fulfill()

            articles.loadNext { apiError in
                error = apiError
                expectation2.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(articles.count, articles.totalResults)
        XCTAssertNil(error)
    }
}
