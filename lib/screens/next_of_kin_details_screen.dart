import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../models/onboarding_data.dart';
import '../utils/alert_utils.dart';

class NextOfKinDetailsScreen extends StatefulWidget {
  const NextOfKinDetailsScreen({super.key});

  @override
  State<NextOfKinDetailsScreen> createState() => _NextOfKinDetailsScreenState();
}

class _NextOfKinDetailsScreenState extends State<NextOfKinDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Keys so we can read/clear error messages instantly
  final _nameFieldKey  = GlobalKey<FormFieldState<String>>();
  final _phoneFieldKey = GlobalKey<FormFieldState<PhoneNumber>>();

  final _name = TextEditingController();

  PhoneNumber? _phone; // parsed phone
  String _phoneE164 = ''; // +2547xxxxxxxx
  String? _relationship;

  static const List<String> _relationships = <String>[
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Spouse',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _name.addListener(() {
      // live-validate to clear error as user types
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
      _name.text.trim().isNotEmpty && _relationship != null && _phoneE164.isNotEmpty;

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
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          value: 0.80,
                          color: AppTheme.lightGreen,
                          backgroundColor: const Color(0xFFEAEFBE),
                        ),
                      ),
                      const SizedBox(height: 28),

                      const Text(
                        'Next of Kin Details',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          height: 1.2,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text.rich(
                        TextSpan(
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
                              text: 'Next of Kin',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(text: ' details'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // FULL NAME (updated)
                      const _FieldLabel('Full name'),
                      const SizedBox(height: 8),
                      TextFormField(
                        key: _nameFieldKey,
                        controller: _name,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecoration(hint: ''),
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'First name is required' : null,
                      ),
                      _ErrorArea(message: _nameFieldKey.currentState?.errorText),
                      const SizedBox(height: 8),

                      // PHONE (updated)
                      const _FieldLabel('Phone Number'),
                      const SizedBox(height: 8),
                      PhoneFormField(
                        key: _phoneFieldKey,
                        initialValue: const PhoneNumber(isoCode: IsoCode.KE, nsn: ''),
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
                        decoration: _inputDecoration(hint: '0700 000 000'),
                        validator: PhoneValidator.compose([
                          PhoneValidator.required(context),
                          PhoneValidator.validMobile(context),
                        ]),
                        onChanged: (phone) {
                          setState(() {
                            _phone = phone;
                            _phoneE164 =
                            (phone == null) ? '' : '+${phone.countryCode}${phone.nsn}';
                            _phoneFieldKey.currentState?.validate(); // instant clear
                          });
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      _ErrorArea(message: _phoneFieldKey.currentState?.errorText),
                      const SizedBox(height: 8),

                      // RELATIONSHIP (unchanged – uses your modal picker)
                      const _FieldLabel('Relationship'),
                      const SizedBox(height: 8),
                      _PickerBox(
                        valueText: _relationship ?? '--Select--',
                        isPlaceholder: _relationship == null,
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => _SingleSelectPickerSheet(
                              title: 'Relationship *',
                              items: _relationships,
                              selectedValue: _relationship,
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              _relationship = result;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

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

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: AppTheme.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.textFieldOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.textFieldOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.lightBlue, width: 1.5),
      ),
      // hide Flutter’s default error line; we show our own fixed-height row
      errorStyle: const TextStyle(height: 0, fontSize: 0, color: Colors.transparent),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    OnboardingData.I.kinName      = _name.text.trim();
    OnboardingData.I.kinRelation  = _relationship;
    OnboardingData.I.kinPhoneE164 = _phoneE164;
    Navigator.pushNamed(context, '/occupation-details');
    showEcobankAlert(
      context,
      message: 'Next of Kin saved',
      type: AlertType.success,
    );
  }
}

// helpers
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

class _ErrorArea extends StatelessWidget {
  final String? message;
  const _ErrorArea({this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      child: (message == null)
          ? const SizedBox(height: 22, key: ValueKey('empty'))
          : SizedBox(
        key: const ValueKey('error'),
        height: 22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 16, color: AppTheme.alertError),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                message!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 13,
                  color: AppTheme.alertError,
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

// modal single-select picker
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
      _filtered =
          widget.items.where((e) => e.toLowerCase().contains(q)).toList(growable: false);
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
