import Flutter
import UIKit
import SwiftLinkPreview

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

public class SwiftLinkPreviewPlugin: NSObject, FlutterPlugin, FlutterStreamHandler  {
    
    private var eventSink: FlutterEventSink?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    
    let linkPreviewChannel = FlutterEventChannel(name: ChannelName.linkPreview,
                                                     binaryMessenger: registrar.messenger())
    
    linkPreviewChannel.setStreamHandler(SwiftLinkPreviewPlugin())

  }

  public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
         self.eventSink = eventSink
         
         guard let url = arguments as? String else {
             let error = FlutterError(code: Error.errorType, message: "Parsing URL error. Check your URL for typos and/or your connection", details: "")
             eventSink(error)
             return nil
         }
         
         previewLink(url: url)
         return nil
     }
     
     private func previewLink(url: String) {
         guard let eventSink = eventSink else {
             return
         }
         
         eventSink([State.state : State.loading])
         
         let slp = SwiftLinkPreview(session: URLSession.shared,
                                    workQueue: SwiftLinkPreview.defaultWorkQueue,
                                    responseQueue: DispatchQueue.main,
                                    cache: DisabledCache.instance)
         
         slp.preview(url,
                     onSuccess: {
                         result in print("\(result)")
                         let result = [State.state : State.success,
                                       Field.title : result.title,
                                       Field.description : result.description,
                                       Field.url : result.url?.absoluteString,
                                       Field.finalUrl : result.finalUrl?.absoluteString,
                                       Field.cannonicalUrl : result.canonicalUrl!,
                                       Field.image : result.image]
                         eventSink(result)
         },
                     onError: {
                         error in print("\(error)")
                         eventSink(FlutterError(code: Error.errorType, message: "Parsing URL error. Check your URL for typos and/or your connection", details: ""))
         })
     }
     
     public func onCancel(withArguments arguments: Any?) -> FlutterError? {
         eventSink = nil
         return nil
     }
}
