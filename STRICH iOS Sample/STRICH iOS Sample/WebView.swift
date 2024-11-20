//
//  WKWebView.swift
//  STRICH iOS Sample
//

import SwiftUI
import WebKit


/// Handler that prints messages to console.debug() to the standard output of the app
class ConsoleDebugMessageHandler: NSObject, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
}

/// UI Delegate that grants camera permission to the web view. The host app still has to be able to access the camera, but can do so by using the iOS native permission handling.
class CameraPermissionGrantingUIHandler: NSObject, WKUIDelegate {
    
    func webView(_ webView: WKWebView, decideMediaCapturePermissionsFor origin: WKSecurityOrigin, initiatedBy frame: WKFrameInfo, type: WKMediaCaptureType) async -> WKPermissionDecision {
        return WKPermissionDecision.grant
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    let uiDelegate = CameraPermissionGrantingUIHandler()
    
    func makeUIView(context: Context) -> WKWebView  {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        injectConsoleLoggingHandler(config: config)
        let wkwebView = WKWebView(frame: .zero, configuration: config)
        wkwebView.isInspectable = true; // allow debugging with Safari Developer Tools
        wkwebView.uiDelegate = self.uiDelegate
        
        let request = URLRequest(url: url)
        wkwebView.load(request)
        return wkwebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    /// optional: override console.debug() in the WebView and intercept it in our WKScriptMessageHandler. Handy for debugging, only intercepts console.debug() not console.log() and others
    private func injectConsoleLoggingHandler(config: WKWebViewConfiguration) {
        let source = "function consoleDebugShim(msg) { window.webkit.messageHandlers.debugLogHandler.postMessage(msg); } window.console.debug = consoleDebugShim;"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        let userContentController = WKUserContentController()
        userContentController.add(ConsoleDebugMessageHandler(), name: "debugLogHandler")
        userContentController.addUserScript(script)
        config.userContentController = userContentController
    }
}

