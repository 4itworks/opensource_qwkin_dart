package com.example.torch_controller

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
import io.flutter.plugin.common.BinaryMessenger


import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

import android.util.Log
import androidx.annotation.NonNull
import android.app.Activity
import android.content.Context


@Suppress("JoinDeclarationAndAssignment")
class TorchControllerPlugin() : FlutterPlugin, ActivityAware, MethodCallHandler {

  private val CHANNEL_QUERY = "torch_control"
  private val TAG = "flutter/torch_control"

  private var hasLamp = true
  private lateinit var torchImpl: BaseTorch

  private var activityPluginBinding: ActivityPluginBinding? = null
  private var activity: Activity? = null
  private var context: Context? = null

  /** Plugin registration. Android V1 Embedding  */
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      var torchImpl = Torch(registrar.activity())

      val channel = MethodChannel(registrar.messenger(), "torch_control")
      val torchControllerPlugin = TorchControllerPlugin()
      torchControllerPlugin.activity = registrar.activity()
      channel.setMethodCallHandler(torchControllerPlugin)

      torchControllerPlugin.activity!!.application.registerActivityLifecycleCallbacks(object : ActivityLifecycleCallbacks() {
        override fun onActivityStopped(activity: Activity) {
          torchImpl.dispose()
        }
      })
    }
  }

  /** Plugin registration. Android V2 Embedding  */
  private fun init(binaryMessenger: BinaryMessenger, applicationContext: Context) {
    Log.d(TAG, "init. Messanger:$binaryMessenger Context:$applicationContext")

    hasLamp = applicationContext.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)
    torchImpl = Torch(applicationContext)
    val channel = MethodChannel(binaryMessenger, CHANNEL_QUERY)
    channel.setMethodCallHandler(this)
    context = applicationContext
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "onAttachedToEngine")
    init(flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getApplicationContext())
  }

  override fun onDetachedFromEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "onDetachedFromEngine")
  }

  override fun onDetachedFromActivityForConfigChanges() {
    Log.d(TAG, "onDetachedFromActivityForConfigChanges")
  }

  override fun onReattachedToActivityForConfigChanges(@NonNull activityPluginBinding: ActivityPluginBinding) {
    Log.d(TAG, "onReattachedToActivityForConfigChanges")
  }

  override fun onAttachedToActivity(@NonNull activityPluginBinding: ActivityPluginBinding) {
    this.activityPluginBinding = activityPluginBinding
    Log.d(TAG, "onAttachedToActivity")
  }

  override fun onDetachedFromActivity() {
    Log.d(TAG, "onDetachedFromActivity")
    if (activityPluginBinding != null) {
      activityPluginBinding = null
    }
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

}