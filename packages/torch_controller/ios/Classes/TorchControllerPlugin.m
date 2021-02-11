#import "TorchControllerPlugin.h"
#if __has_include(<torch_controller/torch_controller-Swift.h>)
#import <torch_controller/torch_controller-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "torch_controller-Swift.h"
#endif

@implementation TorchControllerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTorchControllerPlugin registerWithRegistrar:registrar];
}
@end
