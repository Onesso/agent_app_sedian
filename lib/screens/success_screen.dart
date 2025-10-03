import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Success Icon
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: AppTheme.successGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 60),
                ),
              ),

              const SizedBox(height: 40),

              // Title
              const Center(
                child: Text(
                  'Details Submitted Successfully!',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppTheme.infoBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 42),

              // Paragraphs
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5,
                    color: AppTheme.darkGray,
                  ),
                  children: const [
                    TextSpan(
                      text:
                      'We will open customer\'s account and notify them their account number ',
                    ),
                    TextSpan(
                      text: 'within the hour',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),

              const SizedBox(height: 16),

              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5,
                    color: AppTheme.darkGray,
                  ),
                  children: [
                    const TextSpan(
                      text: 'If they do not receive it by then please ',
                    ),
                    TextSpan(
                      text: 'contact us',
                      style: const TextStyle(
                        color: AppTheme.infoBlue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _onContactTap(context),
                    ),
                    const TextSpan(text: ' for assistance'),
                  ],
                ),
                textAlign: TextAlign.left,
              ),

              const SizedBox(height: 56),

              const Text(
                'Please proceed to complete their onboarding process',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.5,
                  color: AppTheme.darkGray,
                ),
                textAlign: TextAlign.left,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _handleClose(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightGreen,
                    foregroundColor: AppTheme.darkBlueHighlight,
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
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _onContactTap(BuildContext context) {
    // TODO: route to help/contact screen or open mail/phone.
    // Navigator.pushNamed(context, '/contact');
  }

  void _handleClose(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
