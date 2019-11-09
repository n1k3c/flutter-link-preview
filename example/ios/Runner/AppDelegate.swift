import UIKit
import Flutter

enum ChannelName {
    static let linkPreview = "link_preview_events"
}

enum State {
    static let state = "state"
    static let loading = "loading"
    static let success = "success"
    static let error = "error"
}

enum Field {
    static let title = "title"
    static let description = "description"
    static let url = "url"
    static let row = "row"
    static let htmlCode = "html_code"
    static let finalUrl = "final_url"
    static let cannonicalUrl = "cannonical_url"
    static let image = "image"
}

enum Error {
    static let errorType = "Link preview error"
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
    
        
        let linkPreviewChannel = FlutterEventChannel(name: ChannelName.linkPreview,
                                                  binaryMessenger: controller.binaryMessenger)
        linkPreviewChannel.setStreamHandler(self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        
        let url: String? = arguments as! String
        
        if (url != nil) {
            let data = [State.state : State.loading]
            eventSink(data)
        } else {
            eventSink(FlutterError(code: Error.errorType, message: "Parsing URL error. Check your URL for typos and/or your connection", details: ""))
        }

        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }
}
