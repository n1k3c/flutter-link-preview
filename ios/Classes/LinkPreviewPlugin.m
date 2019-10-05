#import "LinkPreviewPlugin.h"
#import <link_preview/link_preview-Swift.h>

@implementation LinkPreviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLinkPreviewPlugin registerWithRegistrar:registrar];
}
@end
