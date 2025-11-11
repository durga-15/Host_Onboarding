import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoRecorderScreen extends StatefulWidget {
  const VideoRecorderScreen({super.key});

  @override
  _VideoRecorderScreenState createState() => _VideoRecorderScreenState();
}

class _VideoRecorderScreenState extends State<VideoRecorderScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      // Request permissions
      var cameraStatus = await Permission.camera.request();
      var microphoneStatus = await Permission.microphone.request();

      if (cameraStatus != PermissionStatus.granted ||
          microphoneStatus != PermissionStatus.granted) {
        // Handle permission denial
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Camera and microphone permissions are required to record video.')),
        );
        Navigator.pop(context);
        return;
      }

      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0], // Use the first available camera
          ResolutionPreset.high,
          enableAudio: true,
        );
        await _cameraController!.initialize();
        setState(() {});
      } else {
        print('No cameras available');
      }
    } catch (e) {
      print('Error initializing camera: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing camera: $e')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (_cameraController!.value.isRecordingVideo) {
      return;
    }

    await _cameraController!.startVideoRecording();

    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isRecordingVideo) {
      return;
    }

    XFile videoFile = await _cameraController!.stopVideoRecording();

    setState(() {
      _isRecording = false;
    });

    Navigator.pop(context, videoFile.path);
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Record Video'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: FloatingActionButton(
              backgroundColor: _isRecording ? Colors.red : Colors.white,
              onPressed: () {
                if (_isRecording) {
                  _stopRecording();
                } else {
                  _startRecording();
                }
              },
              child: Icon(
                _isRecording ? Icons.stop : Icons.videocam,
                color: _isRecording ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
