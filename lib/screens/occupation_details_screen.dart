import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/onboarding_data.dart';
import '../utils/alert_utils.dart';

class OccupationDetailsScreen extends StatefulWidget {
  const OccupationDetailsScreen({super.key});

  @override
  State<OccupationDetailsScreen> createState() => _OccupationDetailsScreenState();
}

class _OccupationDetailsScreenState extends State<OccupationDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _employer = TextEditingController();

  String? _occupation;
  String? _industry;
  String? _income;

  final List<String> _occupations = const [
    'Employed',
    'Self-employed',
    'Student',
    'Unemployed',
    'Retired',
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
    '< 20,000',
    '20,000 – 50,000',
    '50,001 – 100,000',
    '100,001 – 200,000',
    '> 200,000',
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          value: 1.0,
                          color: AppTheme.lightGreen,
                          backgroundColor: const Color(0xFFEAEFBE),
                        ),
                      ),
                      const SizedBox(height: 44),

                      const Text(
                        'Occupation Details',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          height: 1.2,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 1.5,
                            color: AppTheme.darkGray,
                          ),
                          children: const [
                            TextSpan(text: 'Almost there, '),
                            TextSpan(text: 'Add customer\'s '),
                            TextSpan(
                              text: 'occupation',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: ' details'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Occupation (picker)
                      const _FieldLabel('Occupation'),
                      const SizedBox(height: 8),
                      _PickerBox(
                        valueText: _occupation ?? '--Select--',
                        isPlaceholder: _occupation == null,
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => _SingleSelectPickerSheet(
                              title: 'Occupation *',
                              items: _occupations,
                              selectedValue: _occupation,
                            ),
                          );
                          if (result != null) {
                            setState(() => _occupation = result);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Industry (picker)
                      const _FieldLabel('Industry'),
                      const SizedBox(height: 8),
                      _PickerBox(
                        valueText: _industry ?? '--Select--',
                        isPlaceholder: _industry == null,
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => _SingleSelectPickerSheet(
                              title: 'Industry *',
                              items: _industries,
                              selectedValue: _industry,
                            ),
                          );
                          if (result != null) {
                            setState(() => _industry = result);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Employer text
                      const _FieldLabel('Employer name'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _employer,
                        decoration: _textFieldDecoration(hint: ''),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      // Income range (picker)
                      const _FieldLabel('Monthly income range?'),
                      const SizedBox(height: 8),
                      _PickerBox(
                        valueText: _income ?? '--Select--',
                        isPlaceholder: _income == null,
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => _SingleSelectPickerSheet(
                              title: 'Monthly Income Range *',
                              items: _incomeRanges,
                              selectedValue: _income,
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

              // Submit
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _canSubmit ? _submit : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color(0xFFDDE9A6);
                        }
                        return AppTheme.lightGreen;
                      }),
                      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color(0xFF9E9E9E);
                        }
                        return AppTheme.darkBlueHighlight;
                      }),
                      elevation: const MaterialStatePropertyAll(0),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      textStyle: const MaterialStatePropertyAll(
                        TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static InputDecoration _textFieldDecoration({required String hint}) =>
      InputDecoration(
        hintText: hint,
        isDense: true,
        filled: true,
        fillColor: AppTheme.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.textFieldOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.textFieldOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.lightBlue, width: 1.5),
        ),
      );

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    OnboardingData.I.occupation  = _occupation;
    OnboardingData.I.industry    = _industry;
    OnboardingData.I.employer    = _employer.text.trim();
    OnboardingData.I.incomeRange = _income;
    Navigator.pushNamed(context, '/selfie');
    showEcobankAlert(
      context,
      message: 'Occupation details saved',
      type: AlertType.success,
    );
  }
}

//helpers
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppTheme.darkGray,
            ),
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppTheme.errorRed,
            ),
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
  State<_SingleSelectPickerSheet> createState() => _SingleSelectPickerSheetState();
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
      _filtered = widget.items.where((e) => e.toLowerCase().contains(q)).toList(growable: false);
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
                      child: isSelected
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
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
