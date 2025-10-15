import 'package:flutter/material.dart';
import '../utils/alert_utils.dart';

class AccountReviewScreen extends StatefulWidget {
  const AccountReviewScreen({super.key});

  @override
  State<AccountReviewScreen> createState() => _AccountReviewScreenState();
}

class _AccountReviewScreenState extends State<AccountReviewScreen> {
  static const Color sidianNavy = Color(0xFF0B2240);
  static const Color sidianOlive = Color(0xFF7A7A18);
  static const Color sidianGray = Color(0xFFD6D6D6);

  bool _submitting = false;

  final Map<String, String> _userDetails = const {
    'Name': 'Brown Bet Balala',
    'National ID': '39916324',
    'Phone Number': '+254716472964',
    'Email Address': 'newiachi@gmail.com',
    'Physical Address': 'Nairobi Residence',
  };

  final Map<String, String> _accountDetails = const {
    'Account Type': 'Flexxy Youth Account',
    'Branch': 'Industrial Area',
  };

  Future<void> _submitApplication(BuildContext context) async {
    if (_submitting) return;

    setState(() => _submitting = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    showSidianAlert(
      context,
      message: 'Message sent to customer\'s phone and email',
      type: AlertType.success,
    );

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushNamed(context, '/otp-verification');
    }

    setState(() => _submitting = false);
  }

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
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: const LinearProgressIndicator(
                  value: 1.0,
                  minHeight: 4,
                  color: sidianNavy,
                  backgroundColor: Color(0xFFEDEDED),
                ),
              ),
              const SizedBox(height: 36),

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
                    const TextSpan(text: 'Please review customer\'s '),
                    TextSpan(
                      text: 'Account Details ',
                      style: TextStyle(
                        color: sidianOlive,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: 'before submission.'),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Personal Details
              const _SectionHeader(title: 'Personal Details'),
              const SizedBox(height: 12),
              _DetailCard(details: _userDetails),

              const SizedBox(height: 28),

              // Account Details
              const _SectionHeader(title: 'Account Details'),
              const SizedBox(height: 12),
              _DetailCard(details: _accountDetails),

              const SizedBox(height: 48),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _submitting ? null : () => _submitApplication(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sidianNavy,
                    foregroundColor: Colors.white,
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
                    duration: const Duration(milliseconds: 250),
                    child: _submitting
                        ? Row(
                      key: const ValueKey('submitting'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Submitting...',
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
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    )
                        : const Text(
                      'Submit & Finish',
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
      ),
    );
  }
}

/* ---------------- SECTION HEADER ---------------- */
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  static const Color sidianOlive = Color(0xFF7A7A18);
  static const Color sidianNavy = Color(0xFF0B2240);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 20,
          decoration: BoxDecoration(
            color: sidianOlive,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Calibri',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: sidianNavy,
          ),
        ),
      ],
    );
  }
}

/* ---------------- DETAIL CARD ---------------- */
class _DetailCard extends StatelessWidget {
  final Map<String, String> details;
  const _DetailCard({required this.details});

  static const Color sidianNavy = Color(0xFF0B2240);
  static const Color sidianGray = Color(0xFFD6D6D6);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: sidianGray),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: details.entries.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 130,
                  child: Text(
                    e.key,
                    style: const TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: sidianNavy,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    e.value,
                    style: const TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 15,
                      color: sidianNavy,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
