import XCTest
@testable import DangerSwiftFormat

final class DangerSwiftFormatTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DangerSwiftFormat().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
