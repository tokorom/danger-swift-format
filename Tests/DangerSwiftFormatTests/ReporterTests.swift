import XCTest

@testable import DangerSwiftFormat

final class DangerSwiftFormatTests: XCTestCase {
  func testSimpelWarning() {
    let inputString = """
      /foo/Sources/DangerSwiftFormat/Reporter.swift:36:34: warning: [NeverForceUnwrap]: do not force unwrap 'Range(match.range(at: 1), in: target)'
      """
    let input = inputString.data(using: .utf8) ?? Data()

    let reports = Reporter.analyzeData(input)

    XCTAssertEqual(reports.count, 1)

    let report = reports[0]
    XCTAssertEqual(report.severity, .warning)
    XCTAssertEqual(
      report.message,
      "[NeverForceUnwrap]: do not force unwrap 'Range(match.range(at: 1), in: target)'"
    )
    XCTAssertEqual(report.file, "/foo/Sources/DangerSwiftFormat/Reporter.swift")
    XCTAssertEqual(report.line, 36)
  }

  func testEmpty() {
    let input = Data()

    let reports = Reporter.analyzeData(input)

    XCTAssertEqual(reports.count, 0)
  }

  func testNoErrors() {
    let inputString = """
      foo
      bar
      bar baz 12345
      Test.swift:1:2: others
      """
    let input = inputString.data(using: .utf8) ?? Data()

    let reports = Reporter.analyzeData(input)

    XCTAssertEqual(reports.count, 0)
  }

  func testUnknownSeverity() {
    let inputString = """
      /foo/Sources/DangerSwiftFormat/Reporter.swift:36:34: xxx: [NeverForceUnwrap]: do not force unwrap 'Range(match.range(at: 1), in: target)'
      """
    let input = inputString.data(using: .utf8) ?? Data()

    let reports = Reporter.analyzeData(input)

    XCTAssertEqual(reports.count, 1)

    let report = reports[0]
    XCTAssertEqual(report.severity, .note)
    XCTAssertEqual(
      report.message,
      "[NeverForceUnwrap]: do not force unwrap 'Range(match.range(at: 1), in: target)'"
    )
    XCTAssertEqual(report.file, "/foo/Sources/DangerSwiftFormat/Reporter.swift")
    XCTAssertEqual(report.line, 36)
  }

  func testSomeWarnings() {
    let inputString = """
      /foo/Sources/DangerSwiftFormat/Reporter.swift:36:34: warning: [NeverForceUnwrap]: do not force unwrap 'Range(match.range(at: 1), in: target)'
      /foo/Sources/DangerSwiftFormat/Error/Error.swift:1:2: error: file contains invalid or unrecognized Swift syntax.
      /foo/Sources/DangerSwiftFormat/Note/Note.swift:111:222: note: note?
      """
    let input = inputString.data(using: .utf8) ?? Data()

    let reports = Reporter.analyzeData(input)

    XCTAssertEqual(reports.count, 3)

    let report0 = reports[0]
    XCTAssertEqual(report0.severity, .warning)
    XCTAssertEqual(
      report0.message,
      "[NeverForceUnwrap]: do not force unwrap 'Range(match.range(at: 1), in: target)'"
    )
    XCTAssertEqual(report0.file, "/foo/Sources/DangerSwiftFormat/Reporter.swift")
    XCTAssertEqual(report0.line, 36)

    let report1 = reports[1]
    XCTAssertEqual(report1.severity, .error)
    XCTAssertEqual(
      report1.message,
      "file contains invalid or unrecognized Swift syntax."
    )
    XCTAssertEqual(report1.file, "/foo/Sources/DangerSwiftFormat/Error/Error.swift")
    XCTAssertEqual(report1.line, 1)

    let report2 = reports[2]
    XCTAssertEqual(report2.severity, .note)
    XCTAssertEqual(
      report2.message,
      "note?"
    )
    XCTAssertEqual(report2.file, "/foo/Sources/DangerSwiftFormat/Note/Note.swift")
    XCTAssertEqual(report2.line, 111)
  }
}
