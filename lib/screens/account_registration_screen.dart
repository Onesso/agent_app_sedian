import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../models/onboarding_data.dart';

class AccountRegistrationScreen extends StatefulWidget {
  const AccountRegistrationScreen({super.key});

  @override
  State<AccountRegistrationScreen> createState() => _AccountRegistrationScreenState();
}

class _AccountRegistrationScreenState extends State<AccountRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Keys so we can read current errorText and revalidate on change
  final _emailFieldKey = GlobalKey<FormFieldState<String>>();
  final _phoneFieldKey = GlobalKey<FormFieldState<PhoneNumber>>();

  final _email = TextEditingController();

  PhoneNumber? _phone;      // parsed phone
  String _phoneE164 = '';   // +2547xxxxxxxx

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    // quick, lightweight check (form will still validate on press)
    final emailOk = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(_email.text.trim());
    final phoneOk = _phoneE164.isNotEmpty;
    return emailOk && phoneOk;
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    value: 0.20,
                    color: AppTheme.lightGreen,
                    backgroundColor: const Color(0xFFEAEFBE),
                  ),
                ),
                const SizedBox(height: 44),

                const Text(
                  'Account Registration',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    height: 1.2,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 16),

                Text.rich(
                  const TextSpan(
                    children: [
                      TextSpan(
                        text: 'We need to secure customer\'s Account. Provide their ',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.5,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      TextSpan(
                        text: 'Email Address',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 1.5,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      TextSpan(
                        text: ' & ',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.5,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      TextSpan(
                        text: 'Phone Number',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 1.5,
                          color: AppTheme.darkGray,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const _FieldLabel('Email Address'),
                const SizedBox(height: 8),
                TextFormField(
                  key: _emailFieldKey,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _fieldDecoration(hint: ''),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Email is required';
                    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
                    if (!ok) return 'Enter a valid email';
                    return null;
                  },
                  onChanged: (_) {
                    _emailFieldKey.currentState?.validate(); // clear error as user fixes it
                    setState(() {});
                  },
                ),
                _ErrorArea(message: _emailFieldKey.currentState?.errorText),

                const SizedBox(height: 8),

                const _FieldLabel('Phone Number'),
                const SizedBox(height: 8),

                PhoneFormField(
                  key: _phoneFieldKey,
                  initialValue: const PhoneNumber(isoCode: IsoCode.KE, nsn: ''),
                  countrySelectorNavigator: const CountrySelectorNavigator.bottomSheet(),
                  isCountrySelectionEnabled: true,
                  isCountryButtonPersistent: true,
                  countryButtonStyle: const CountryButtonStyle(
                    showFlag: true,
                    showIsoCode: false,
                    showDialCode: false,
                    flagSize: 18,
                  ),
                  decoration: _phoneDecoration(),
                  validator: PhoneValidator.compose([
                    PhoneValidator.required(context),
                    PhoneValidator.validMobile(context),
                  ]),
                  onChanged: (phone) {
                    _phone = phone;
                    _phoneE164 = (phone == null) ? '' : '+${phone.countryCode}${phone.nsn}';
                    _phoneFieldKey.currentState?.validate(); // clear error as user fixes it
                    setState(() {});
                  },
                  textInputAction: TextInputAction.done,
                ),
                _ErrorArea(message: _phoneFieldKey.currentState?.errorText),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _canSubmit ? _submit : null,
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
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Common text field decoration (hide Flutter default error line)
  InputDecoration _fieldDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppTheme.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.textFieldOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.textFieldOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.lightBlue, width: 1.5),
      ),
      // suppress default error line so our custom one is the only thing visible
      errorStyle: const TextStyle(height: 0, fontSize: 0, color: Colors.transparent),
    );
  }

  // PhoneFormField decoration with hidden default error line too
  InputDecoration _phoneDecoration() => InputDecoration(
    hintText: '0700 000 000',
    isDense: true,
    filled: true,
    fillColor: AppTheme.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.textFieldOutline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.textFieldOutline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.lightBlue, width: 1.5),
    ),
    errorStyle: const TextStyle(height: 0, fontSize: 0, color: Colors.transparent),
  );

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    OnboardingData.I.email     = _email.text.trim();
    OnboardingData.I.phoneE164 = _phoneE164;
    Navigator.pushNamed(context, '/identity-verification');
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppTheme.darkGray,
            ),
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppTheme.errorRed,
            ),
          ),
        ],
      ),
    );
  }
}

/// Fixed-height error slot with red info icon
class _ErrorArea extends StatelessWidget {
  final String? message;
  const _ErrorArea({this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      child: (message == null)
          ? const SizedBox(height: 22, key: ValueKey('empty'))
          : SizedBox(
        key: const ValueKey('error'),
        height: 22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 16, color: AppTheme.alertError),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                message!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 13,
                  color: AppTheme.alertError,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
