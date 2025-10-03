// lib/state/onboarding_data.dart
import 'dart:io';

class OnboardingData {
  OnboardingData._();
  static final OnboardingData I = OnboardingData._();

  // Choice / product
  String? accountCategory;           // Individual / Joint / Business
  String? accountProduct;            // e.g. "Pay As You Transact"
  List<String> currencies = [];

  // Registration
  String? email;
  String? phoneE164;

  // Identity
  String? idType;                    // National ID / Passport
  File? frontIdImage;
  File? backIdImage;
  File? signatureImage;

  // Address
  String? preferredBranch;
  String? country;
  String? area;
  String? building;

  // Next of kin
  String? kinName;
  String? kinRelation;
  String? kinPhoneE164;

  // Occupation
  String? occupation;
  String? industry;
  String? employer;
  String? incomeRange;

  // Photo
  String? selfiePath;

  String get physicalAddress {
    final parts = <String>[];
    if ((area ?? '').trim().isNotEmpty) parts.add(area!.trim());
    if ((building ?? '').trim().isNotEmpty) parts.add(building!.trim());
    if ((country ?? '').trim().isNotEmpty) parts.add(country!.trim());
    return parts.join(', ');
  }

  Map<String, String> toReviewMap() {
    return {
      // Add name/nationalId when you have those screens
      'name': '', // (placeholder)
      'nationalId': '', // (placeholder)
      'phone': phoneE164 ?? '',
      'email': email ?? '',
      'address': physicalAddress,
      'accountType': accountProduct ?? accountCategory ?? '',
      'branch': preferredBranch ?? '',
    };
  }

  void reset() {
    accountCategory = null;
    accountProduct  = null;
    currencies      = [];
    email           = null;
    phoneE164       = null;
    idType          = null;
    frontIdImage    = null;
    backIdImage     = null;
    signatureImage  = null;
    preferredBranch = null;
    country         = null;
    area            = null;
    building        = null;
    kinName         = null;
    kinRelation     = null;
    kinPhoneE164    = null;
    occupation      = null;
    industry        = null;
    employer        = null;
    incomeRange     = null;
    selfiePath      = null;
  }
}
