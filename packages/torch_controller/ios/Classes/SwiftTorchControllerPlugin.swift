import Flutter
import UIKit
import AVFoundation

public class SwiftTorchControllerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "torch_control", binaryMessenger: registrar.messenger())
        let instance = SwiftTorchControllerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "toggleTorch") {
            if (!hasTorch()) {
                result(FlutterError(code: "NOTORCH", message: "This device does not have a torch", details: nil))
            } else {
                result(toggleFlash(intensity: call.arguments as? Float))
            }
        } else if (call.method == "isTorchActive") {
            if (!hasTorch()) {
                result(FlutterError(code: "NOTORCH", message: "This device does not have a torch", details: nil))
            } else {
                result(isTorchActive())
            }
        } else if (call.method == "hasTorch") {
            result(hasTorch())
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    func hasTorch() -> Bool {
        guard let device = AVCaptureDevice.default(for: .video) else {return false}
        return device.hasFlash && device.hasTorch
    }

    func isTorchActive() -> Bool {
        guard let device = AVCaptureDevice.default(for: .video) else {return false}
        return device.torchMode == AVCaptureDevice.TorchMode.on
    }

    func toggleFlash(intensity: Float? = 1) -> Bool {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return false }
        guard device.hasTorch else { return false }

        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: intensity ?? 1.0)
                } catch {
                    print(error)
                }
            }

            device.unlockForConfiguration()
            return device.torchMode == AVCaptureDevice.TorchMode.on
        } catch {
            print(error)
            return false;
        }
    }
}
