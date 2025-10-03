//Not included for now
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AccountRequirementsScreen extends StatelessWidget {
  const AccountRequirementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> selectedCurrencies =
        ModalRoute.of(context)!.settings.arguments as List<String>? ?? [];

    // Get the primary currency (use the first one if multiple selected)
    final String primaryCurrency = selectedCurrencies.isNotEmpty
        ? selectedCurrencies.first
        : 'KES';

    final String countryAdjective = getCountryFromCurrency(primaryCurrency);
    final String countryName = getCountryNameFromCurrency(primaryCurrency);

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.lightBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // page content
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Take note of the following ',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                      height: 1.35,
                      color: AppTheme.textTitleBody,
                    ),
                  ),
                  const TextSpan(
                    text: 'Requirements',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      height: 1.35,
                      color: AppTheme.textTitleBody,
                    ),
                  ),
                  const TextSpan(
                    text: ' before you\nproceed',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                      height: 1.35,
                      color: AppTheme.textTitleBody,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),

            // Requirement 1
            _RequirementItem(
              index: 1,
              icon: Icons.badge_outlined, // ID/Passport icon
              title: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Customer\'s ',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    TextSpan(
                      text: countryAdjective,
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    const TextSpan(
                      text: ' national ID/Passport',
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
              subtitle:
              'Customer\'s ID will be used to fetch data on KRA and IPRS services',
            ),
            const Divider(height: 40, thickness: 1, color: Color(0xFFE3E3E3)),

            // Requirement 2
            _RequirementItem(
              index: 2,
              icon: Icons.gesture_outlined, // signature glyph
              title: const Text(
                'Customer\'s signature on a plain piece of paper',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.35,
                  color: AppTheme.darkGray,
                ),
              ),
            ),
            const Divider(height: 40, thickness: 1, color: Color(0xFFE3E3E3)),
            const SizedBox(height: 12),

            // Continue button
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/account-registration');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightGreen,
                  foregroundColor: AppTheme.darkBlueHighlight,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                child: const Text('Continue'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final Widget title;
  final String? subtitle;

  const _RequirementItem({
    required this.index,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // number
            Container(
              width: 28,
              child: Text(
                '$index',
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  height: 1.0,
                  color: AppTheme.lightBlue,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // square icon with black outline
            Container(
              width: 40,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black87, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20, color: Colors.black87),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle.merge(
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  height: 1.35,
                  color: AppTheme.darkGray,
                ),
                child: title,
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 10),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 1.5,
                    color: AppTheme.darkGrayT,
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}

String getCountryFromCurrency(String currencyCode) {
  switch (currencyCode) {
    case 'KES':
      return 'Kenyan';
    case 'USD':
      return 'American';
    case 'EUR':
      return 'European';
    case 'GBP':
      return 'British';
    default:
      return 'valid';
  }
}

String getCountryNameFromCurrency(String currencyCode) {
  switch (currencyCode) {
    case 'KES':
      return 'Kenya';
    case 'USD':
      return 'United States';
    case 'EUR':
      return 'European Union';
    case 'GBP':
      return 'United Kingdom';
    default:
      return 'the respective country';
  }
}