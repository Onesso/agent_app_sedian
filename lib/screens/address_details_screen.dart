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

  // Sample data
  final List<String> _branches = const [
    'Nairobi CBD Branch',
    'Westlands Branch',
    'Karen Branch',
    'Eastleigh Branch',
    'Kisumu Branch',
    'Mombasa Branch',
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

  @override
  Widget build(BuildContext context) {
    final canSubmit = _canSubmit();

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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        value: 0.60,
                        color: AppTheme.lightGreen,
                        backgroundColor: const Color(0xFFEAEFBE),
                      ),
                    ),
                    const SizedBox(height: 44),

                    const Text(
                      'Address Details',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        height: 1.2,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    const SizedBox(height: 16),

                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.5,
                          color: AppTheme.darkGray,
                        ),
                        children: [
                          TextSpan(text: 'Now add customer\'s '),
                          TextSpan(
                            text: 'Address details',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Preferred branch (modal picker)
                    const _RequiredLabel('Preferred branch'),
                    const SizedBox(height: 8),
                    _PickerBox(
                      valueText: _selectedBranch ?? '--Select--',
                      isPlaceholder: _selectedBranch == null,
                      onTap: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => _SingleSelectPickerSheet(
                            title: 'Preferred Branch *',
                            items: _branches,
                            selectedValue: _selectedBranch,
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _selectedBranch = result;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Country of residence (modal picker)
                    const _RequiredLabel('Country of residence'),
                    const SizedBox(height: 8),
                    _PickerBox(
                      valueText: _selectedCountry ?? '--Select--',
                      isPlaceholder: _selectedCountry == null,
                      onTap: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => _SingleSelectPickerSheet(
                            title: 'Country of Residence *',
                            items: _countries,
                            selectedValue: _selectedCountry,
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _selectedCountry = result;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Area of residence
                    const _RequiredLabel('Area of residence'),
                    const SizedBox(height: 8),
                    _TextBox(
                      controller: _areaController,
                      hint: 'e.g Nairobi',
                    ),
                    const SizedBox(height: 24),

                    // Building
                    const _RequiredLabel('Building'),
                    const SizedBox(height: 8),
                    _TextBox(
                      controller: _buildingController,
                      hint: 'e.g. ABC Apartments',
                    ),
                  ],
                ),
              ),
            ),

            // Submit
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: canSubmit ? _submit : null,
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return const Color(0xFFDDE9A6); // pale green (disabled)
                      }
                      return AppTheme.lightGreen; // bright green (enabled)
                    }),
                    foregroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return const Color(0xFF9E9E9E); // grey text (disabled)
                      }
                      return AppTheme.darkBlueHighlight; // normal
                    }),
                    elevation: const MaterialStatePropertyAll(0),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    textStyle: const MaterialStatePropertyAll(TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canSubmit() {
    return _selectedBranch != null &&
        _selectedCountry != null &&
        _areaController.text.trim().isNotEmpty &&
        _buildingController.text.trim().isNotEmpty;
  }

  void _submit() {
    _showAddOnsSheet();
  }

  void _showAddOnsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      barrierColor: Colors.black54,
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
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // green handle
                    Container(
                      width: 68,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 12),

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
                        activeColor: AppTheme.lightBlue,
                        activeTrackColor: AppTheme.lightBlue.withOpacity(0.25),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _showConfirmDialog,
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
                        child: const Text('Continue'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// CONFIRM dialog
  void _showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding:
          const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  children: const [
                    Text(
                      'CONFIRM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: AppTheme.darkGray,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Kindly ensure that your account is funded with a minimum of Kes 600 to facilitate your debit card ordering.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    SizedBox(height: 12),
                    _NoteParagraph(),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              // actions row
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(ctx),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppTheme.darkGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, color: const Color(0xFFE5E7EB)),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          OnboardingData.I.preferredBranch = _selectedBranch;
                          OnboardingData.I.country = _selectedCountry;
                          OnboardingData.I.area =
                              _areaController.text.trim();
                          OnboardingData.I.building =
                              _buildingController.text.trim();

                          Navigator.pop(ctx); // close dialog
                          Navigator.pushNamed(context, '/next-of-kin');
                        },
                        child: const Center(
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppTheme.lightBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//helpers (styled widgets)

class _RequiredLabel extends StatelessWidget {
  final String text;
  const _RequiredLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppTheme.darkGray,
        ),
        children: [
          TextSpan(text: text),
          const TextSpan(
            text: ' *',
            style: TextStyle(color: AppTheme.errorRed),
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
    final textColor = isPlaceholder ? const Color(0xFF9E9E9E) : AppTheme.darkGray;

    return Material(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(8),
            border: const Border.fromBorderSide(
              BorderSide(color: AppTheme.textFieldOutline),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  valueText,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: AppTheme.darkGray, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Grey info tile used in the add-ons sheet
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E6EA)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.4,
                    color: AppTheme.darkGray,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
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
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: AppTheme.darkGray,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: Color(0xFF9E9E9E),
        ),
        filled: true,
        fillColor: AppTheme.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.textFieldOutline),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.textFieldOutline),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.lightBlue, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
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
          fontFamily: 'Gilroy',
          fontSize: 15,
          height: 1.5,
          color: AppTheme.darkGray,
        ),
        children: [
          TextSpan(text: 'Note: ', style: TextStyle(fontWeight: FontWeight.w600)),
          TextSpan(
            text:
            'Top up conveniently using Paybill Number 700201 and your account number which will be sent to you on SMS and email.',
          ),
        ],
      ),
    );
  }
}

//modal single-select picker
class _SingleSelectPickerSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selectedValue;

  const _SingleSelectPickerSheet({
    required this.title,
    required this.items,
    required this.selectedValue,
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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.lightBlue,
                    ),
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
                  Expanded(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                controller: _searchCtrl,
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
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  thickness: 1,
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
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightGreen
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                        color: isSelected
                            ? AppTheme.lightGreen
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                          size: 16, color: Colors.white)
                          : null,
                    ),
                    title: Text(
                      text,
                      style: const TextStyle(
                        fontFamily: 'Gilroy',
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
