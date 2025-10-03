import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_data.dart';

class IndividualAccountScreen extends StatefulWidget {
  const IndividualAccountScreen({super.key});

  @override
  State<IndividualAccountScreen> createState() => _IndividualAccountScreenState();
}

class _IndividualAccountScreenState extends State<IndividualAccountScreen> {
  bool _isLoading = true;
  List<String> selectedCurrencies = [];

  final List<Currency> availableCurrencies = const [
    Currency('KES', 'Kenyan Shilling'),
    Currency('USD', 'US Dollar'),
    Currency('EUR', 'Euro'),
    Currency('GBP', 'British Pound'),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // TODO: replace with real data calls
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
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
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/Ecobank-logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 160),
        child: _isLoading
            ? const _IndividualSkeleton()
            : _IndividualContent(
          selectedCurrencies: selectedCurrencies,
          onCurrencyTap: () => _showCurrencySelector(context),
          onChoose: selectedCurrencies.isNotEmpty ? _proceedToNextScreen : null,
        ),
      ),
    );
  }

  void _showCurrencySelector(BuildContext context) async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencySelectorModal(
        currencies: availableCurrencies,
        selectedCurrencies: selectedCurrencies,
      ),
    );

    if (result != null) {
      setState(() {
        selectedCurrencies = result;
      });
    }
  }

  void _proceedToNextScreen() {
    OnboardingData.I.accountProduct = 'Pay As You Transact';
    OnboardingData.I.currencies = List.from(selectedCurrencies);
    Navigator.pushNamed(context, '/account-registration', arguments: selectedCurrencies);
  }
}


class _IndividualContent extends StatelessWidget {
  final List<String> selectedCurrencies;
  final VoidCallback onCurrencyTap;
  final VoidCallback? onChoose;

  const _IndividualContent({
    required this.selectedCurrencies,
    required this.onCurrencyTap,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          color: AppTheme.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.darkGray,
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(text: 'Now select the '),
                    TextSpan(
                      text: 'Individual\nAccount Product',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(text: ' to open'),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),

        // Gray background section
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  _AccountProductCard(
                    onCurrencyTap: onCurrencyTap,
                    selectedCurrencies: selectedCurrencies,
                    onChoose: onChoose,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class _IndividualSkeleton extends StatelessWidget {
  const _IndividualSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header skeleton
        Container(
          color: AppTheme.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              _SkeletonBox(height: 22, width: 220),
              SizedBox(height: 8),
              _SkeletonBox(height: 22, width: 180),
              SizedBox(height: 24),
            ],
          ),
        ),

        // Body skeleton
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  // Image card skeleton
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      child: _SkeletonBox(height: double.infinity, width: double.infinity),
                    ),
                  ),

