import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/agent_login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/individual_account_screen.dart';
import 'screens/account_requirements_screen.dart';
import 'screens/account_registration_screen.dart';
import 'screens/identity_verification_screen.dart';
import 'screens/address_details_screen.dart';
import 'screens/next_of_kin_details_screen.dart';
import 'screens/occupation_details_screen.dart';
import 'screens/selfie_screen.dart';
import 'screens/account_review_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/success_screen.dart';
import 'screens/view_all_accounts_screen.dart';
import 'theme/app_theme.dart';
import 'utils/connectivity_watcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecobank Agent Onboarding',
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) =>
          ConnectivityWatcher(child: child ?? const SizedBox()),
      home: const AgentLoginScreen(),
      routes: {
        '/agent-login': (context) => const AgentLoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/view-all-accounts': (context) => ViewAllAccountsScreen(),
        '/individual-account': (context) => const IndividualAccountScreen(),
        '/account-requirements': (context) => const AccountRequirementsScreen(),
        '/account-registration': (context) => const AccountRegistrationScreen(),
        '/identity-verification': (context) =>
            const IdentityVerificationScreen(),
        '/address-details': (context) => const AddressDetailsScreen(),
        '/next-of-kin': (context) => const NextOfKinDetailsScreen(),
        '/occupation-details': (_) => const OccupationDetailsScreen(),
        '/selfie': (_) => const SelfieIntroScreen(),
        '/account-review': (_) => const AccountReviewScreen(),
        '/otp-verification': (_) =>
            const OtpVerificationScreen(phoneNumber: '', email: ''),
        '/success': (_) => const SuccessScreen(),
      },
    );
  }
}
