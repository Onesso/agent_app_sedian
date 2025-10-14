import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/app_theme.dart';
import '../utils/alert_utils.dart';


const Color sidianNavy = AppTheme.primary;
const Color sidianOlive = Color(0xFF7A7A18);
const Color sidianGrayBorder = Color(0xFFD6D6D6);


class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState extends State<IdentityVerificationScreen> {
  String _selectedDocument = 'National ID';
  File? _frontIdImage;
  File? _backIdImage;
  File? _signatureImage;
  bool _frontScanning = false;
  bool _backScanning = false;
  bool _signatureScanning = false;
  bool _saving = false;
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
    } catch (_) {}
  }

  bool _canContinue() {
    if (_selectedDocument == 'National ID') {
      return _frontIdImage != null && _backIdImage != null && _signatureImage != null;
    } else {
      return _frontIdImage != null && _signatureImage != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: sidianNavy),
          onPressed: () => Navigator.pop(context),
        ),

      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        value: 0.4,
                        color: sidianNavy,
                        backgroundColor: const Color(0xFFEDEDED),
                      ),
                    ),
                    const SizedBox(height: 36),

                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Calibri',
                          fontSize: 18,
                          height: 1.5,
                          color: AppTheme.textPrimary,
                        ),
                        children: [
                          const TextSpan(
                            text:
                            "Please take clear photos of the customer's ",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          const TextSpan(
                            text: "ID document ",
                            style: TextStyle(
                              color: sidianOlive,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: "and "),
                          TextSpan(
                            text: "Signature",
                            style: TextStyle(
                              color: sidianOlive,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    const Text(
                      "Select customer's ID document",
                      style: TextStyle(
                        fontFamily: 'Calibri',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: _selectedDocument,
                      items: const [
                        DropdownMenuItem(
                            value: 'National ID', child: Text('National ID')),
                        DropdownMenuItem(
                            value: 'Passport', child: Text('Passport')),
                      ],
                      onChanged: (v) => setState(() => _selectedDocument = v ?? 'National ID'),
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: sidianGrayBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: sidianGrayBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: sidianGrayBorder),
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 15,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    if (_selectedDocument == 'National ID')
                      _buildNationalIdFlow(context)
                    else
                      _buildPassportFlow(context),
                  ],
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _canContinue() && !_saving
                      ? () async {
                    setState(() => _saving = true);
                    await Future.delayed(const Duration(seconds: 1));
                    setState(() => _saving = false);

                    showSidianAlert(
                      context,
                      message: 'Identity Verification details saved successfully',
                      type: AlertType.success,
                    );

                    await Future.delayed(const Duration(seconds: 1));
                    if (mounted) Navigator.pushNamed(context, '/address-details');
                  }
                      : null,

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    _canContinue() ? sidianNavy : Colors.grey[300],
                    foregroundColor:
                    _canContinue() ? Colors.white : Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
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
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
            ),
          ],
        ),
      ),
    );
  }

  // NATIONAL ID FLOW
  Widget _buildNationalIdFlow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusLabel(
          label: 'Front of ID',
          scanning: _frontScanning,
          captured: _frontIdImage != null,
        ),
        const SizedBox(height: 8),
        _CaptureCard(
          file: _frontIdImage,
          onTap: () => _captureImage('front'),
          scanning: _frontScanning,
        ),
        const SizedBox(height: 24),

        _StatusLabel(
          label: 'Back of ID',
          scanning: _backScanning,
          captured: _backIdImage != null,
        ),
        const SizedBox(height: 8),
        _CaptureCard(
          file: _backIdImage,
          onTap: () => _captureImage('back'),
          scanning: _backScanning,
        ),
        const SizedBox(height: 24),

        _StatusLabel(
          label: 'Signature',
          scanning: _signatureScanning,
          captured: _signatureImage != null,
        ),
        const SizedBox(height: 8),
        _CaptureCard(
          file: _signatureImage,
          onTap: () => _captureImage('signature'),
          height: 160,
          scanning: _signatureScanning,
        ),
      ],
    );
  }

  // PASSPORT FLOW
  Widget _buildPassportFlow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusLabel(
          label: 'Passport',
          scanning: _frontScanning,
          captured: _frontIdImage != null,
        ),
        const SizedBox(height: 8),
        _CaptureCard(
          file: _frontIdImage,
          onTap: () => _captureImage('passport'),
          scanning: _frontScanning,
        ),
        const SizedBox(height: 24),

        _StatusLabel(
          label: 'Signature',
          scanning: _signatureScanning,
          captured: _signatureImage != null,
        ),
        const SizedBox(height: 8),
        _CaptureCard(
          file: _signatureImage,
          onTap: () => _captureImage('signature'),
          height: 160,
          scanning: _signatureScanning,
        ),
      ],
    );
  }

  Future<void> _captureImage(String type) async {
    if (_firstCamera == null) return;

    try {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => GuidedCameraScreen(
            camera: _firstCamera!,
            headingText: 'Align the $type within the frame',
          ),
        ),
      );

      if (result == null) return;

      setState(() {
        if (type == 'front' || type == 'passport') _frontScanning = true;
        if (type == 'back') _backScanning = true;
        if (type == 'signature') _signatureScanning = true;
      });

      await Future.delayed(const Duration(seconds: 2)); // simulate scanning
      setState(() {
        switch (type) {
          case 'front':
          case 'passport':
            _frontIdImage = File(result);
            _frontScanning = false;
            break;
          case 'back':
            _backIdImage = File(result);
            _backScanning = false;
            break;
          case 'signature':
            _signatureImage = File(result);
            _signatureScanning = false;
            break;
        }
      });
    } catch (_) {}
  }
}

