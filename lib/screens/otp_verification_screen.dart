import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/alert_utils.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber; // E.164 format e.g. +254712345678
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _timeRemaining = 60;
  bool _submitting = false;
  bool _resending = false;

  static const Color sidianNavy = Color(0xFF0B2240);
  static const Color sidianOlive = Color(0xFF7A7A18);
  static const Color sidianGray = Color(0xFFD6D6D6);

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  /* ---------------- Timer ---------------- */
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeRemaining > 0) {
        setState(() => _timeRemaining--);
      } else {
        t.cancel();
        showSidianAlert(
          context,
          message: 'OTP expired. Please request a new one.',
          type: AlertType.error,
        );
      }
    });
  }

  String get _formattedTime {
    final m = _timeRemaining ~/ 60;
    final s = _timeRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /* ---------------- Helpers ---------------- */
  String get _maskedPhoneNumber {
    final p = widget.phoneNumber;
    if (p.length >= 4) return '****${p.substring(p.length - 4)}';
    return p;
  }

  String get _maskedEmail {
    final e = widget.email;
    if (e.contains('@')) {
      final parts = e.split('@');
      final user = parts[0];
      final dom = parts[1];
      final maskedUser = user.length > 3 ? '${user.substring(0, 3)}***' : user;
      return '$maskedUser@$dom';
    }
    return e;
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty && value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    setState(() {});
  }

  String get _otpValue => _controllers.map((c) => c.text).join();
  bool get _isOtpComplete => _otpValue.length == 6;

  void _clearOtp() {
    for (final c in _controllers) c.clear();
    _focusNodes.first.requestFocus();
    setState(() {});
  }

  /* ---------------- Submit Simulation ---------------- */
  Future<void> _submitOtp() async {
    if (!_isOtpComplete) {
      showSidianAlert(
        context,
        message: 'Please enter the full 6-digit OTP.',
        type: AlertType.error,
      );
      return;
    }

    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _submitting = false);

    if (!mounted) return;

    showSidianAlert(
      context,
      message: 'Verification successful!',
      type: AlertType.success,
    );

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/success');
    }
  }

  Future<void> _resendOtp() async {
    if (_resending) return;
    setState(() => _resending = true);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _resending = false;
      _timeRemaining = 60;
    });
    _startTimer();

    showSidianAlert(
      context,
      message: 'A new OTP has been sent to customer\'s phone and email.',
      type: AlertType.info,
    );
  }

  /* ---------------- UI ---------------- */
  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Verify with OTP',
                style: TextStyle(
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: sidianNavy,
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 16,
                    color: sidianNavy,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text:
                      'A one-time PIN has been sent to customer\'s mobile number ',
                    ),
                    TextSpan(
                      text: _maskedPhoneNumber,
                      style: const TextStyle(
                        color: sidianOlive,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' and email '),
                    TextSpan(
                      text: _maskedEmail,
                      style: const TextStyle(
                        color: sidianOlive,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // OTP input boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: sidianNavy,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          const BorderSide(color: sidianGray, width: 1.3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          const BorderSide(color: sidianNavy, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          const BorderSide(color: sidianGray, width: 1.3),
                        ),
                      ),
                      onChanged: (v) => _onDigitChanged(v, i),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 36),

              // Timer or resend
              Center(
                child: _timeRemaining > 0
                    ? Text(
                  'Time remaining: $_formattedTime',
                  style: const TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 15,
                    color: sidianNavy,
                  ),
                )
                    : TextButton(
                  onPressed: _resendOtp,
                  child: _resending
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text(
                    'Resend OTP',
                    style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: sidianOlive,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: (_isOtpComplete && !_submitting)
                      ? _submitOtp
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sidianNavy,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: sidianNavy.withOpacity(0.3),
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
                    child: _submitting
                        ? Row(
                      key: const ValueKey('verifying'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Verifying...',
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                        : const Text(
                      'Verify OTP',
                      key: ValueKey('verify'),
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
      ),
    );
  }
}
