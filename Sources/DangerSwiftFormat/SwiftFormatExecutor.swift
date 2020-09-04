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

    return arguments.joined(separator: " ")
  }

  private func execute() -> String {
    let temporaryDirectory = FileManager.default.temporaryDirectory
    let tempFilePath = temporaryDirectory.appendingPathComponent("reports.txt")

    let rawScript = makeScript()
    let script = "\(rawScript) > \(tempFilePath.path) 2>&1"
    print("script: \(script)")

    let task = Process()
    task.launchPath = "/bin/sh"
    task.arguments = ["-c", script]
    task.currentDirectoryPath = FileManager.default.currentDirectoryPath

    task.launch()
    task.waitUntilExit()

    return tempFilePath.path
  }

  func executeAndNotify(notify: NotifyLine) throws {
    let tempFilePath = execute()

    _ = freopen(tempFilePath, "r", stdin)
    while let line = readLine() {
      notify(line)
    }
  }
}
