import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_data.dart';
import '../utils/alert_utils.dart';

class AccountRegistrationScreen extends StatefulWidget {
  const AccountRegistrationScreen({super.key});

  @override
  State<AccountRegistrationScreen> createState() =>
      _AccountRegistrationScreenState();
}

class _AccountRegistrationScreenState extends State<AccountRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState<String>>();
  final _phoneKey = GlobalKey<FormFieldState<PhoneNumber>>();

  final _emailController = TextEditingController();
  PhoneNumber? _phone;
  String _phoneE164 = '';
  bool _saving = false;

  static const Color sidianNavy = Color(0xFF0B2240);
  static const Color sidianOlive = Color(0xFF7A7A18);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    final emailOk =
    RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(_emailController.text.trim());
    final phoneOk = _phoneE164.isNotEmpty;
    return emailOk && phoneOk;
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bar — navy blue
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const LinearProgressIndicator(
                    minHeight: 4,
                    value: 0.15,
                    color: sidianNavy,
                    backgroundColor: Color(0xFFEDEDED),
                  ),
                ),
                const SizedBox(height: 36),

                // Intro text
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 20,
                      height: 1.5,
                      color: AppTheme.textPrimary,
                    ),
                    children: [
                      TextSpan(
                        text:
                        "Let's begin the process by verifying customer\'s ",
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: "Phone Number ",
                        style: TextStyle(
                          color: sidianOlive,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "& ",
                        style: TextStyle(color: AppTheme.textPrimary),
                      ),
                      TextSpan(
                        text: "Email Address",
                        style: TextStyle(
                          color: sidianOlive,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Phone Number
                const _FieldLabel('Phone Number'),
                const SizedBox(height: 8),
                PhoneFormField(
                  key: _phoneKey,
                  initialValue: const PhoneNumber(isoCode: IsoCode.KE, nsn: ''),
                  countrySelectorNavigator:
                  const CountrySelectorNavigator.bottomSheet(),
                  isCountrySelectionEnabled: true,
                  isCountryButtonPersistent: true,
                  countryButtonStyle: const CountryButtonStyle(
                    showFlag: true,
                    showIsoCode: false,
                    showDialCode: false,
                    flagSize: 18,
                  ),
                  decoration: _inputDecoration(hint: '0712 345 678'),
                  validator: PhoneValidator.compose([
                    PhoneValidator.required(context),
                    PhoneValidator.validMobile(context),
                  ]),
                  onChanged: (phone) {
                    _phone = phone;
                    _phoneE164 =
                    (phone == null) ? '' : '+${phone.countryCode}${phone.nsn}';
                    _phoneKey.currentState?.validate();
                    setState(() {});
                  },
                ),
                _ErrorArea(message: _phoneKey.currentState?.errorText),

                const SizedBox(height: 16),

                // Email Address
                const _FieldLabel('Email Address'),
                const SizedBox(height: 8),
                TextFormField(
                  key: _emailKey,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(hint: 'example@domain.com'),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Email is required';
                    final ok =
                    RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
                    if (!ok) return 'Enter a valid email';
                    return null;
                  },
                  onChanged: (_) {
                    _emailKey.currentState?.validate();
                    setState(() {});
                  },
                ),
                _ErrorArea(message: _emailKey.currentState?.errorText),

                const SizedBox(height: 40),

                // Continue Button with animation
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed:
                    (_canSubmit && !_saving) ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _canSubmit ? sidianNavy : sidianNavy.withOpacity(0.3),
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
                      duration: const Duration(milliseconds: 200),
                      child: _saving
                          ? Row(
                        key: const ValueKey('saving'),
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              strokeWidth: 2.5,
                              color: Colors.white,
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
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Calibri',
        color: Colors.grey,
        fontSize: 15,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD6D6D6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFD6D6D6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFD6D6D6),
          width: 1.4,
        ),
      ),
      errorStyle:
      const TextStyle(height: 0, fontSize: 0, color: Colors.transparent),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      showSidianAlert(
        context,
        message: 'Please fill all required fields correctly.',
        type: AlertType.error,
      );
      return;
    }

    setState(() => _saving = true);

    await Future.delayed(const Duration(seconds: 2));

    OnboardingData.I.email = _emailController.text.trim();
    OnboardingData.I.phoneE164 = _phoneE164;

    showSidianAlert(
      context,
      message: 'Details saved successfully!',
      type: AlertType.success,
    );

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pushNamed(context, '/identity-verification');
    }

    setState(() => _saving = false);
  }
}

/* ------------------ Field Label ------------------ */
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Calibri',
          fontSize: 15,
          color: AppTheme.textPrimary,
        ),
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/* ------------------ Error Display ------------------ */
class _ErrorArea extends StatelessWidget {
  final String? message;
  const _ErrorArea({this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: (message == null)
          ? const SizedBox(height: 20)
          : SizedBox(
        height: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline,
                size: 15, color: Colors.redAccent),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                message!,
                style: const TextStyle(
                  fontFamily: 'Calibri',
                  fontSize: 13,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