                  // Overlapping card skeleton
                  Transform.translate(
                    offset: const Offset(0, -35),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withOpacity(0.85),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SkeletonBox(height: 16, width: 220),
                          SizedBox(height: 20),
                          // Monthly fees + Min balance row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _SkeletonBox(height: 12, width: 80),
                                    SizedBox(height: 6),
                                    _SkeletonBox(height: 14, width: 40),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _SkeletonBox(height: 12, width: 80),
                                    SizedBox(height: 6),
                                    _SkeletonBox(height: 14, width: 40),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          _SkeletonBox(height: 14, width: 180),
                          SizedBox(height: 24),
                          _SkeletonBox(height: 14, width: 260), // label
                          SizedBox(height: 12),
                          // dropdown row
                          _SkeletonBox(height: 48, width: double.infinity, radius: BorderRadius.all(Radius.circular(8))),
                          SizedBox(height: 24),
                          // buttons row
                          Row(
                            children: [
                              Expanded(child: _SkeletonBox(height: 36, width: double.infinity, radius: BorderRadius.all(Radius.circular(25)))),
                              SizedBox(width: 12),
                              Expanded(child: _SkeletonBox(height: 40, width: double.infinity, radius: BorderRadius.all(Radius.circular(25)))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// pulsing skeleton block.
class _SkeletonBox extends StatefulWidget {
  final double height;
  final double? width;
  final BorderRadius? radius;
  const _SkeletonBox({required this.height, this.width, this.radius, Key? key})
      : super(key: key);

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 550))
      ..repeat(reverse: true);
    _a = Tween<double>(begin: 0.05, end: 0.18).animate(
      CurvedAnimation(parent: _c, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (context, _) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04 + _a.value),
            borderRadius: widget.radius ?? BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}

//Product card
class _AccountProductCard extends StatelessWidget {
  final VoidCallback onCurrencyTap;
  final List<String> selectedCurrencies;
  final VoidCallback? onChoose;

  const _AccountProductCard({
    required this.onCurrencyTap,
    required this.selectedCurrencies,
    this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/individual-account-woman.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
        ),

        // Overlapping card section
        Transform.translate(
          offset: const Offset(0, -35),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.85),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CURRENT ACCOUNT WITH NO\nCHARGES',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkGray,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Monthly Fees and Min Balance Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Monthly Fees',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkGray,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '0',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Min. Balance',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkGray,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '0',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Enjoy transactional banking',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Choose Currency to proceed (Select multiple)',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.darkGray,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Currency Dropdown
                  GestureDetector(
                    onTap: onCurrencyTap,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedCurrencies.isEmpty
                                  ? ''
                                  : selectedCurrencies.join(', '),
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 16,
                                color: selectedCurrencies.isNotEmpty ? AppTheme.darkGray : Colors.grey[500],
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bottom buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextButton(
                          onPressed: () => showProductDetailsSheet(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            foregroundColor: AppTheme.lightBlue,
                          ),
                          child: const Text(
                            'View More ...',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              color: AppTheme.lightBlue,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: onChoose,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: onChoose != null ? AppTheme.lightBlue : Colors.grey[300],
                            foregroundColor: onChoose != null ? Colors.white : Colors.grey[600],
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Choose',
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                                color: onChoose != null ? Colors.white : Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showProductDetailsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProductDetailsSheet(),
    );
  }
}

/* ------------------------------ Product details --------------------------- */

class ProductDetailsSheet extends StatelessWidget {
  const ProductDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    const monthlyFees = '0';
    const targetMarket = <String>[
      'Preferable for salaried individuals earning between Kes 15,000 and Kes 150,000',
      'Must be a Kenyan Citizen',
      'Must be 18 years and above in age',
      'Must have a valid KRA PIN',
    ];
    const benefits = <String>[
      'Free monthly e-statements',
      'Free Internet Banking access from anywhere in the world',
      'Ability to make internal and inter-bank payments via Internet Banking',
      'Mobile banking linked to customer\'s account',
      'Ability to deposit funds via M-Pesa',
      'Access to cheque book',
      'Access to loans',
      'No minimum operating balance',
    ];

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: _CenteredTitleBar(
                title: 'Product Details',
                onClose: () => Navigator.pop(context),
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 18, 12, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Monthly Fees'),
                    const SizedBox(height: 8),
                    Text(
                      monthlyFees,
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkGray,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 20),
                    const _SectionTitle('Target Market'),
                    const SizedBox(height: 8),
                    ...targetMarket.map((t) => _Bullet(t)).toList(),

                    const SizedBox(height: 18),
                    const _SectionTitle('Benefits'),
                    const SizedBox(height: 8),
                    ...benefits.map((b) => _Bullet(b)).toList(),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // Close
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightGreen,
                  foregroundColor: AppTheme.darkBlueHighlight,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenteredTitleBar extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _CenteredTitleBar({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    const double iconSpace = 48;
    return Row(
      children: [
        const SizedBox(width: iconSpace),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.darkGray,
            height: 1.25,
            letterSpacing: 0.15,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: iconSpace,
          child: IconButton(
            onPressed: onClose,
            splashRadius: 22,
            icon: const Icon(Icons.close, color: AppTheme.darkGray),
            tooltip: 'Close',
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppTheme.darkGray,
        height: 1.25,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: SizedBox(
              width: 4,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 14,
                color: AppTheme.darkGray,
                height: 1.32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Modal
class CurrencySelectorModal extends StatefulWidget {
  final List<Currency> currencies;
  final List<String> selectedCurrencies;

  const CurrencySelectorModal({
    super.key,
    required this.currencies,
    required this.selectedCurrencies,
  });

  @override
  State<CurrencySelectorModal> createState() => _CurrencySelectorModalState();
}

class _CurrencySelectorModalState extends State<CurrencySelectorModal> {
  late List<String> tempSelectedCurrencies;
  final TextEditingController searchController = TextEditingController();
  late List<Currency> filteredCurrencies;

  @override
  void initState() {
    super.initState();
    tempSelectedCurrencies = List.from(widget.selectedCurrencies);
    filteredCurrencies = widget.currencies;
  }

  void _filterCurrencies(String query) {
    setState(() {
      filteredCurrencies = widget.currencies
          .where((currency) =>
      currency.code.toLowerCase().contains(query.toLowerCase()) ||
          currency.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleCurrencySelection(String currencyCode) {
    setState(() {
      if (tempSelectedCurrencies.contains(currencyCode)) {
        tempSelectedCurrencies.remove(currencyCode);
      } else {
        tempSelectedCurrencies.add(currencyCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: AppTheme.lightBlue),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 16,
                      color: AppTheme.lightBlue,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Choose Currency to proceed...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 60),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: searchController,
              onChanged: _filterCurrencies,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.lightBlue),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // List
          Expanded(
            child: ListView.separated(
              itemCount: filteredCurrencies.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE5E5E5),
                indent: 56,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final currency = filteredCurrencies[index];
                final isSelected = tempSelectedCurrencies.contains(currency.code);

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppTheme.lightGreen : Colors.grey[400]!,
                        width: 2,
                      ),
                      color: isSelected ? AppTheme.lightGreen : Colors.transparent,
                    ),
                    child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                  ),
                  title: Text(
                    currency.code,
                    style: const TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => _toggleCurrencySelection(currency.code),
                );
              },
            ),
          ),

          // OK
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, tempSelectedCurrencies),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightGreen,
                foregroundColor: AppTheme.darkGray,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Models

class Currency {
  final String code;
  final String name;
  const Currency(this.code, this.name);
}
