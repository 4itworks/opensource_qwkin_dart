package android.src.main.kotlin.com.example.torch_controller.implementation

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.Build
import android.src.main.kotlin.com.example.torch_controller.classes.BaseTorch
import androidx.annotation.RequiresApi

@RequiresApi(Build.VERSION_CODES.M)
class Torch(context: Context) : BaseTorch() {
    var flashLightStatus: Boolean = false

    val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
    val cameraId = cameraManager.cameraIdList[0]

    override fun toggle(): Boolean {
        if (!flashLightStatus) {
            try {
                cameraManager.setTorchMode(cameraId, true)
                flashLightStatus = true
                return flashLightStatus
            } catch (e: Exception) {
                e.printStackTrace()
                return false
            }
        } else {
            try {
                cameraManager.setTorchMode(cameraId, false)
                flashLightStatus = false
                return flashLightStatus
            } catch (e: Exception) {
                e.printStackTrace()
                return false
            }
        }
    }

    override fun isTorchActive(): Boolean {
        return flashLightStatus
    }

    override fun dispose() {}
}