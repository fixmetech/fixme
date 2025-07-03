// Add these dependencies to pubspec.yaml:
// dependencies:
//   camera: ^0.10.5+5
//   google_mlkit_face_detection: ^0.9.0
//   permission_handler: ^11.0.1

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';

class TestCameraScreen extends StatefulWidget {
  @override
  _TestCameraScreenState createState() => _TestCameraScreenState();
}

class _TestCameraScreenState extends State<TestCameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isDetecting = false;
  List<Face> _faces = [];
  
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission is required')),
      );
      return;
    }

    // Get available cameras
    _cameras = await availableCameras();
    if (_cameras!.isEmpty) return;

    // Initialize front camera (index 1) if available, otherwise back camera
    int cameraIndex = _cameras!.length > 1 ? 1 : 0;
    
    _cameraController = CameraController(
      _cameras![cameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
      
      // Start face detection
      _startFaceDetection();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _startFaceDetection() {
    _cameraController!.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _isDetecting = true;
        _detectFaces(image).then((_) {
          _isDetecting = false;
        });
      }
    });
  }

  Future<void> _detectFaces(CameraImage image) async {
    try {
      final inputImage = _inputImageFromCameraImage(image);
      final faces = await _faceDetector.processImage(inputImage);
      
      if (mounted) {
        setState(() {
          _faces = faces;
        });
        
        // Trigger actions when faces are detected
        if (faces.isNotEmpty) {
          _onFaceDetected(faces);
        }
      }
    } catch (e) {
      print('Error detecting faces: $e');
    }
  }

  void _onFaceDetected(List<Face> faces) {
    // This is called when faces are detected
    print('${faces.length} face(s) detected');
    
    for (Face face in faces) {
      // Check if person is smiling
      if (face.smilingProbability != null && face.smilingProbability! > 0.8) {
        print('Person is smiling!');
      }
      
      // Check if eyes are open
      if (face.leftEyeOpenProbability != null && 
          face.rightEyeOpenProbability != null &&
          face.leftEyeOpenProbability! > 0.8 && 
          face.rightEyeOpenProbability! > 0.8) {
        print('Eyes are open');
      }
    }
  }

  InputImage _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameras![1]; // Front camera
    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    
    final plane = image.planes.first;
    
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation ?? InputImageRotation.rotation0deg,
        format: format ?? InputImageFormat.nv21,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  Widget _buildFaceOverlay() {
    if (_faces.isEmpty) return Container();
    
    return CustomPaint(
      painter: FacePainter(_faces, _cameraController!.value.previewSize!),
      size: Size.infinite,
    );
  }

  void _switchCamera() async {
    if (_cameras!.length < 2) return;
    
    final currentIndex = _cameras!.indexOf(_cameraController!.description);
    final newIndex = currentIndex == 0 ? 1 : 0;
    
    await _cameraController!.dispose();
    
    _cameraController = CameraController(
      _cameras![newIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    
    await _cameraController!.initialize();
    setState(() {});
    _startFaceDetection();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Initializing Camera...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
            ),
          ),
          
          // Face Detection Overlay
          Positioned.fill(
            child: _buildFaceOverlay(),
          ),
          
          // Top Bar
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                ),
                Text(
                  'Face Detection',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _switchCamera,
                  icon: Icon(Icons.flip_camera_ios, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),
          
          // Bottom Info Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _faces.isEmpty 
                        ? 'No faces detected' 
                        : '${_faces.length} face(s) detected',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Position your face in the camera view',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }
}

// Custom painter to draw face detection rectangles
class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size previewSize;

  FacePainter(this.faces, this.previewSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (Face face in faces) {
      final rect = _scaleRect(face.boundingBox, size);
      canvas.drawRect(rect, paint);
      
      // Draw face landmarks if available
      if (face.landmarks.isNotEmpty) {
        final landmarkPaint = Paint()
          ..color = Colors.red
          ..strokeWidth = 2.0;
          
        for (FaceLandmark? landmark in face.landmarks.values) {
          if (landmark != null) {
            final point = _scalePoint(landmark.position, size);
            canvas.drawCircle(point, 3, landmarkPaint);
          }
        }
      }
    }
  }

  Rect _scaleRect(Rect rect, Size size) {
    final scaleX = size.width / previewSize.width;
    final scaleY = size.height / previewSize.height;
    
    return Rect.fromLTRB(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.right * scaleX,
      rect.bottom * scaleY,
    );
  }

  Offset _scalePoint(Point<int> point, Size size) {
    final scaleX = size.width / previewSize.width;
    final scaleY = size.height / previewSize.height;
    
    return Offset(point.x * scaleX, point.y * scaleY);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}