//
//  GatewayApp.swift
//  Gateway
//
//  Created by Kyle Erhabor on 4/14/24.
//

import GatewayXPC
import OSLog
import SwiftUI

extension Bundle {
  static let appIdentifier = Bundle.main.bundleIdentifier!
}

extension Logger {
  static let ui = Self(subsystem: Bundle.appIdentifier, category: "UI")
}

extension URL {
  static let userBinaryDirectory = Self(string: "file:/usr/local/bin")!
  static let mpv = userBinaryDirectory.appending(component: "mpv")

  var string: String {
    self.path(percentEncoded: false)
  }
}

enum UserDefaultsKey {
  static let mpv = "mpv"
}

class AppDelegate: NSObject, NSApplicationDelegate {
  @AppStorage(UserDefaultsKey.mpv) private var mpv: URL?

  func applicationDidFinishLaunching(_ notification: Notification) {
    let app = notification.object as! NSApplication

    app.hide(nil)

    app.windows.forEach { window in
      window.close()
    }
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    false
  }

  func application(_ application: NSApplication, open urls: [URL]) {
    guard let mpv else {
      return
    }

    urls.forEach { url in
      let path = url.string

      Logger.main.info("Opening \"\(url.string)\"")

      let xpc = NSXPCConnection(serviceName: "com.kyleerhabor.GatewayXPC")
      xpc.remoteObjectInterface = NSXPCInterface(with: GatewayXPCProtocol.self)
      xpc.resume()

      defer {
        xpc.invalidate()
      }

      guard let proxy = xpc.remoteObjectProxy as? GatewayXPCProtocol else {
        return
      }

      proxy.runProcess(arguments: [mpv.string, path])
    }
  }
}

extension View {
  // https://stackoverflow.com/a/77735876/14695788
  func apply<Content>(@ViewBuilder content: (Self) -> Content) -> Content where Content: View {
    content(self)
  }
}

struct ContentView: View {
  @AppStorage(UserDefaultsKey.mpv) private var mpv: URL?
  @State private var isFileImporterPresented = false

  var body: some View {
    Form {
      LabeledContent("mpv path:") {
        VStack(alignment: .leading) {
          Text("\(mpv?.string ?? "None")")
            .monospaced()

          Button("Select...") {
            isFileImporterPresented = true
          }
          .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.item]) { result in
            switch result {
              case .success(let url): mpv = url
              case .failure(let err): Logger.ui.error("\(err)")
            }
          }
          .apply { content in
            if #available(macOS 14, *) {
              content
                .fileDialogDefaultDirectory(.userBinaryDirectory)
                .fileDialogImportsUnresolvedAliases(true)
            } else {
              content
            }
          }
        }
      }
    }
    .formStyle(.columns)
  }
}

@main
struct GatewayApp: App {
  @NSApplicationDelegateAdaptor private var delegate: AppDelegate
  private let width: CGFloat = 320
  private let height: CGFloat = 200 // 1.6

  var body: some Scene {
    Window(Text("Gateway"), id: "app") {
      ContentView()
        .frame(minWidth: width, minHeight: height)
    }
    .windowResizability(.contentMinSize)
    .defaultSize(width: width, height: height)
    .handlesExternalEvents(matching: [])
  }
}
