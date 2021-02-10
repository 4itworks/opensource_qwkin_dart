package android.src.main.kotlin.com.example.torch_control.implementation

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.Build
import android.src.main.kotlin.com.example.torch_control.classes.BaseTorch
import androidx.annotation.RequiresApi

@RequiresApi(Build.VERSION_CODES.M)
class Torch(context: Context) : BaseTorch() {

    private val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
    private val cameraId = cameraManager.cameraIdList.first { cameraId ->
        cameraManager.getCameraCharacteristics(cameraId)[CameraCharacteristics.FLASH_INFO_AVAILABLE] != null
    } ?: null

    override fun turnOn() {
        turn(on = true)
    }

    override fun turnOff() {
        turn(on = false)
    }

    private fun turn(on: Boolean) {
        if (cameraId != null) {
            cameraManager.setTorchMode(cameraId, on)
        }
    }

    override fun hasTorch(): Boolean = cameraId != null
}