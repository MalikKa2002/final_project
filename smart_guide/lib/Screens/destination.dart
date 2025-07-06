import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../utils/sign_classifier.dart';

class Destination extends StatefulWidget {
  @override
  _DestinationState createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {
  CameraController? _cam;
  late Future<void> _initFuture;
  final SignClassifier _clf = SignClassifier();
  String? _instr;

  // Map your raw labels to user-friendly instructions
  static const Map<String, String> _instructionMap = {
    'CafeteriaIcon': '← Go to the Cafeteria',
    'GateEntrance':  '→ Enter through the Gate',
    'Left':          '← Turn Left',
    'Right':         '→ Turn Right',
    'Straight':      '↑ Go Straight',
  };

  @override
  void initState() {
    super.initState();
    // Start loading model and camera
    _initFuture = _setupAll();
  }

  Future<void> _setupAll() async {
    // 1) Load the TFLite model + labels
    await _clf.loadModel();

    // 2) Get available cameras
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No cameras found on this device.');
    }

    // 3) Pick back camera if possible
    final backCam = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    // 4) Initialize controller
    _cam = CameraController(
      backCam,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cam!.initialize();

    // 5) Start streaming frames
    _cam!.startImageStream(_processFrame);
  }

  void _processFrame(CameraImage frame) {
    // 1) Merge YUV planes into a single RGB byte buffer
    final bytes = frame.planes.fold<BytesBuilder>(
      BytesBuilder(),
      (b, p) => b..add(p.bytes),
    ).toBytes();

    // 2) Run TFLite inference
    final label = _clf.classify(bytes);

    // 3) Map to human-readable instruction
    final text = _instructionMap[label] ?? '';

    // 4) Update overlay if changed
    if (mounted && text != _instr) {
      setState(() => _instr = text);
    }
  }

  @override
  void dispose() {
    _cam?.dispose();
    _clf.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        // 1) Still initializing → show spinner
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        // 2) Initialization failed → show error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        // 3) Controller is null or not ready → show a fallback
        if (_cam == null || !_cam!.value.isInitialized) {
          return const Center(child: Text('Camera not available'));
        }
        // 4) All good → show camera + overlay
        return Stack(
          children: [
            Positioned.fill(child: CameraPreview(_cam!)),
            if (_instr != null && _instr!.isNotEmpty)
              Positioned(
                bottom: 32,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.black54,
                  child: Text(
                    _instr!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
