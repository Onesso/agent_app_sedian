import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../models/onboarding_data.dart';
import '../theme/app_theme.dart';
import '../utils/alert_utils.dart';

class NextOfKinDetailsScreen extends StatefulWidget {
  const NextOfKinDetailsScreen({super.key});

  @override
  State<NextOfKinDetailsScreen> createState() => _NextOfKinDetailsScreenState();
}

class _NextOfKinDetailsScreenState extends State<NextOfKinDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldKey = GlobalKey<FormFieldState<String>>();
  final _phoneFieldKey = GlobalKey<FormFieldState<PhoneNumber>>();

  final _name = TextEditingController();
  PhoneNumber? _phone;
  String _phoneE164 = '';
  String? _relationship;

  bool _saving = false; // 👈 new state

  static const List<String> _relationships = [
    'Father', 'Mother', 'Brother', 'Sister', 'Spouse', 'Other'
  ];

  static const Color sidianNavy = Color(0xFF0B2240);
  static const Color sidianOlive = Color(0xFF7A7A18);

  @override
  void initState() {
    super.initState();
    _name.addListener(() {
      _nameFieldKey.currentState?.validate();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _name.text.trim().isNotEmpty &&
          _relationship != null &&
          _phoneE164.isNotEmpty;

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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          value: 0.8,
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
                            const TextSpan(text: 'Add customer’s '),
                            TextSpan(
                              text: 'Next of Kin',
                              style: TextStyle(
                                color: sidianOlive,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ' details'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      const _FieldLabel('Full Name'),
                      const SizedBox(height: 8),
                      TextFormField(
                        key: _nameFieldKey,
                        controller: _name,
                        decoration: _inputDecoration(hint: 'Enter full name'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Name is required'
                            : null,
                      ),
                      _ErrorArea(message: _nameFieldKey.currentState?.errorText),
                      const SizedBox(height: 20),

                      const _FieldLabel('Phone Number'),
                      const SizedBox(height: 8),
                      PhoneFormField(
                        key: _phoneFieldKey,
                        initialValue:
                        const PhoneNumber(isoCode: IsoCode.KE, nsn: ''),
                        countrySelectorNavigator:
                        const CountrySelectorNavigator.bottomSheet(),
                        isCountrySelectionEnabled: true,
                        isCountryButtonPersistent: true,
                        countryButtonStyle: const CountryButtonStyle(
                          showFlag: true,
                          showIsoCode: false,
                          showDialCode: false,
                          flagSize: 18,
                        ),
                        decoration: _inputDecoration(hint: '0712 345 678'),
                        validator: PhoneValidator.compose([
                          PhoneValidator.required(context),
                          PhoneValidator.validMobile(context),
                        ]),
                        onChanged: (phone) {
                          setState(() {
                            _phone = phone;
                            _phoneE164 = (phone == null)
                                ? ''
                                : '+${phone.countryCode}${phone.nsn}';
                            _phoneFieldKey.currentState?.validate();
                          });
                        },
                      ),
                      _ErrorArea(message: _phoneFieldKey.currentState?.errorText),
                      const SizedBox(height: 20),

                      const _FieldLabel('Relationship'),
                      const SizedBox(height: 8),
                      _PickerBox(
                        valueText: _relationship ?? '--Select--',
                        isPlaceholder: _relationship == null,
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => _SingleSelectPickerSheet(
                              title: 'Relationship *',
                              items: _relationships,
                              selectedValue: _relationship,
                              navyColor: sidianNavy,
                            ),
                          );
                          if (result != null) {
                            setState(() => _relationship = result);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // --- Continue Button
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

                      // Save data
                      OnboardingData.I.kinName = _name.text.trim();
                      OnboardingData.I.kinRelation = _relationship;
                      OnboardingData.I.kinPhoneE164 = _phoneE164;

                      setState(() => _saving = false);

                      showSidianAlert(
                        context,
                        message:
                        'Next of Kin details saved successfully',
                        type: AlertType.success,
                      );

                      await Future.delayed(const Duration(seconds: 2));
                      if (mounted) {
                        Navigator.pushNamed(
                            context, '/occupation-details');
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
      errorStyle:
      const TextStyle(height: 0, fontSize: 0, color: Colors.transparent),
    );
  }
}

/* ------------------ Label + Error + Picker ------------------ */

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

class _ErrorArea extends StatelessWidget {
  final String? message;
  const _ErrorArea({this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: (message == null)
          ? const SizedBox(height: 20)
          : SizedBox(
        height: 20,
        child: Row(
          children: [
            const Icon(Icons.info_outline,
                size: 15, color: Colors.redAccent),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                message!,
                style: const TextStyle(
                  fontFamily: 'Calibri',
                  fontSize: 13,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
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
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

/* ------------------ Picker Modal ------------------ */

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
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
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
