import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/alert_utils.dart';

class AccountReviewScreen extends StatelessWidget {
  const AccountReviewScreen({super.key});

  // Sample user data - replace with actual data from form/state management
  final Map<String, String> _userDetails = const {
    'name': 'Brown Bet Balala',
    'nationalId': '39916324',
    'phoneNumber': '254716472964',
    'emailAddress': 'newiachibs@gmail.com',
    'physicalAddress': 'Nairobi#apsdjbd residence',
  };

  final Map<String, String> _accountDetails = const {
    'accountType': 'Pay As You Transact',
    'branch': 'Industrial Area',
  };

  Future<void> _submitApplication(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppTheme.lightGreen),
      ),
    );

    // Simulate API call to submit application
    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;
    Navigator.pop(context); // Remove loading dialog

    Navigator.pushNamed(context, '/otp-verification');

    showEcobankAlert(
      context,
      message: 'Message sent to phone and email',
      type: AlertType.success,
    );
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
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Title
              const Text(
                'Finally, please review customer\'s account details and submit application',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                  height: 1.3,
                  color: AppTheme.darkGray,
                ),
              ),

              const SizedBox(height: 32),

              // User Details Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDetailRow('Name:', _userDetails['name']!),
                    const SizedBox(height: 16),
                    _buildDetailRow('National ID:', _userDetails['nationalId']!),
                    const SizedBox(height: 16),
                    _buildDetailRow('Phone Number:', _userDetails['phoneNumber']!),
                    const SizedBox(height: 16),
                    _buildDetailRow('Email Address:', _userDetails['emailAddress']!),
                    const SizedBox(height: 16),
                    _buildDetailRow('Physical Address:', _userDetails['physicalAddress']!),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Account Details Section
              const Text(
                'Account Details',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppTheme.darkGray,
                ),
              ),

              const SizedBox(height: 16),

              // Account Details Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDetailRow('Account Type:', _accountDetails['accountType']!),
                    const SizedBox(height: 16),
                    _buildDetailRow('Branch:', _accountDetails['branch']!),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _submitApplication(context),
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
                  child: const Text('Submit & Finish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppTheme.darkGray,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppTheme.darkGray,
            ),
          ),
        ),
      ],
    );
  }
}