package com.example.torch_controller

import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import android.src.main.kotlin.com.example.torch_controller.classes.BaseTorch
import android.src.main.kotlin.com.example.torch_controller.implementation.Torch
import android.src.main.kotlin.com.example.torch_controller.utils.ActivityLifecycleCallbacks
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

@Suppress("JoinDeclarationAndAssignment")
class TorchControllerPlugin(activity: Activity) : MethodCallHandler {

  private val hasLamp = activity.applicationContext.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)
  private val torchImpl: BaseTorch

  init {
    torchImpl = Torch(activity)

    activity.application.registerActivityLifecycleCallbacks(object : ActivityLifecycleCallbacks() {
      override fun onActivityStopped(activity: Activity) {
        torchImpl.dispose()
      }
    })
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "torch_control")
      channel.setMethodCallHandler(TorchControllerPlugin(registrar.activity()))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "toggleTorch") {
      if (!hasLamp) {
        result.error("NOTORCH", "This device does not have a torch", null)
      } else {
        result.success(torchImpl.toggle())
      }
    } else if (call.method == "hasTorch") {
      result.success(hasLamp)
    } else if (call.method == "dispose") {
      torchImpl.dispose()
      result.success(true)
    } else if (call.method == "isTorchActive") {
      result.success(torchImpl.isTorchActive())
    } else {
      result.notImplemented()
    }
  }
}