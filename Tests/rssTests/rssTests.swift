import XCTest
@testable import rss

final class rssTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(rss().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
