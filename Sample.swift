import DangerSwiftFormat

SwiftFormat.run(targetDirectories: ["Sources", "Tests", "Samples"]) { report in
  print("--- got report")
  print("severity: \(report.severity)")
  print("message: \(report.message)")
  print("file: \(report.file ?? "nil")")
  print("line: \(report.line ?? 0)")
}
