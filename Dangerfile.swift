import Danger
import DangerSwiftFormat

_ = Danger()

do {
  try SwiftFormat.run(targetDirectories: ["Sources", "Tests", "Samples"]) { report in
    switch report.severity {
    case .note:
      if let file = report.file, let line = report.line {
        message(message: report.message, file: file, line: line)
      } else {
        message(report.message)
      }
    case .warning:
      if let file = report.file, let line = report.line {
        warn(message: report.message, file: file, line: line)
      } else {
        warn(report.message)
      }
    case .error:
      if let file = report.file, let line = report.line {
        fail(message: report.message, file: file, line: line)
      } else {
        fail(report.message)
      }
    }
  }
} catch {
  fail(error.localizedDescription)
}
