package android.src.main.kotlin.com.example.torch_control.classes

abstract class BaseTorch {
    abstract fun turnOn()
    abstract fun turnOff()
    abstract fun hasTorch() : Boolean
    abstract fun dispose()
}