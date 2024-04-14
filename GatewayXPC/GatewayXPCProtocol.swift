//
//  GatewayXPCProtocol.swift
//  GatewayXPC
//
//  Created by Kyle Erhabor on 4/14/24.
//

import Foundation

/// The protocol that this service will vend as its API. This protocol will also need to be visible to the process hosting the service.
@objc
public protocol GatewayXPCProtocol {
  func runProcess(arguments: [String])
}
