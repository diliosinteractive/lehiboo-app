import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/l10n.dart';
import '../../data/services/company_search_service.dart';
import '../providers/business_register_provider.dart';
import '../utils/auth_registration_l10n.dart';
import 'company_autocomplete.dart';
import 'organization_type_card.dart';

/// Step 3: Company Information Form
///
/// Redesigned to match the web version with:
/// - Organization type cards in a row
/// - Company search autocomplete with green background
/// - SIRET and Industry side by side
/// - Postal code, City, and Country on one row
/// - Back and Continue buttons side by side
class CompanyInfoForm extends ConsumerStatefulWidget {
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  const CompanyInfoForm({
    super.key,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  ConsumerState<CompanyInfoForm> createState() => _CompanyInfoFormState();
}

class _CompanyInfoFormState extends ConsumerState<CompanyInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _siretController = TextEditingController();
  final _industryController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();

  OrganizationType _organizationType = OrganizationType.company;
  String _employeeCount = '';
  String _country = 'FR';

  static const _orangeColor = Color(0xFFFF601F);

  final List<String> _employeeCountOptions = [
    '1-10',
    '11-50',
    '51-200',
    '201-500',
    '500+',
  ];

  List<String> _industryOptions(BuildContext context) {
    final l10n = context.l10n;
    return [
      l10n.authIndustryTechnology,
      l10n.authIndustryFinance,
      l10n.authIndustryHealth,
      l10n.authIndustryEducation,
      l10n.authIndustryCommerce,
      l10n.authIndustryServices,
      l10n.authIndustryIndustry,
      l10n.authIndustryTransport,
      l10n.authIndustryRealEstate,
      l10n.authIndustryOther,
    ];
  }

  Map<String, String> _countryOptions(BuildContext context) {
    final l10n = context.l10n;
    return {
      'FR': l10n.authCountryFrance,
      'BE': l10n.authCountryBelgium,
      'CH': l10n.authCountrySwitzerland,
      'LU': l10n.authCountryLuxembourg,
      'MC': l10n.authCountryMonaco,
      'DE': l10n.authCountryGermany,
      'ES': l10n.authCountrySpain,
      'IT': l10n.authCountryItaly,
      'NL': l10n.authCountryNetherlands,
      'GB': l10n.authCountryUnitedKingdom,
      'OTHER': l10n.authCountryOther,
    };
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill from state if available
    final state = ref.read(businessRegisterProvider);
    _organizationType = state.organizationType;
    _companyNameController.text = state.companyName;
    _siretController.text = state.siret;
    _industryController.text = state.industry;
    _employeeCount = state.employeeCount;
    _addressController.text = state.address;
    _cityController.text = state.city;
    _postalCodeController.text = state.postalCode;
    _country = state.country.isNotEmpty ? state.country : 'FR';
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _siretController.dispose();
    _industryController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _saveToState() {
    ref.read(businessRegisterProvider.notifier).updateCompanyInfo(
          organizationType: _organizationType,
          companyName: _companyNameController.text,
          siret: _siretController.text,
          industry: _industryController.text,
          employeeCount: _employeeCount,
          address: _addressController.text,
          city: _cityController.text,
          postalCode: _postalCodeController.text,
          country: _country,
        );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    _saveToState();
    final success =
        ref.read(businessRegisterProvider.notifier).submitCompanyInfo();
    if (success) {
      widget.onSubmit();
    }
  }

  void _onCompanySelected(
    CompanySearchResult company,
    List<String> industryOptions,
  ) {
    setState(() {
      _companyNameController.text = company.name;
      _siretController.text = CompanySearchService.cleanSiret(company.siret);
      _addressController.text = company.address;
      _postalCodeController.text = company.zipCode;
      _cityController.text = company.city;

      // Try to match activity to industry
      if (company.activity != null) {
        final activity = company.activity!.toLowerCase();
        for (final industry in industryOptions) {
          if (activity.contains(industry.toLowerCase())) {
            _industryController.text = industry;
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final organizationName = context.organizationTypeLower(_organizationType);
    final organizationArticle =
        context.organizationTypeArticle(_organizationType);
    final organizationPossessive =
        context.organizationTypePossessive(_organizationType);
    final industryOptions = _industryOptions(context);
    final countryOptions = _countryOptions(context);
    final state = ref.watch(businessRegisterProvider);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              l10n.authBusinessCompanyInfoTitle(organizationArticle),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.authBusinessCompanyInfoSubtitle(organizationPossessive),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Main card container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Organization type label
                  _buildLabel(l10n.authOrganizationTypeLabel, required: true),
                  const SizedBox(height: 12),

                  // Organization type cards in a row
                  Row(
                    children: OrganizationType.values.map((type) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: type != OrganizationType.values.last ? 8 : 0,
                          ),
                          child: OrganizationTypeCard(
                            type: type,
                            isSelected: _organizationType == type,
                            onTap: () {
                              setState(() => _organizationType = type);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Company search autocomplete
                  CompanyAutocomplete(
                    onSelect: (company) =>
                        _onCompanySelected(company, industryOptions),
                    organizationName: organizationName,
                    organizationPossessive: organizationPossessive,
                  ),
                  const SizedBox(height: 24),

                  // Company name
                  _buildLabel(
                    l10n.authOrganizationNameLabel(organizationArticle),
                    required: true,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _companyNameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      hint: l10n.authCompanyNameHint,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
                        return l10n.authValidationMin2Chars;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // SIRET and Industry row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SIRET
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(
                              'SIRET',
                              required: false,
                              suffix: l10n.authOptionalSuffix,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _siretController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: _inputDecoration(
                                hint: '12345678901234',
                              ),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final cleaned =
                                      value.replaceAll(RegExp(r'\s'), '');
                                  if (!RegExp(r'^\d{14}$').hasMatch(cleaned)) {
                                    return l10n.authSiretInvalid;
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.authSiretHelp,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Industry
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(
                              l10n.authIndustryLabel,
                              required: false,
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: _industryController.text.isNotEmpty
                                  ? _industryController.text
                                  : null,
                              decoration: _inputDecoration(
                                hint: l10n.authSelectHint,
                              ),
                              isExpanded: true,
                              items: industryOptions.map((industry) {
                                return DropdownMenuItem(
                                  value: industry,
                                  child: Text(
                                    industry,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _industryController.text = value ?? '';
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Employee count (full width)
                  _buildLabel(l10n.authEmployeeCountLabel, required: false),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue:
                        _employeeCount.isNotEmpty ? _employeeCount : null,
                    decoration: _inputDecoration(
                      hint: l10n.authSelectHint,
                    ),
                    isExpanded: true,
                    items: _employeeCountOptions.map((count) {
                      return DropdownMenuItem(
                        value: count,
                        child: Text(count),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _employeeCount = value ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Address section
                  _buildLabel(l10n.authBillingAddressLabel, required: true),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      hint: l10n.authBillingAddressHint,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 5) {
                        return l10n.authValidationMin5Chars;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Postal code, City, Country row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Postal code
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(l10n.authPostalCodeLabel,
                                required: true),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _postalCodeController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: _inputDecoration(
                                hint: l10n.authPostalCodeHint,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().length < 3) {
                                  return l10n.authRequired;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // City
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(l10n.authCityLabel, required: true),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _cityController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              decoration: _inputDecoration(
                                hint: l10n.authCityFieldHint,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().length < 2) {
                                  return l10n.authRequired;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Country
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(l10n.authCountryLabel, required: true),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: _country,
                              decoration: _inputDecoration(
                                hint: l10n.authCountryHint,
                              ),
                              isExpanded: true,
                              items: countryOptions.entries.map((entry) {
                                return DropdownMenuItem(
                                  value: entry.key,
                                  child: Text(
                                    entry.value,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _country = value ?? 'FR';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Buttons row
                  Row(
                    children: [
                      // Back button
                      TextButton.icon(
                        onPressed: widget.onBack,
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: Text(l10n.commonBack),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Continue button
                      SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: state.isLoading ? null : _handleSubmit,
                          icon: state.isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.isLoading
                                    ? l10n.authLoading
                                    : l10n.commonContinue,
                              ),
                              if (!state.isLoading) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, size: 18),
                              ],
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _orangeColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false, String? suffix}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _orangeColor,
            ),
          ),
        ],
        if (suffix != null) ...[
          const SizedBox(width: 4),
          Text(
            suffix,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey[500],
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _orangeColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
