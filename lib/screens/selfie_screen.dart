import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/alert_utils.dart'; // ✅ to use showSidianAlert

class SelfieIntroScreen extends StatefulWidget {
  const SelfieIntroScreen({super.key});

  @override
  State<SelfieIntroScreen> createState() => _SelfieIntroScreenState();
}

class _SelfieIntroScreenState extends State<SelfieIntroScreen> {
  static const Color sidianNavy = Color(0xFF0B2240);
  static const Color sidianOlive = Color(0xFF7A7A18);

  String? _capturedImagePath;
  bool _scanning = false;
  double _progress = 0;
  bool? _verified;
  bool _saving = false; // 👈 added for animated button

  Future<void> _openCamera(BuildContext context) async {
    try {
      final cams = await availableCameras();
      final back = cams.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );

      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => _SelfieCameraScreen(camera: back)),
      );

      if (result != null) {
        setState(() {
          _capturedImagePath = result;
          _verified = null;
        });
        _simulateVerification();
      }
    } catch (_) {
      _showMessage('Unable to access the camera. Please try again.');
    }
  }

  void _simulateVerification() async {
    setState(() {
      _scanning = true;
      _progress = 0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => _progress = i / 10);
    }

    setState(() {
      _verified = true;
      _scanning = false;
    });

    showSidianAlert(
      context,
      message: 'Liveness verified successfully',
      type: AlertType.success,
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: sidianNavy,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = _capturedImagePath != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: sidianNavy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const LinearProgressIndicator(
                      value: 1.0,
                      minHeight: 4,
                      color: sidianNavy,
                      backgroundColor: Color(0xFFEDEDED),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 20,
                        height: 1.4,
                        color: sidianNavy,
                      ),
                      children: [
                        const TextSpan(text: 'One last step, take customer\'s '),
                        TextSpan(
                          text: 'Photo',
                          style: TextStyle(
                            color: sidianOlive,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Photo capture
                  Center(
                    child: _PhotoCard(
                      file: hasPhoto ? File(_capturedImagePath!) : null,
                      onTap: () => _openCamera(context),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (_verified != null) _LivenessChip(isLive: _verified!),

                  const SizedBox(height: 30),

                  // Tips
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFD6D6D6)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important',
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold,
                            color: sidianNavy,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Use the BACK camera. Ensure the face is centered, steady, and well-lit.',
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: 15,
                            height: 1.4,
                            color: sidianNavy,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  if (hasPhoto)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _saving
                            ? null
                            : () async {
                          setState(() => _saving = true);
                          await Future.delayed(
                              const Duration(seconds: 2));

                          showSidianAlert(
                            context,
                            message: 'Photo saved successfully',
                            type: AlertType.success,
                          );

                          await Future.delayed(
                              const Duration(seconds: 2));
                          if (mounted) {
                            Navigator.pushNamed(
                                context, '/account-review');
                          }

                          setState(() => _saving = false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: sidianNavy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                          textStyle: const TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _saving
                              ? Row(
                            key: const ValueKey('saving'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Saving...',
                                style: TextStyle(
                                  fontFamily: 'Calibri',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ],
                          )
                              : const Text(
                            'Continue',
                            key: ValueKey('normal'),
                            style: TextStyle(
                              fontFamily: 'Calibri',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            if (_scanning) _ScanningOverlay(progress: _progress),
          ],
        ),
      ),
    );
  }
}

/* ---------------- Photo Card ---------------- */
class _PhotoCard extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;
  const _PhotoCard({this.file, required this.onTap});

  static const Color sidianNavy = Color(0xFF0B2240);
  static const Color sidianOlive = Color(0xFF7A7A18);

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: hasFile ? sidianOlive : const Color(0xFFD6D6D6),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: hasFile
              ? Image.file(file!, fit: BoxFit.cover)
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined,
                  size: 40, color: sidianNavy.withOpacity(0.8)),
              const SizedBox(height: 12),
              Text(
                'Tap to capture photo',
                style: TextStyle(
                  fontFamily: 'Calibri',
                  fontSize: 15,
                  color: sidianNavy.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- Liveness Chip ---------------- */
class _LivenessChip extends StatelessWidget {
  final bool isLive;
  const _LivenessChip({required this.isLive});

  @override
  Widget build(BuildContext context) {
    final ok = isLive;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: ok ? const Color(0xFFE6F7E7) : const Color(0xFFFFEFEF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ok ? const Color(0xFF7A7A18) : Colors.redAccent,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.cancel,
            color: ok ? const Color(0xFF00693E) : Colors.redAccent,
          ),
          const SizedBox(width: 10),
          Text(
            ok ? 'Liveness Verified' : 'Verification Failed',
            style: const TextStyle(
              fontFamily: 'Calibri',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF0B2240),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- Scanning Overlay ---------------- */
class _ScanningOverlay extends StatelessWidget {
  final double progress;
  const _ScanningOverlay({required this.progress});

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).toStringAsFixed(0);
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xFF0B2240),
              ),
              const SizedBox(height: 12),
              const Text(
                'Verifying...',
                style: TextStyle(
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF0B2240),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontFamily: 'Calibri',
                  fontSize: 14,
                  color: Color(0xFF0B2240),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- Camera Screen ---------------- */
class _SelfieCameraScreen extends StatefulWidget {
  final CameraDescription camera;
  const _SelfieCameraScreen({required this.camera});

  @override
  State<_SelfieCameraScreen> createState() => _SelfieCameraScreenState();
}

class _SelfieCameraScreenState extends State<_SelfieCameraScreen> {
  late CameraController _controller;
  late Future<void> _init;
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    _controller =
        CameraController(widget.camera, ResolutionPreset.high, enableAudio: false);
    _init = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    if (_capturing) return;
    setState(() => _capturing = true);
    try {
      final dir = await getTemporaryDirectory();
      final file =
          '${dir.path}/selfie_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final photo = await _controller.takePicture();
      await photo.saveTo(file);
      if (mounted) Navigator.pop(context, file);
    } catch (_) {
      setState(() => _capturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _init,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(child: CameraPreview(_controller)),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
              Positioned(
                bottom: 60,
                child: GestureDetector(
                  onTap: _capture,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Color(0xFF0B2240), size: 32),
                  ),
                ),
              ),
              if (_capturing)
                Container(
                  color: Colors.black45,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
