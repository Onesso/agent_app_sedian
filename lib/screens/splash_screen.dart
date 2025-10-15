import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcome-bg.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          // Gradient overlay (black → translucent yellow)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xCC000000), // 90% black – subtle top dark overlay
                  Color(0x80FFFF00), // 50% transparent yellow bottom glow
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),


          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 5),

                // Sidian Logo
                Image.asset(
                  'assets/images/sidian_b.png',
                  height: 140,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 50),

                // Title
                Text(
                  "Welcome to Sidian\nOnline Account Opening",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontFamily: 'Calibri',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 45),

                // Subtitle
                Text(
                  "Powered by Sidian Bank",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Calibri',
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                  ),
                ),

                const Spacer(flex: 4),

                // Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/agent-login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Continue To Create Account',
                        style: TextStyle(
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}