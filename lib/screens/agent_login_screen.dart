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
  final _emailFieldKey = GlobalKey<FormFieldState<String>>();
  final _passwordFieldKey = GlobalKey<FormFieldState<String>>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool _signingIn = false;

  static const Color sidianNavy = Color(0xFF0B2240);
  static const Color sidianOlive = Color(0xFF7A7A18);

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
      backgroundColor: AppTheme.lightBackground,
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

                Center(
                  child: Image.asset(
                    'assets/images/sidian_b.png',
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 28),

                // Welcome title
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Welcome Agent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                          height: 1.25,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Sign in to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Username
                const _FieldLabel('Username'),
                const SizedBox(height: 8),
                TextFormField(
                  key: _emailFieldKey,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(hint: 'Enter your username'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                _ErrorArea(message: _emailFieldKey.currentState?.errorText),
                const SizedBox(height: 12),

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
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'At least 6 characters';
                    return null;
                  },
                ),
                _ErrorArea(message: _passwordFieldKey.currentState?.errorText),

                const SizedBox(height: 32),

                // --- Animated Sign In Button ---
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _canSignIn && !_signingIn
                        ? () async {
                      if (!(_formKey.currentState?.validate() ?? false)) {
                        showSidianAlert(
                          context,
                          message: 'Please enter valid credentials',
                          type: AlertType.error,
                        );
                        return;
                      }

                      setState(() => _signingIn = true);

                      await Future.delayed(const Duration(seconds: 2));

                      showSidianAlert(
                        context,
                        message: 'Signed in successfully',
                        type: AlertType.success,
                      );

                      await Future.delayed(const Duration(seconds: 1));

                      if (mounted) {
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      }

                      setState(() => _signingIn = false);
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _canSignIn ? sidianNavy : sidianNavy.withOpacity(0.3),
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _signingIn
                          ? Row(
                        key: const ValueKey('signing'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Signing In...',
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                        ],
                      )
                          : const Text(
                        'Sign In',
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

                const SizedBox(height: 24),

                // Help link
                Center(
                  child: TextButton(
                    onPressed: () {
                      showSidianAlert(
                        context,
                        message: 'Need help? Call (+254) 709 573 000',
                        type: AlertType.info,
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: sidianOlive,
                    ),
                    child: const Text(
                      'Need help?',
                      style: TextStyle(
                        fontFamily: 'Calibri',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Footer
                const Center(
                  child: Text(
                    'Sidian • v1.0',
                    style: TextStyle(
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppTheme.textSecondary,
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

  InputDecoration _inputDecoration({required String hint}) => InputDecoration(
    hintText: hint,
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.medium),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.medium),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: sidianNavy, width: 1.5),
    ),
    errorStyle:
    const TextStyle(height: 0, fontSize: 0, color: Colors.transparent),
  );
}


class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Calibri',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }
}


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
            const Icon(Icons.info_outline,
                size: 16, color: AppTheme.errorRed),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                message!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Calibri',
                  fontSize: 13,
                  color: AppTheme.errorRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
