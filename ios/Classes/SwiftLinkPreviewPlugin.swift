import Flutter
import UIKit
import SwiftLinkPreview

enum ChannelName {
    static let linkPreview = "link_preview_channel"
}

enum State {
    static let state = "state"
    static let loading = "loading"
    static let success = "success"
    static let parsingError = "parsing_error"
    static let wrongUrlError = "wrong_url_error"
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

public class SwiftLinkPreviewPlugin: NSObject, FlutterPlugin  {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    
    let linkPreviewChannel = FlutterMethodChannel(name: ChannelName.linkPreview,
                                                     binaryMessenger: registrar.messenger())
    

    registrar.addMethodCallDelegate(SwiftLinkPreviewPlugin(), channel: linkPreviewChannel)
  }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if(call.method.elementsEqual("previewLink")){
          let arguments = call.arguments as? NSDictionary
        guard let url = arguments!["url"] as? String else {
            result([State.state : State.wrongUrlError])
            return
        }
        
       let slp = SwiftLinkPreview(session: URLSession.shared,
                                           workQueue: SwiftLinkPreview.defaultWorkQueue,
                                           responseQueue: DispatchQueue.main,
                                           cache: DisabledCache.instance)
       
                slp.preview(url,
                            onSuccess: {
                                res in print("\(res)")
                                let data = [State.state : State.success,
                                              Field.title : res.title,
                                              Field.description : res.description,
                                              Field.url : res.url?.absoluteString,
                                              Field.finalUrl : res.finalUrl?.absoluteString,
                                              Field.cannonicalUrl : res.canonicalUrl!,
                                              Field.image : res.image]
                                result(data)
                               
                },
                            onError: {
                                error in print("\(error)")
                                result([State.state : State.parsingError])
                })
      }
    }
}
