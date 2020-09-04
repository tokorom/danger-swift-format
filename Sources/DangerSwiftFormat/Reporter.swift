import Foundation

struct Reporter {
  static let pattern: String = #"^([^:]+):([0-9]+):([0-9]+): ([^:]+): (.*)$"#
  static let regex = try? NSRegularExpression(pattern: Self.pattern)

  static func analyzeData(_ data: Data) -> [Report] {
    var reports: [Report] = []

    let input = String(data: data, encoding: .utf8) ?? ""
    input.enumerateLines { target, _ in
      guard let report = Self.analyzeAndReport(target) else {
        return
      }
      reports.append(report)
    }

    return reports
  }

  static func analyzeAndReport(_ target: String) -> Report? {
    assert(Self.regex != nil)

    guard let regex = Self.regex else {
      return nil
    }

    let range = NSRange(target.startIndex..<target.endIndex, in: target)
    guard let match = regex.firstMatch(in: target, range: range) else {
      return nil
    }
    guard match.numberOfRanges >= 6 else {
      return nil
    }

    let defaultRange = target.startIndex..<target.endIndex
    let filePath = String(target[Range(match.range(at: 1), in: target) ?? defaultRange])
    let line = Int(String(target[Range(match.range(at: 2), in: target) ?? defaultRange]))
    // let col = Int(String(target[Range(match.range(at: 3), in: target)!]))
    let severity =
      Severity(rawValue: String(target[Range(match.range(at: 4), in: target) ?? defaultRange]))
      ?? .note
    let body = String(target[Range(match.range(at: 5), in: target) ?? defaultRange])

    let currentDirectoryPath = FileManager.default.currentDirectoryPath + "/"
    let file = filePath.replacingOccurrences(of: currentDirectoryPath, with: "")

    if let line = line {
      switch severity {
      case .note:
        return Report(severity: .note, message: body, file: file, line: line)
      case .warning:
        return Report(severity: .warning, message: body, file: file, line: line)
      case .error:
        return Report(severity: .error, message: body, file: file, line: line)
      }
    } else {
      switch severity {
      case .note:
        return Report(severity: .note, message: body)
      case .warning:
        return Report(severity: .warning, message: body)
      case .error:
        return Report(severity: .error, message: body)
      }
    }
  }
}
