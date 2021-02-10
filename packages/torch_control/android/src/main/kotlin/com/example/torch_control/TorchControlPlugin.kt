package com.example.torch_control

import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import android.src.main.kotlin.com.example.torch_control.classes.BaseTorch
import android.src.main.kotlin.com.example.torch_control.implementation.Torch
import android.src.main.kotlin.com.example.torch_control.utils.ActivityLifecycleCallbacks
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

@Suppress("JoinDeclarationAndAssignment")
class TorchCompatPlugin(activity: Activity) : MethodCallHandler {

  private val hasLamp = activity.applicationContext.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)
  private val torchImpl: BaseTorch

  init {
    torchImpl = Torch(activity)

    activity.application.registerActivityLifecycleCallbacks(object : ActivityLifecycleCallbacks() {
      override fun onActivityStopped(activity: Activity?) {
        torchImpl.dispose()
      }
    })
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "torch_control")
      channel.setMethodCallHandler(TorchCompatPlugin(registrar.activity()))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "turnOn") {
      if (!hasLamp) {
        result.error("NOTORCH", "This device does not have a torch", null)
      } else {
        torchImpl.turnOn()
        result.success(true)
      }
    } else if (call.method == "turnOff") {
      if (!hasLamp) {
        result.error("NOTORCH", "This device does not have a torch", null)
      } else {
        torchImpl.turnOff()
        result.success(true)
      }
    } else if (call.method == "hasTorch") {
      result.success(hasLamp)
    } else if (call.method == "dispose") {
      torchImpl.dispose()
      result.success(true)
    } else {
      result.notImplemented()
    }
  }
}