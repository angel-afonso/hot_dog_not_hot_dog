package com.angelafonso.hot_dog_not_hot_dog

import com.angelafonso.hot_dog_not_hot_dog.ml.Model
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.tensorflow.lite.DataType
import org.tensorflow.lite.support.image.ImageProcessor;
import org.tensorflow.lite.support.image.TensorImage;
import org.tensorflow.lite.support.image.ops.ResizeOp;
import org.tensorflow.lite.support.image.ops.Rot90Op

class MainActivity: FlutterActivity() {

    private val CHANNEL = "hotdog_model"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{call, result ->
            when(call.method) {
                "predict" -> {
                    val model = Model.newInstance(context)

                    val argument = call.arguments as ByteArray

                    val imageProcessor = ImageProcessor.Builder()
                        .add(ResizeOp(200, 200, ResizeOp.ResizeMethod.BILINEAR))
                        .add(Rot90Op(90))
                        .build()

                    val input = TensorImage(DataType.FLOAT32)
                    input.load(Array<Int>(1 * 200 * 200 * 3){ argument[it].toInt() }.toIntArray(), intArrayOf(1, 200, 200, 3))

                    val output = model.process(imageProcessor.process(input).tensorBuffer)

                    result.success(DoubleArray(output.outputFeature0AsTensorBuffer.floatArray.size){output.outputFeature0AsTensorBuffer.floatArray[it].toDouble()})

                    model.close()
                }
                else -> result.notImplemented()
            }
        }
    }
}
