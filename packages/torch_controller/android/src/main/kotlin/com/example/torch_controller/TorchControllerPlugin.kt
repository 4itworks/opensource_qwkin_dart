package com.example.torch_controller

import android.content.Context
import android.content.pm.PackageManager
import com.example.torch_controller.classes.BaseTorch
import com.example.torch_controller.implementation.Torch
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class TorchControllerPlugin() : FlutterPlugin, MethodCallHandler {
  private var hasLamp = true
  private lateinit var torchImpl: BaseTorch

  private var context: Context? = null

  /** Plugin registration. Android V2 Embedding  */
  private fun init(binaryMessenger: BinaryMessenger, applicationContext: Context) {
    Log.d(Companion.TAG, "init. Messanger:$binaryMessenger Context:$applicationContext")

    hasLamp = applicationContext.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)
    torchImpl = Torch(applicationContext)
    val channel = MethodChannel(binaryMessenger, Companion.CHANNEL_QUERY)
    channel.setMethodCallHandler(this)
    context = applicationContext
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(Companion.TAG, "onAttachedToEngine")
    init(flutterPluginBinding.binaryMessenger, flutterPluginBinding.applicationContext)
  }

  override fun onDetachedFromEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(Companion.TAG, "onDetachedFromEngine")
  }

  /** Plugin onMethodCall  */
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

  companion object {
    private const val CHANNEL_QUERY = "torch_control"
    private const val TAG = "flutter/torch_control"
  }
}