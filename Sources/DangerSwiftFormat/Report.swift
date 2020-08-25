import Foundation

/// report from swift-format.
public struct Report {
  /// servirity for report.
  public let severity: Severity
  /// message for report.
  public let message: String
  /// file for report.
  public let file: String?
  /// line for report.
  public let line: Int?

  init(severity: Severity, message: String, file: String? = nil, line: Int? = nil) {
    self.severity = severity
    self.message = message
    self.file = file
    self.line = line
  }
}
