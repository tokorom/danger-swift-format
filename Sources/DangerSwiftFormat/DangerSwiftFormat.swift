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
  ) {
    let executor = SwiftFormatExecutor(
      executablePath: executablePath,
      targetDirectories: targetDirectories,
      configurationPath: configurationPath
    )

    let output = executor.execute()
    let reports = Reporter.analyzeData(output)

    for report in reports {
      notify(report)
    }
  }
}
