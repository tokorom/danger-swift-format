import Foundation

/// danger-swift-format main class.
public struct SwiftFormat {
  /// completion for run method.
  public typealias NotifyReport = (Report) -> Void

  /// run swift-format.
  public static func run(
    executablePath: String = "/usr/local/bin/swift-format",
    targetDirectories: [String] = ["."],
    configurationPath: String? = nil,
    notify: NotifyReport
  ) throws {
    let executor = SwiftFormatExecutor(
      executablePath: executablePath,
      targetDirectories: targetDirectories,
      configurationPath: configurationPath
    )

    try executor.executeAndNotify { line in
      guard let report = Reporter.analyzeAndReport(line) else {
        return
      }
      notify(report)
    }
  }
}
