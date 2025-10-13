import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_data.dart';
import '../utils/alert_utils.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({super.key});

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  String? _selectedBranch;
  String? _selectedCountry;
  final _areaController = TextEditingController();
  final _buildingController = TextEditingController();
  bool _saving = false;

  static const Color sidianOlive = Color(0xFF7A7A18);
  static const Color sidianNavy = Color(0xFF0B2240);

  final List<String> _branches = const [
    'BOMET',
    'BUNGOMA',
    'BURUBURU',
    'BUSIA',
    'CHUKA',
    'ELDORET',
    'EMALI',
    'EMBU',
    'GIKOMBA',
    'ISIOLO',
    'KAJIADO',
    'KAKAMEGA',
    'KAMAKIS',
    'KANGEMI',
    'KAREN',
    'KENGELENI',
    'KENYATTA AVENUE',
    'KENYATTA MARKET',
    'KERICHO',
    'MOI AVENUE',
    'MOMBASA',
  ];

  final List<String> _countries = const [
    'Kenya',
    'Uganda',
    'Tanzania',
    'Rwanda',
    'Ghana',
    'Nigeria',
  ];

  void _refresh() => setState(() {});

  @override
  void initState() {
    super.initState();
    _areaController.addListener(_refresh);
    _buildingController.addListener(_refresh);
  }

  @override
  void dispose() {
    _areaController.removeListener(_refresh);
    _buildingController.removeListener(_refresh);
    _areaController.dispose();
    _buildingController.dispose();
    super.dispose();
  }

  bool _canSubmit() {
    return _selectedBranch != null &&
        _selectedCountry != null &&
        _areaController.text.trim().isNotEmpty &&
        _buildingController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _canSubmit();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: sidianNavy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        value: 0.6,
                        color: sidianNavy,
                        backgroundColor: const Color(0xFFEDEDED),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // heading
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Calibri',
                          fontSize: 20,
                          color: AppTheme.textPrimary,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(
                            text: "Let's add the customer's ",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: 'Address Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: sidianOlive,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    const _RequiredLabel('Preferred Branch'),
                    const SizedBox(height: 8),
                    _PickerBox(
                      valueText: _selectedBranch ?? '--Select--',
                      isPlaceholder: _selectedBranch == null,
                      onTap: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => _SingleSelectPickerSheet(
                            title: 'Preferred Branch *',
                            items: _branches,
                            selectedValue: _selectedBranch,
                            navyColor: sidianNavy,
                          ),
                        );
                        if (result != null) setState(() => _selectedBranch = result);
                      },
                    ),
                    const SizedBox(height: 24),

                    const _RequiredLabel('Country of Residence'),
                    const SizedBox(height: 8),
                    _PickerBox(
                      valueText: _selectedCountry ?? '--Select--',
                      isPlaceholder: _selectedCountry == null,
                      onTap: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => _SingleSelectPickerSheet(
                            title: 'Country of Residence *',
                            items: _countries,
                            selectedValue: _selectedCountry,
                            navyColor: sidianNavy,
                          ),
                        );
                        if (result != null) setState(() => _selectedCountry = result);
                      },
                    ),
                    const SizedBox(height: 24),

                    const _RequiredLabel('Area of Residence'),
                    const SizedBox(height: 8),
                    _TextBox(controller: _areaController, hint: 'e.g. Nairobi'),
                    const SizedBox(height: 24),

                    const _RequiredLabel('Building'),
                    const SizedBox(height: 8),
                    _TextBox(controller: _buildingController, hint: 'e.g. ABC Apartments'),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: canSubmit && !_saving
                      ? () async {
                    setState(() => _saving = true);

                    // Simulate save process
                    await Future.delayed(const Duration(seconds: 2));

                    if (!mounted) return;
                    setState(() => _saving = false);

                    showSidianAlert(
                      context,
                      message: 'Address details saved successfully',
                      type: AlertType.success,
                    );

                    await Future.delayed(const Duration(seconds: 2));

                    if (mounted) {
                      _showAddOnsSheet();
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canSubmit ? sidianNavy : Colors.grey[300],
                    foregroundColor: canSubmit ? Colors.white : Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                      mainAxisSize: MainAxisSize.min,
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
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
            ),

          ],
        ),
      ),
    );
  }

  void _showAddOnsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black38,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        bool debitCard = false;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: sidianNavy.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const _GreyTile(
                      title: 'Mobile Banking',
                      subtitle:
                      'Customer will be automatically onboarded onto Mobile Banking once the account has been successfully opened.',
                    ),
                    const SizedBox(height: 12),

                    _GreyTile(
                      title: 'Debit Card',
                      subtitle:
                      'Shop and withdraw cash with ease using your card.',
                      trailing: Switch.adaptive(
                        value: debitCard,
                        onChanged: (v) => setSheetState(() => debitCard = v),
                        activeColor: sidianNavy,
                        activeTrackColor: sidianNavy.withOpacity(0.25),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _showConfirmDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: sidianNavy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'CONFIRM',
                  style: TextStyle(
                    fontFamily: 'Calibri',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kindly ensure that the account is funded with a minimum of Kes 600 to facilitate the debit card ordering.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                const _NoteParagraph(),
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          OnboardingData.I.preferredBranch = _selectedBranch;
                          OnboardingData.I.country = _selectedCountry;
                          OnboardingData.I.area = _areaController.text.trim();
                          OnboardingData.I.building =
                              _buildingController.text.trim();

                          Navigator.pop(ctx);
                          Navigator.pushNamed(context, '/next-of-kin');
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.w600,
                            color: sidianNavy,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* ------------------ Helper Widgets ------------------ */

class _RequiredLabel extends StatelessWidget {
  final String text;
  const _RequiredLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Calibri',
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: AppTheme.textPrimary,
        ),
        children: [
          TextSpan(text: text),
          const TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class _PickerBox extends StatelessWidget {
  final String valueText;
  final bool isPlaceholder;
  final VoidCallback onTap;

  const _PickerBox({
    required this.valueText,
    required this.isPlaceholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
    isPlaceholder ? Colors.grey : AppTheme.textPrimary;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD6D6D6)),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  valueText,
                  style: TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _TextBox({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontFamily: 'Calibri',
        fontSize: 16,
        color: AppTheme.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Calibri',
          fontSize: 15,
          color: Colors.grey,
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
            color: Color(0xFFD6D6D6), // stays gray on focus
          ),
        ),
      ),
    );
  }
}

class _GreyTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _GreyTile({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE4E6EA)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'Calibri',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: const TextStyle(
                      fontFamily: 'Calibri',
                      fontSize: 14,
                      height: 1.4,
                      color: AppTheme.textPrimary,
                    )),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _NoteParagraph extends StatelessWidget {
  const _NoteParagraph();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          fontFamily: 'Calibri',
          fontSize: 15,
          color: AppTheme.textPrimary,
        ),
        children: [
          TextSpan(text: 'Note: ', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
            text:
            'Top up conveniently using Paybill Number 700201 and your account number which will be sent to you on SMS and email.',
          ),
        ],
      ),
    );
  }
}

