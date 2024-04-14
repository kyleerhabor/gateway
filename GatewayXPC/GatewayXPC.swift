//
//  GatewayXPC.swift
//  GatewayXPC
//
//  Created by Kyle Erhabor on 4/14/24.
//

import OSLog

extension URL {
  static let env = Self(string: "file:/usr/bin/env")!
}

/// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
class GatewayXPC: NSObject, GatewayXPCProtocol {
  func runProcess(arguments: [String]) {
    do {
      try Process.run(.env, arguments: arguments)
    } catch {
      Logger.main.error("\(error)")
    }
  }
}