// -------------------------------------------
// CAPTURE CARD
// -------------------------------------------
class _CaptureCard extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;
  final bool scanning;
  final double height;

  const _CaptureCard({
    required this.file,
    required this.onTap,
    this.scanning = false,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = file != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: sidianGrayBorder),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(file!, fit: BoxFit.cover),
              ),
            if (!hasImage && !scanning)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.photo_camera_outlined,
                      color: sidianNavy, size: 32),
                  SizedBox(height: 6),
                  Text(
                    "Capture",
                    style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            if (scanning)
              Container(
                color: Colors.black.withOpacity(0.35),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: sidianOlive, strokeWidth: 3),
                      SizedBox(height: 10),
                      Text(
                        "Scanning...",
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (hasImage && !scanning)
              const Positioned(
                right: 10,
                top: 10,
                child: Icon(Icons.check_circle,
                    color: sidianOlive, size: 26),
              ),
          ],
        ),
      ),
    );
  }
}


class _StatusLabel extends StatelessWidget {
  final String label;
  final bool scanning;
  final bool captured;

  const _StatusLabel({
    required this.label,
    required this.scanning,
    required this.captured,
  });

  @override
  Widget build(BuildContext context) {
    Color color = AppTheme.textPrimary;
    IconData? icon;
    if (captured) {
      color = sidianOlive;
      icon = Icons.done_all;
    } else if (scanning) {
      color = Colors.grey;
      icon = Icons.hourglass_top;
    }

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: color,
          ),
        ),
        if (icon != null) ...[
          const SizedBox(width: 6),
          Icon(icon, size: 16, color: color),
        ],
      ],
    );
  }
}

// -------------------------------------------
// GUIDED CAMERA (same as Ecobank but themed)
// -------------------------------------------
class GuidedCameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final String headingText;

  const GuidedCameraScreen({
    super.key,
    required this.camera,
    required this.headingText,
  });

  @override
  State<GuidedCameraScreen> createState() => _GuidedCameraScreenState();
}

class _GuidedCameraScreenState extends State<GuidedCameraScreen> {
  late CameraController _controller;
  late Future<void> _ready;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller =
        CameraController(widget.camera, ResolutionPreset.high, enableAudio: false);
    _ready = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  Future<void> _shoot() async {
    try {
      await _ready;
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final XFile shot = await _controller.takePicture();
      await shot.saveTo(path);
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
      body: SafeArea(
        top: true,
        child: FutureBuilder<void>(
          future: _ready,
          builder: (_, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(
                  child: CircularProgressIndicator(color: sidianOlive));
            }
            return Stack(
              children: [
                Positioned.fill(child: CameraPreview(_controller)),
                Positioned(
                  top: 40,
                  left: 24,
                  right: 24,
                  child: Text(
                    widget.headingText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 48),
                    child: RawMaterialButton(
                      onPressed: _shoot,
                      fillColor: sidianOlive,
                      elevation: 0,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      child: const Icon(Icons.camera_alt,
                          size: 30, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
