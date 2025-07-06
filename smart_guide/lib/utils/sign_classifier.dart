import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

// ← import the Dart Image package
import 'package:image/image.dart' as img;

class SignClassifier {
  late final Interpreter _interpreter;
  late final List<String> _labels;
  late final ImageProcessor _imageProcessor;
  late TensorImage _inputImage;
  late TensorBuffer _outputBuffer;

  /// Call once at app startup.
  Future<void> loadModel() async {
    // 1. Load the TFLite model
    _interpreter = await Interpreter.fromAsset('ml/model.tflite');

    // 2. Load labels.txt (one per line)
    final raw = await rootBundle.loadString('assets/ml/labels.txt');
    _labels = raw.trim().split('\n');

    // 3. Prepare input tensor shape & processor
    final inputTensor = _interpreter.getInputTensor(0);
    final shape = inputTensor.shape;      // e.g. [1,224,224,3]
    final type  = inputTensor.type;       // e.g. TfLiteType.uint8 or float32

    _inputImage = TensorImage(type);
    _imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(shape[1], shape[2], ResizeMethod.BILINEAR))
        .build();

    // 4. Prepare output buffer
    final outputTensor = _interpreter.getOutputTensor(0);
    _outputBuffer = TensorBuffer.createFixedSize(
      outputTensor.shape, 
      outputTensor.type,
    );
  }

  /// Run inference on a raw RGB buffer.
  /// [bytes] must be encoded image bytes (JPEG/PNG etc).
  String classify(Uint8List bytes) {
    // 1. Decode to an `img.Image`
    final img.Image? image = img.decodeImage(bytes);
    if (image == null) return '';

    // 2. Load into TensorImage
    _inputImage.loadImage(image);  // expects `package:image` Image :contentReference[oaicite:1]{index=1}

    // 3. Preprocess (resize)
    _inputImage = _imageProcessor.process(_inputImage);

    // 4. Inference
    _interpreter.run(_inputImage.buffer, _outputBuffer.buffer);

    // 5. Find the highest-score label
    final scores = _outputBuffer.getDoubleList();
    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    final idx = scores.indexOf(maxScore);
    return _labels[idx];
  }

  /// Release resources
  void close() => _interpreter.close();
}
