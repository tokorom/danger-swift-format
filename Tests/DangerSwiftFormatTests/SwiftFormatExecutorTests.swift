import XCTest

@testable import DangerSwiftFormat

final class SwiftFormatExecutorTest: XCTestCase {
  func testMakeScriptSimple() {
    let executor = SwiftFormatExecutor(
      executablePath: "/usr/local/bin/swift-format",
      targetDirectories: ["."],
      configurationPath: nil
    )

    let script = executor.makeScript()
    XCTAssertEqual(script, "/usr/local/bin/swift-format lint -r . 2>&1")
  }

  func testChangeExecutablePath() {
    let executor = SwiftFormatExecutor(
      executablePath: "swift-format",
      targetDirectories: ["."],
      configurationPath: nil
    )

    let script = executor.makeScript()
    XCTAssertEqual(script, "swift-format lint -r . 2>&1")
  }

  func testMakeScriptWithSomeDirs() {
    let executor = SwiftFormatExecutor(
      executablePath: "/usr/local/bin/swift-format",
      targetDirectories: ["app", "app2", "Tests"],
      configurationPath: nil
    )

    let script = executor.makeScript()
    XCTAssertEqual(script, "/usr/local/bin/swift-format lint -r app app2 Tests 2>&1")
  }

  func testMakeScriptWithConfigurationPath() {
    let executor = SwiftFormatExecutor(
      executablePath: "/usr/local/bin/swift-format",
      targetDirectories: ["."],
      configurationPath: "custom.conf"
    )

    let script = executor.makeScript()
    XCTAssertEqual(script, "/usr/local/bin/swift-format --configuration custom.conf lint -r . 2>&1")
  }
}
