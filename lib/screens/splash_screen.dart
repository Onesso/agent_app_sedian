import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Container(
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/background-img1.png'),
          //       fit: BoxFit.cover,
          //       alignment: Alignment(0, -0.2),
          //     ),
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background-img1.png'),
                fit: BoxFit.cover,
                alignment: Alignment(0, -0.2),

                // 👈 ADD THIS: Apply a ColorFilter to darken the image
                colorFilter: ColorFilter.mode(
                  // Use a semi-transparent black color (adjust opacity as needed)
                  Colors.black.withOpacity(0.4),
                  // Use BlendMode.darken, BlendMode.srcOver, or BlendMode.overlay
                  BlendMode.darken,
                ),
              ),
            ),
          ),

          // Content overlay
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                Image.asset(
                  'assets/images/sidianlogo.png',
                  height: 70,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 100),

                // Welcome title
                Text(
                  "Welcome to\nSedian's Digital\nAccount Opening",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 28,
                        fontFamily: 'Gilroy',
                        height: 1.3,
                        letterSpacing: 0.2,
                        color: AppTheme.white,
                        fontWeight: FontWeight.w900,
                      ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  "Open your new account online quickly,\n"
                  "easy, anytime and anywhere with\n"
                  "just a few steps.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        color: AppTheme.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 40),

                // Let's Get Started Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/agent-login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightGreen,
                      foregroundColor: AppTheme.darkGray,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Let\'s Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Need Help section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need Help?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.white.withOpacity(0.8),
                          ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement call functionality
                      },
                      child: Text(
                        'Call Us at (+254) 711 058 000',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
