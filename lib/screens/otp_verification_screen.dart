import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../utils/alert_utils.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
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
  int _timeRemaining = 60; // Starting time in seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        timer.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    showEcobankAlert(
      context,
      message: 'OTP has expired. Please request a new one.',
      type: AlertType.error,
    );
  }

  String get _formattedTime {
    final minutes = _timeRemaining ~/ 60;
    final seconds = _timeRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get _maskedPhoneNumber {
    if (widget.phoneNumber.length >= 4) {
      return '****${widget.phoneNumber.substring(widget.phoneNumber.length - 4)}';
    }
    return widget.phoneNumber;
  }

  String get _maskedEmail {
    if (widget.email.contains('@')) {
      final parts = widget.email.split('@');
      final username = parts[0];
      final domain = parts[1];
      final maskedUsername =
          username.length > 4 ? '${username.substring(0, 4)}****' : username;
      return '$maskedUsername@$domain';
    }
    return widget.email;
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty && value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  void _onDigitBackspace(int index) {
    if (index > 0 && _controllers[index].text.isEmpty) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _otpValue {
    return _controllers.map((controller) => controller.text).join();
  }

  bool get _isOtpComplete {
    return _otpValue.length == 6 &&
        _otpValue.split('').every((digit) => digit.isNotEmpty);
  }

  Future<void> _submitOtp() async {
    if (!_isOtpComplete) {
      showEcobankAlert(
        context,
        message: 'Please enter complete OTP',
        type: AlertType.error,
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppTheme.lightGreen),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.pop(context); // Remove loading dialog

    if (_otpValue == '123456') {
      // Demo OTP for testing
      showEcobankAlert(
        context,
        message: 'OTP verified successfully!',
        type: AlertType.success,
      );
      Navigator.pushReplacementNamed(context, '/success');
    } else {
      showEcobankAlert(
        context,
        message: 'Invalid OTP. Please try again.',
        type: AlertType.error,
      );
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify with OTP',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: AppTheme.darkGray,
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.4,
                    color: AppTheme.darkGray,
                  ),
                  children: [
                    const TextSpan(
                        text:
                            'A one-time PIN (OTP) has been sent to customer\'s mobile number at '),
                    TextSpan(
                      text: _maskedPhoneNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightBlue,
                      ),
                    ),
                    const TextSpan(text: ' and email at '),
                    TextSpan(
                      text: _maskedEmail,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightBlue,
                      ),
                    ),
                    const TextSpan(
                        text:
                            '. Please enter it below to verify their mobile number'),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 55,
                    child: RawKeyboardListener(
                      focusNode: FocusNode(), // new focus node for the listener
                      onKey: (event) {
                        if (event is RawKeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.backspace) {
                          // If current field is empty, move focus back
                          if (_controllers[index].text.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        }
                      },
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppTheme.darkGray,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.all(0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppTheme.darkGray.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppTheme.lightBlue,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppTheme.darkGray.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1]
                                .requestFocus(); // move forward
                          }
                          _onDigitChanged(value, index);
                        },
                        onTap: () {
                          _controllers[index].selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: _controllers[index].text.length),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Time Remaining: $_formattedTime',
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppTheme.darkGray,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _timeRemaining > 0 ? _submitOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isOtpComplete && _timeRemaining > 0
                        ? AppTheme.lightGreen
                        : AppTheme.lightGreen.withOpacity(0.6),
                    foregroundColor: _isOtpComplete && _timeRemaining > 0
                        ? AppTheme.darkBlueHighlight
                        : const Color(0xFF9E9E9E),
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
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: _timeRemaining == 0 ? _resendOtp : null,
                  child: Text(
                    _timeRemaining == 0
                        ? 'Resend OTP'
                        : 'Resend OTP in $_formattedTime',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: _timeRemaining == 0
                          ? AppTheme.lightBlue
                          : AppTheme.darkGray.withOpacity(0.6),
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

  void _resendOtp() {
    setState(() {
      _timeRemaining = 60; // Reset timer to 1 minute
    });
    _startTimer();

    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();

    showEcobankAlert(
      context,
      message: 'New OTP sent successfully!',
      type: AlertType.info,
    );
  }
}
