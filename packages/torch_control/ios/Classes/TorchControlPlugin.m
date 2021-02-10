#import "TorchControlPlugin.h"
#if __has_include(<torch_control/torch_control-Swift.h>)
#import <torch_control/torch_control-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "torch_control-Swift.h"
#endif

@implementation TorchControlPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTorchControlPlugin registerWithRegistrar:registrar];
}
@end