/* -------------- Picker Modal (Dropdown Sheet) -------------- */

class _SingleSelectPickerSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selectedValue;
  final Color navyColor;

  const _SingleSelectPickerSheet({
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.navyColor,
  });

  @override
  State<_SingleSelectPickerSheet> createState() =>
      _SingleSelectPickerSheetState();
}

class _SingleSelectPickerSheetState extends State<_SingleSelectPickerSheet> {
  late List<String> _filtered;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _searchCtrl.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_applyFilter);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filtered = widget.items
          .where((e) => e.toLowerCase().contains(q))
          .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: TextStyle(
                            fontFamily: 'Calibri',
                            color: widget.navyColor,
                            fontSize: 16)),
                  ),
                  Expanded(
                    child: Text(widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black)),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
            ),
            // search box
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
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
                    borderSide:
                    const BorderSide(color: Color(0xFFD6D6D6)), // neutral
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
            ),
            // options
            Expanded(
              child: ListView.separated(
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: Color(0xFFE5E5E5),
                  indent: 56,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final text = _filtered[index];
                  final isSelected = widget.selectedValue == text;
                  return ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    leading: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                          isSelected ? widget.navyColor : Colors.grey[400]!,
                          width: 2,
                        ),
                        color: isSelected
                            ? widget.navyColor
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                          size: 14, color: Colors.white)
                          : null,
                    ),
                    title: Text(
                      text,
                      style: const TextStyle(
                        fontFamily: 'Calibri',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, text),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
