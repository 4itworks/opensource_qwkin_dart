package android.src.main.kotlin.com.example.torch_controller.classes

abstract class BaseTorch {
    abstract fun toggle() : Boolean
    abstract fun isTorchActive() : Boolean
    abstract fun dispose()
}