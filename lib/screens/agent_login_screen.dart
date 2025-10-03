import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/alert_utils.dart';

class AgentLoginScreen extends StatefulWidget {
  const AgentLoginScreen({super.key});

  @override
  State<AgentLoginScreen> createState() => _AgentLoginScreenState();
}

class _AgentLoginScreenState extends State<AgentLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Keys that let us read each field’s current errorText and revalidate on change
  final _emailFieldKey     = GlobalKey<FormFieldState<String>>();
  final _passwordFieldKey  = GlobalKey<FormFieldState<String>>();

  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(() => setState(() {}));
    _passwordCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool get _canSignIn =>
      _emailCtrl.text.trim().isNotEmpty && _passwordCtrl.text.length >= 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                // Centered logo
                Center(
                  child: Image.asset(
                    'assets/images/Ecobank-logo.png',
                    height: 64,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 28),

                // Centered title & subtitle
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Welcome Agent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                          height: 1.25,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Sign in to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: AppTheme.darkGray,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Email
                const _FieldLabel('Email Address'),
                const SizedBox(height: 8),
                TextFormField(
                  key: _emailFieldKey,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(hint: 'Enter your Ecobank email address'),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Email is required';
                    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
                    if (!ok) return 'Enter a valid email';
                    return null;
                  },
                  onChanged: (_) {
                    // Re-validate immediately so the custom error clears while typing
                    _emailFieldKey.currentState?.validate();
                    setState(() {});
                  },
                ),
                // Fixed-height custom error area (no jump)
                _ErrorArea(message: _emailFieldKey.currentState?.errorText),

                const SizedBox(height: 8),

                // Password
                const _FieldLabel('Password'),
                const SizedBox(height: 8),
                TextFormField(
                  key: _passwordFieldKey,
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  decoration: _inputDecoration(hint: 'Enter your password').copyWith(
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppTheme.darkGray,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'At least 6 characters';
                    return null;
                  },
                  onChanged: (_) {
                    _passwordFieldKey.currentState?.validate();
                    setState(() {});
                  },
                ),
                _ErrorArea(message: _passwordFieldKey.currentState?.errorText),

                const SizedBox(height: 12),

                // CTA
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _canSignIn ? _signIn : null,
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color(0xFFDDE9A6); // pale lime (disabled)
                        }
                        return AppTheme.lightGreen; // lime (enabled)
                      }),
                      foregroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color(0xFF9E9E9E); // grey text (disabled)
                        }
                        return AppTheme.darkBlueHighlight;
                      }),
                      elevation: const MaterialStatePropertyAll(0),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      textStyle: const MaterialStatePropertyAll(
                        TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    child: const Text('Sign In'),
                  ),
                ),

                const SizedBox(height: 16),

                // Centered help link
                Center(
                  child: TextButton(
                    onPressed: () {
                      showEcobankAlert(
                        context,
                        message: 'Need help? Call (+254) 709 573 000',
                        type: AlertType.info,
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.lightBlue,
                    ),
                    child: const Text(
                      'Need help?',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 52),

                // Centered footer
                const Center(
                  child: Text(
                    'Ecobank • v1.0',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppTheme.darkGray,
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

  // Input decoration with hidden default error line (no reserved space)
  InputDecoration _inputDecoration({required String hint}) => InputDecoration(
    hintText: hint,
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
    // Make Flutter's default error line take ZERO space
    errorStyle: const TextStyle(
      height: 0,
      fontSize: 0,
      color: Colors.transparent,
    ),
  );

  void _signIn() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      showEcobankAlert(
        context,
        message: 'Please enter valid credentials',
        type: AlertType.error,
      );
      return;
    }

    // TODO: authenticate; on success:
    showEcobankAlert(
      context,
      message: 'Signed in successfully',
      type: AlertType.success,
    );
    Navigator.pushReplacementNamed(context, '/dashboard');
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppTheme.darkGray,
      ),
    );
  }
}

/// Fixed-height custom error slot (prevents layout jump)
class _ErrorArea extends StatelessWidget {
  final String? message;
  const _ErrorArea({this.message});

  @override
  Widget build(BuildContext context) {
    // Reserve a constant 22px slot so fields below don't jump.
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
