import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  static const Color sidianNavy = Color(0xFF0B2240);
  static const Color sidianOlive = Color(0xFF7A7A18);
  static const Color sidianGray = Color(0xFFD6D6D6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: sidianOlive.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: sidianOlive, width: 2),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: sidianOlive,
                  size: 70,
                ),
              ),

              const SizedBox(height: 36),

              //  Title
              const Text(
                'Details Submitted Successfully!',
                style: TextStyle(
                  fontFamily: 'Calibri',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: sidianNavy,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 16,
                    height: 1.6,
                    color: sidianNavy,
                  ),
                  children: const [
                    TextSpan(
                      text:
                      'We will open the customer’s account and notify them of their account number ',
                    ),
                    TextSpan(
                      text: 'within the hour.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 16,
                    height: 1.6,
                    color: sidianNavy,
                  ),
                  children: [
                    const TextSpan(text: 'If they do not receive it by then, please '),
                    TextSpan(
                      text: 'contact us',
                      style: const TextStyle(
                        color: sidianOlive,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _onContactTap(context),
                    ),
                    const TextSpan(text: ' for assistance.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              Container(
                width: 80,
                height: 2,
                color: sidianGray,
              ),

              const SizedBox(height: 40),

              const Text(
                'You may now proceed to complete the customer’s onboarding process.',
                style: TextStyle(
                  fontFamily: 'Calibri',
                  fontSize: 16,
                  height: 1.6,
                  color: sidianNavy,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => _handleClose(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sidianNavy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Calibri',
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact support coming soon...'),
        backgroundColor: sidianNavy,
      ),
    );
  }

  void _handleClose(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
