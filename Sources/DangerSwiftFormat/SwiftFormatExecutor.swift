//
//  SwiftFormatExecutor.swift
//
//  Created by ToKoRo on 2020-09-04.
//

import Foundation

/// execute swift-format.
struct SwiftFormatExecutor {
  let executablePath: String
  let targetDirectories: [String]
  let configurationPath: String?

  static let prefixArguments: [String] = ["lint", "-r"]
  static let suffixArguments: [String] = ["2>&1"]

  typealias NotifyLine = (String) -> Void

  func makeScript() -> String {
    let configuration: [String]
    if let configurationPath = configurationPath {
      configuration = ["--configuration", configurationPath]
    } else {
      configuration = []
    }

    let arguments: [String] =
      [executablePath]
      + configuration
      + Self.prefixArguments
      + targetDirectories
      + Self.suffixArguments

    return arguments.joined(separator: " ")
  }

  func execute() -> Data {
    let script = makeScript()
    print("script: \(script)")

    let task = Process()
    task.launchPath = "/bin/sh"
    task.arguments = ["-c", script]
    task.currentDirectoryPath = FileManager.default.currentDirectoryPath

    let stdout = Pipe()
    task.standardOutput = stdout
    let stderr = Pipe()
    task.standardError = stderr
    task.launch()
    task.waitUntilExit()

    var stdoutData = stdout.fileHandleForReading.readDataToEndOfFile()
    let stderrData = stderr.fileHandleForReading.readDataToEndOfFile()
    stdoutData.append(stderrData)

    return stdoutData
  }

  func executeAndNotify(notify: NotifyLine) throws {
    let data = execute()

    let temporaryDirectory = FileManager.default.temporaryDirectory
    let tempFilePath = temporaryDirectory.appendingPathExtension("reports.txt")
    try data.write(to: tempFilePath)
    print(tempFilePath.path)

    _ = freopen(tempFilePath.path, "r", stdin)
    while let line = readLine() {
      notify(line)
    }
  }
}
