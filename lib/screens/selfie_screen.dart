import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_data.dart';
import '../utils/alert_utils.dart';

class SelfieIntroScreen extends StatefulWidget {
  const SelfieIntroScreen({super.key});

  @override
  State<SelfieIntroScreen> createState() => _SelfieIntroScreenState();
}

class _SelfieIntroScreenState extends State<SelfieIntroScreen> {
  String? _capturedImagePath;

  Future<void> _openCamera(BuildContext context) async {
    try {
      final cams = await availableCameras();
      final back = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );
      final path = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => _SelfieCameraScreen(camera: back)),
      );
      if (path != null && context.mounted) {
        setState(() {
          _capturedImagePath = path;
          OnboardingData.I.selfiePath = path;
        });
      }
    } catch (e) {
      if (context.mounted) {
        showEcobankAlert(
          context,
          message: 'Camera not available: $e',
          type: AlertType.error,
        );
      }
    }
  }

  void _proceedToNext(BuildContext context) {
    Navigator.pushNamed(context, '/account-review');
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = _capturedImagePath != null;

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.lightBlue),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              'assets/images/Ecobank-logo.png',
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text.rich(
                const TextSpan(
                  children: [
                    TextSpan(
                      text: 'One last step, take customer\'s ',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                        height: 1.3,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    TextSpan(
                      text: 'Photo',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        height: 1.3,
                        color: AppTheme.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Upload Customer Photo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppTheme.lightBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // figma design
                  // Center(
                  //   child: SizedBox(
                  //     width: 154,
                  //     height: 152,
                  //     child: FractionallySizedBox(
                  //       widthFactor: 0.99,
                  //       child: _MinimalDashedCard(
                  //         file: hasPhoto ? File(_capturedImagePath!) : null,
                  //         onTapOrEdit: () => _openCamera(context),
                  //         height: 154,
                  //       ),
                  //     ),
                  //   ),
                  // )

                  FractionallySizedBox(
                    widthFactor: 0.99,
                    child: _MinimalDashedCard(
                      file: hasPhoto ? File(_capturedImagePath!) : null,
                      onTapOrEdit: () => _openCamera(context),
                      height: 154,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Important',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please take a clear photo using the back camera. Make sure the subject is well-lit and in focus.',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                        color: AppTheme.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasPhoto) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _proceedToNext(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightGreen,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// supporting widgetS
class _MinimalDashedCard extends StatelessWidget {
  final File? file;
  final VoidCallback onTapOrEdit;
  final double height;

  const _MinimalDashedCard({
    required this.file,
    required this.onTapOrEdit,
    this.height = 96,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = file != null;

    final content = Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: hasImage ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: hasImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                file!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: height,
              ),
            )
          : const Icon(
              Icons.photo_camera_outlined,
              size: 32,
              color: AppTheme.lightBlue,
            ),
    );

    return CustomPaint(
      painter: _DashedRRectPainter(
        color: const Color(0xFF9DB5C9),
        strokeWidth: 1.2,
        radius: 12,
        dashLength: 2,
        dashGap: 1,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: hasImage ? null : onTapOrEdit,
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              content,
              if (hasImage)
                Positioned(
                  right: -8,
                  top: -8,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onTapOrEdit,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: AppTheme.lightBlue, width: 1.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.edit,
                            size: 16, color: AppTheme.lightBlue),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashLength;
  final double dashGap;

  _DashedRRectPainter({
    required this.color,
    this.strokeWidth = 1,
    this.radius = 12,
    this.dashLength = 4,
    this.dashGap = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        final dashPath =
            metric.extractPath(distance, next.clamp(0, metric.length));
        canvas.drawPath(dashPath, paint);
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter old) =>
      color != old.color ||
      strokeWidth != old.strokeWidth ||
      radius != old.radius ||
      dashLength != old.dashLength ||
      dashGap != old.dashGap;
}

class _SelfieCameraScreen extends StatefulWidget {
  final CameraDescription camera;
  const _SelfieCameraScreen({required this.camera});

  @override
  State<_SelfieCameraScreen> createState() => _SelfieCameraScreenState();
}

class _SelfieCameraScreenState extends State<_SelfieCameraScreen> {
  late CameraController _controller;
  late Future<void> _init;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _init = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _shoot() async {
    await _init;
    final tmp = await getTemporaryDirectory();
    final path =
        '${tmp.path}/photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final x = await _controller.takePicture();
    await x.saveTo(path);
    if (!mounted) return;
    Navigator.pop(context, path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Take Photo',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _init,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          }
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _shoot,
        backgroundColor: Colors.white,
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
    );
  }
}
