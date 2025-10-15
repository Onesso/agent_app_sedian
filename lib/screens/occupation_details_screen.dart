import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_data.dart';
import '../utils/alert_utils.dart';

class OccupationDetailsScreen extends StatefulWidget {
  const OccupationDetailsScreen({super.key});

  @override
  State<OccupationDetailsScreen> createState() =>
      _OccupationDetailsScreenState();
}

class _OccupationDetailsScreenState extends State<OccupationDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _employer = TextEditingController();

  String? _occupation;
  String? _industry;
  String? _income;
  bool _saving = false;

  static const Color sidianNavy = Color(0xFF0B2240);
  static const Color sidianOlive = Color(0xFF7A7A18);

  final List<String> _occupations = const [
    'Salaried Employee-BANK',
    'Salaried Employee-OTHER',
    'Self Employed',
    'Student',
    'Pensioner',
    'Dependant',
  ];

  final List<String> _industries = const [
    'Agriculture',
    'Banking/Finance',
    'Construction',
    'Education',
    'Healthcare',
    'Hospitality',
    'IT/Telecom',
    'Manufacturing',
    'Transport',
    'Other',
  ];

  final List<String> _incomeRanges = const [
    'Kes 0 - 15,000',
    'Kes 15,001 – 50,000',
    'Kes 50,001 – 150,000',
    'Kes 150,001 – 400,000',
    'Kes 400,001 – 450,000',
    'Kes 450,000 and above',
  ];

  bool get _canSubmit =>
      (_occupation != null) &&
          (_industry != null) &&
          _employer.text.trim().isNotEmpty &&
          (_income != null);

  @override
  void dispose() {
    _employer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: sidianNavy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          value: 1.0,
                          color: sidianNavy,
                          backgroundColor: const Color(0xFFEDEDED),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Heading
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: 20,
                            height: 1.4,
                            color: AppTheme.textPrimary,
                          ),
                          children: [
                            const TextSpan(text: 'Almost there, add customer\'s '),
                            TextSpan(
                              text: 'Occupation ',
                              style: TextStyle(
                                color: sidianOlive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: 'details.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      const _FieldLabel('Occupation'),
                      const SizedBox(height: 8),
                      _PickerBox(
                        valueText: _occupation ?? '--Select--',
                        isPlaceholder: _occupation == null,
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => _SingleSelectPickerSheet(
                              title: 'Occupation *',
                              items: _occupations,
                              selectedValue: _occupation,
                              navyColor: sidianNavy,
                            ),
                          );
                          if (result != null) {
                            setState(() => _occupation = result);
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      const _FieldLabel('Industry'),
                      const SizedBox(height: 8),
                      _PickerBox(
                        valueText: _industry ?? '--Select--',
                        isPlaceholder: _industry == null,
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => _SingleSelectPickerSheet(
                              title: 'Industry *',
                              items: _industries,
                              selectedValue: _industry,
                              navyColor: sidianNavy,
                            ),
                          );
                          if (result != null) {
                            setState(() => _industry = result);
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      const _FieldLabel('Employer Name'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _employer,
                        decoration: _inputDecoration(hint: 'e.g. ABC Company'),
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 24),

                      const _FieldLabel('Monthly Income Range'),
                      const SizedBox(height: 8),
                      _PickerBox(
                        valueText: _income ?? '--Select--',
                        isPlaceholder: _income == null,
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => _SingleSelectPickerSheet(
                              title: 'Monthly Income Range *',
                              items: _incomeRanges,
                              selectedValue: _income,
                              navyColor: sidianNavy,
                            ),
                          );
                          if (result != null) {
                            setState(() => _income = result);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // --- Animated Continue Button ---
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _canSubmit && !_saving
                        ? () async {
                      setState(() => _saving = true);

                      await Future.delayed(const Duration(seconds: 2));

                      OnboardingData.I.occupation = _occupation;
                      OnboardingData.I.industry = _industry;
                      OnboardingData.I.employer =
                          _employer.text.trim();
                      OnboardingData.I.incomeRange = _income;

                      setState(() => _saving = false);

                      showSidianAlert(
                        context,
                        message:
                        'Occupation details saved successfully',
                        type: AlertType.success,
                      );

                      await Future.delayed(const Duration(seconds: 2));
                      if (mounted) {
                        Navigator.pushNamed(context, '/selfie');
                      }
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _canSubmit ? sidianNavy : Colors.grey[300],
                      foregroundColor:
                      _canSubmit ? Colors.white : Colors.grey[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
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
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                  Colors.white),
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
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Calibri',
        color: Colors.grey,
        fontSize: 15,
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
        borderSide: const BorderSide(color: Color(0xFFD6D6D6)),
      ),
    );
  }
}

/* ------------------ Field Label ------------------ */
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Calibri',
          fontSize: 15,
          color: AppTheme.textPrimary,
        ),
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/* ------------------ Picker Box ------------------ */
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
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD6D6D6)),
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

/* ------------------ Picker Sheet ------------------ */
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

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() => _filtered =
        widget.items.where((e) => e.toLowerCase().contains(q)).toList());
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
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
                            fontSize: 16)),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon:
                  const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    const BorderSide(color: Color(0xFFD6D6D6)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    const BorderSide(color: Color(0xFFD6D6D6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    const BorderSide(color: Color(0xFFD6D6D6)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Color(0xFFE5E5E5),
                    indent: 56,
                    endIndent: 16),
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
