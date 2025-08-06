
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import './widgets/camera_preview_widget.dart';
import './widgets/media_controls_widget.dart';
import './widgets/proof_submission_widget.dart';

class TaskCompletionProof extends StatefulWidget {
  const TaskCompletionProof({Key? key}) : super(key: key);

  @override
  State<TaskCompletionProof> createState() => _TaskCompletionProofState();
}

class _TaskCompletionProofState extends State<TaskCompletionProof>
    with WidgetsBindingObserver {
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isVideoMode = false;
  bool _isRecording = false;
  XFile? _capturedMedia;
  String _completionNotes = '';
  final TextEditingController _notesController = TextEditingController();

  // Mock task data - would come from route arguments in real app
  final Map<String, dynamic> _taskData = {
    'id': '1',
    'title': 'Morning Workout',
    'description': 'Complete 30-minute cardio session',
    'coinReward': 50,
    'requirements': 'Photo or video proof of completed workout',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        return;
      }

      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        return;
      }

      // Use front camera for web, rear for mobile
      final camera = kIsWeb
          ? _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras!.first,
            )
          : _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras!.first,
            );

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      await _applyDefaultSettings();

      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      print('Camera initialization error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize camera: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true; // Browser handles permissions

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _applyDefaultSettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);

      // Skip flash settings on web
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          // Flash not supported, continue
        }
      }
    } catch (e) {
      // Settings not supported, continue
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() => _capturedMedia = photo);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to capture photo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _startVideoRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isRecording) {
      return;
    }

    try {
      await _cameraController!.startVideoRecording();
      setState(() => _isRecording = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to start recording'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_cameraController == null || !_isRecording) {
      return;
    }

    try {
      final XFile video = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _capturedMedia = video;
      });
    } catch (e) {
      setState(() => _isRecording = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to stop recording'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch);
      }
      setState(() => _isFlashOn = !_isFlashOn);
    } catch (e) {
      // Flash not supported
    }
  }

  Future<void> _selectFromGallery() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? media;
      if (_isVideoMode) {
        media = await picker.pickVideo(source: ImageSource.gallery);
      } else {
        media = await picker.pickImage(source: ImageSource.gallery);
      }

      if (media != null) {
        setState(() => _capturedMedia = media);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to select media from gallery'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _retakeMedia() {
    setState(() => _capturedMedia = null);
  }

  void _submitProof() {
    if (_capturedMedia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture or select media first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // TODO: Implement proof submission logic
    // Show success animation and update task status
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Task Completed!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.monetization_on,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '+${_taskData['coinReward']} coins earned!',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Task Completion Proof',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Task details header
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _taskData['title'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_taskData['coinReward']} coins',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _taskData['requirements'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: _capturedMedia != null
                ? ProofSubmissionWidget(
                    capturedMedia: _capturedMedia!,
                    isVideoMode: _isVideoMode,
                    notesController: _notesController,
                    onRetake: _retakeMedia,
                    onSubmit: _submitProof,
                  )
                : Stack(
                    children: [
                      // Camera preview
                      if (_isCameraInitialized && _cameraController != null)
                        CameraPreviewWidget(
                          controller: _cameraController!,
                          isRecording: _isRecording,
                        )
                      else
                        const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),

                      // Media controls
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: MediaControlsWidget(
                          isVideoMode: _isVideoMode,
                          isRecording: _isRecording,
                          isFlashOn: _isFlashOn,
                          onModeToggle: () =>
                              setState(() => _isVideoMode = !_isVideoMode),
                          onFlashToggle: _toggleFlash,
                          onCapture: _isVideoMode
                              ? (_isRecording
                                  ? _stopVideoRecording
                                  : _startVideoRecording)
                              : _capturePhoto,
                          onGallery: _selectFromGallery,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
