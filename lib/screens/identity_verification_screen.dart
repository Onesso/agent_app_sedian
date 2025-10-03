import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_data.dart';
import '../utils/alert_utils.dart';

class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  String _selectedDocument = 'National ID';
  File? _passportImage;
  File? _frontIdImage;
  File? _backIdImage;
  File? _signatureImage;

  List<CameraDescription>? _cameras;
  CameraDescription? _firstCamera;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        setState(() => _firstCamera = _cameras!.first);
      }
    } catch (_) {/* ignore */}
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _canContinue();

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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // progress
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        value: 0.40,
                        color: AppTheme.lightGreen,
                        backgroundColor: const Color(0xFFEAEFBE),
                      ),
                    ),
                    const SizedBox(height: 44),

                    const Text(
                      'Identity Verification',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        height: 1.2,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    const SizedBox(height: 16),

                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.5,
                          color: AppTheme.darkGray,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Please take a photo of customer\'s original ',
                          ),
                          TextSpan(
                            text: 'ID document',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: ' & '),
                          TextSpan(
                            text: 'Signature',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'Choose customer\'s identity document',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ID type
                    DropdownButtonFormField<String>(
                      value: (_selectedDocument == 'National ID' ||
                              _selectedDocument == 'Passport')
                          ? _selectedDocument
                          : null,
                      items: const [
                        DropdownMenuItem(
                            value: 'National ID', child: Text('National ID')),
                        DropdownMenuItem(
                            value: 'Passport', child: Text('Passport')),
                      ],
                      onChanged: (v) => setState(
                          () => _selectedDocument = v ?? 'National ID'),
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: AppTheme.darkGray),
                      decoration: InputDecoration(
                        hintText: 'Select Photo ID',
                        isDense: true,
                        filled: true,
                        fillColor: AppTheme.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppTheme.textFieldOutline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppTheme.textFieldOutline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppTheme.lightBlue, width: 1.5),
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 14,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const _SectionLabel('Scan your photo ID'),
                    const SizedBox(height: 12),

                    if (_selectedDocument == 'National ID') ...[
                      Row(
                        children: [
                          Expanded(
                            child: _CaptureCard(
                              file: _frontIdImage,
                              label: 'Scan Front ID',
                              onTap: () => _openCamera('front'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _CaptureCard(
                              file: _backIdImage,
                              label: 'Scan Back ID',
                              onTap: () => _openCamera('back'),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      _CaptureCard(
                        file: _passportImage,
                        label: 'Scan Passport',
                        onTap: () => _openCamera('passport'),
                      ),
                    ],
                    const SizedBox(height: 20),

                    const _SectionLabel('Add a signature'),
                    const SizedBox(height: 12),
                    _CaptureCard(
                      file: _signatureImage,
                      label: 'Capture',
                      height: 140,
                      onTap: () => _openCamera('signature'),
                    ),
                  ],
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: canContinue ? _continue : null,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return const Color(0xFFDDE9A6);
                      }
                      return AppTheme.lightGreen;
                    }),
                    foregroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return const Color(0xFF9E9E9E);
                      }
                      return AppTheme.darkBlueHighlight;
                    }),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canContinue() {
    if (_selectedDocument == 'National ID') {
      return _frontIdImage != null &&
          _backIdImage != null &&
          _signatureImage != null;
    }
    return _passportImage != null && _signatureImage != null;
  }

  Future<void> _openCamera(String type) async {
    if (_firstCamera == null) {
      return;
    }

    try {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => CameraScreen(camera: _firstCamera!),
        ),
      );

      if (result != null) {
        setState(() {
          switch (type) {
            case 'front':
              _frontIdImage = File(result);
              break;
            case 'back':
              _backIdImage = File(result);
              break;
            case 'passport':
              _passportImage = File(result); // NEW
              break;
            default:
              _signatureImage = File(result);
          }
        });
      }
    } catch (_) {
      // swallow errors here — per request, no alerts during capture
    }
  }

  void _continue() {
    OnboardingData.I.idType = _selectedDocument;
    if (_selectedDocument == 'National ID') {
      OnboardingData.I.frontIdImage = _frontIdImage;
      OnboardingData.I.backIdImage = _backIdImage;
    } else {
      OnboardingData.I.frontIdImage = _passportImage;
      OnboardingData.I.backIdImage = null;
    }

    OnboardingData.I.signatureImage = _signatureImage;
    Navigator.of(context).pushNamed('/address-details');

    showEcobankAlert(
      context,
      message: 'Identity details saved',
      type: AlertType.success,
    );
  }
}

// small widgets
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppTheme.darkGray,
      ),
    );
  }
}

class _CaptureCard extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;
  final String label;
  final double height;

  const _CaptureCard({
    required this.file,
    required this.onTap,
    required this.label,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = file != null;

    return CustomPaint(
      painter: DashedRRectPainter(
        color: const Color(0xFF9DB5C9),
        strokeWidth: 1.2,
        radius: 10,
        dashLength: 4,
        dashGap: 3,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: hasImage ? Colors.white : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: hasImage
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(file!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.photo_camera_outlined,
                                size: 28, color: AppTheme.lightBlue),
                            const SizedBox(height: 8),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppTheme.darkGray,
                              ),
                            ),
                          ],
                        ),
                ),
                if (hasImage)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 14,
                        color: AppTheme.lightBlue,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashLength;
  final double dashGap;

  DashedRRectPainter({
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
  bool shouldRepaint(covariant DashedRRectPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      radius != oldDelegate.radius ||
      dashLength != oldDelegate.dashLength ||
      dashGap != oldDelegate.dashGap;
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  const CameraScreen({super.key, required this.camera});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final XFile picture = await _controller.takePicture();
      await picture.saveTo(path);
      if (!mounted) return;
      Navigator.of(context).pop(path);
    } catch (_) {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Take Photo',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          }
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.lightGreen),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        backgroundColor: Colors.white,
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
    );
  }
}
