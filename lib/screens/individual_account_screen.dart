import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_data.dart';

class IndividualAccountScreen extends StatefulWidget {
  const IndividualAccountScreen({super.key});

  @override
  State<IndividualAccountScreen> createState() =>
      _IndividualAccountScreenState();
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
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 70, 24, 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, Color(0xFF2E3346)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Text(
              "$greeting,\nPlease select account to continue",
              style: const TextStyle(
                fontFamily: 'Calibri',
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Account Card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _AccountCard(
                    title: 'FLEXXY YOUTH ACCOUNT',
                    monthlyFee: 'NILL',
                    minBalance: '500 KES',
                    description:
                    'A transactional account that allows for unlimited withdrawals and caters for students’ financial goals.',
                    image: 'assets/images/man-sile.png',
                    selectedCurrencies: selectedCurrencies,
                    onCurrencyTap: () => _showCurrencySelector(context),
                    onChoose: selectedCurrencies.isNotEmpty
                        ? _proceedToNextScreen
                        : null,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
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
      setState(() => selectedCurrencies = result);
    }
  }

  void _proceedToNextScreen() {
    OnboardingData.I.accountProduct = 'Flexxy Youth Account';
    OnboardingData.I.currencies = List.from(selectedCurrencies);
    Navigator.pushNamed(context, '/account-registration');
  }
}

/* ------------------------------ Account Card ------------------------------ */

class _AccountCard extends StatelessWidget {
  final String title;
  final String monthlyFee;
  final String minBalance;
  final String description;
  final String image;
  final List<String> selectedCurrencies;
  final VoidCallback onCurrencyTap;
  final VoidCallback? onChoose;

  const _AccountCard({
    required this.title,
    required this.monthlyFee,
    required this.minBalance,
    required this.description,
    required this.image,
    required this.selectedCurrencies,
    required this.onCurrencyTap,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              image,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Info section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Calibri',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoTile(label: 'Monthly Fees', value: monthlyFee),
                    Container(height: 32, width: 1, color: Colors.grey[300]),
                    _InfoTile(label: 'Min. Balance', value: minBalance),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () => _showDetails(context),
                  child: const Text(
                    'View More...',
                    style: TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 14,
                      color: AppTheme.textLink,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Choose Currency to proceed (Select multiple)',
                  style: TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Currency Dropdown
                GestureDetector(
                  onTap: onCurrencyTap,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              fontFamily: 'Calibri',
                              fontSize: 16,
                              color: selectedCurrencies.isEmpty
                                  ? Colors.grey
                                  : AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onChoose,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: onChoose != null
                          ? AppTheme.primary
                          : Colors.grey[300],
                      foregroundColor:
                      onChoose != null ? Colors.white : Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Choose',
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ProductDetailsSheet(),
    );
  }
}

/* ---------------------------- Info Tile ---------------------------- */
class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontFamily: 'Calibri',
              fontSize: 13,
              color: Colors.grey,
            )),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
              fontFamily: 'Calibri',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            )),
      ],
    );
  }
}

/* ---------------------------- Product Details ----------------------------- */
class _ProductDetailsSheet extends StatelessWidget {
  const _ProductDetailsSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details',
            style: TextStyle(
              fontFamily: 'Calibri',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'This account provides flexible banking with zero monthly fees and a low opening balance. Ideal for students and young professionals seeking convenience.',
            style: TextStyle(
              fontFamily: 'Calibri',
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

/* ---------------------------- Currency Selector --------------------------- */

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
  late List<Currency> filteredCurrencies;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tempSelectedCurrencies = List.from(widget.selectedCurrencies);
    filteredCurrencies = widget.currencies;
  }

  void _filterCurrencies(String query) {
    setState(() {
      filteredCurrencies = widget.currencies
          .where((c) =>
      c.code.toLowerCase().contains(query.toLowerCase()) ||
          c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleCurrencySelection(String code) {
    setState(() {
      if (tempSelectedCurrencies.contains(code)) {
        tempSelectedCurrencies.remove(code);
      } else {
        tempSelectedCurrencies.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
            child: const Text(
              'Choose Currency to proceed...',
              style: TextStyle(
                fontFamily: 'Calibri',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: _filterCurrencies,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ),
          ),

          // Currency List (show only codes)
          Expanded(
            child: ListView.separated(
              itemCount: filteredCurrencies.length,
              separatorBuilder: (_, __) => const Divider(
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
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  title: Text(
                    currency.code, // ✅ Only show currency code
                    style: const TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => _toggleCurrencySelection(currency.code),
                );
              },
            ),
          ),

          // OK Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context, tempSelectedCurrencies),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.medium,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ------------------------------- Model ---------------------------------- */
class Currency {
  final String code;
  final String name;
  const Currency(this.code, this.name);
}
