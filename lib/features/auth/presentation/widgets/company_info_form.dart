import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/company_search_service.dart';
import '../providers/business_register_provider.dart';
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

  // Dynamic wording based on organization type
  String get _organizationName => switch (_organizationType) {
    OrganizationType.company => 'entreprise',
    OrganizationType.association => 'association',
    OrganizationType.municipality => 'collectivité',
  };

  String get _organizationArticle => switch (_organizationType) {
    OrganizationType.company => 'l\'entreprise',
    OrganizationType.association => 'l\'association',
    OrganizationType.municipality => 'la collectivité',
  };

  String get _organizationPossessive => switch (_organizationType) {
    OrganizationType.company => 'votre entreprise',
    OrganizationType.association => 'votre association',
    OrganizationType.municipality => 'votre collectivité',
  };

  final List<String> _employeeCountOptions = [
    '1-10',
    '11-50',
    '51-200',
    '201-500',
    '500+',
  ];

  final List<String> _industryOptions = [
    'Technologie',
    'Finance',
    'Sant\u00e9',
    '\u00c9ducation',
    'Commerce',
    'Services',
    'Industrie',
    'Transport',
    'Immobilier',
    'Autre',
  ];

  final Map<String, String> _countryOptions = {
    'FR': 'France',
    'BE': 'Belgique',
    'CH': 'Suisse',
    'LU': 'Luxembourg',
    'MC': 'Monaco',
    'DE': 'Allemagne',
    'ES': 'Espagne',
    'IT': 'Italie',
    'NL': 'Pays-Bas',
    'GB': 'Royaume-Uni',
    'OTHER': 'Autre',
  };

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
    final success = ref.read(businessRegisterProvider.notifier).submitCompanyInfo();
    if (success) {
      widget.onSubmit();
    }
  }

  void _onCompanySelected(CompanySearchResult company) {
    setState(() {
      _companyNameController.text = company.name;
      _siretController.text = CompanySearchService.cleanSiret(company.siret);
      _addressController.text = company.address;
      _postalCodeController.text = company.zipCode;
      _cityController.text = company.city;

      // Try to match activity to industry
      if (company.activity != null) {
        final activity = company.activity!.toLowerCase();
        for (final industry in _industryOptions) {
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
              'Informations de $_organizationArticle',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ces informations permettront d\'identifier $_organizationPossessive',
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
                  _buildLabel('Type d\u2019organisation', required: true),
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
                    onSelect: _onCompanySelected,
                    organizationName: _organizationName,
                    organizationPossessive: _organizationPossessive,
                  ),
                  const SizedBox(height: 24),

                  // Company name
                  _buildLabel('Nom de $_organizationArticle', required: true),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _companyNameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      hint: 'Ma Soci\u00e9t\u00e9 SAS',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
                        return 'Min. 2 caract\u00e8res';
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
                            _buildLabel('SIRET', required: false, suffix: '(optionnel)'),
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
                                  final cleaned = value.replaceAll(RegExp(r'\s'), '');
                                  if (!RegExp(r'^\d{14}$').hasMatch(cleaned)) {
                                    return 'SIRET invalide';
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '14 chiffres, sans espaces',
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
                            _buildLabel('Secteur d\u2019activit\u00e9', required: false),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _industryController.text.isNotEmpty
                                  ? _industryController.text
                                  : null,
                              decoration: _inputDecoration(
                                hint: 'S\u00e9lectionner',
                              ),
                              isExpanded: true,
                              items: _industryOptions.map((industry) {
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
                  _buildLabel('Effectif', required: false),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _employeeCount.isNotEmpty ? _employeeCount : null,
                    decoration: _inputDecoration(
                      hint: 'S\u00e9lectionner',
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
                  _buildLabel('Adresse de facturation', required: true),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      hint: '123 rue de la Paix',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 5) {
                        return 'Min. 5 caract\u00e8res';
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
                            _buildLabel('Code postal', required: true),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _postalCodeController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              decoration: _inputDecoration(
                                hint: '75001',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().length < 3) {
                                  return 'Requis';
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
                            _buildLabel('Ville', required: true),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _cityController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              decoration: _inputDecoration(
                                hint: 'Paris',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().length < 2) {
                                  return 'Requis';
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
                            _buildLabel('Pays', required: true),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _country,
                              decoration: _inputDecoration(
                                hint: 'Pays',
                              ),
                              isExpanded: true,
                              items: _countryOptions.entries.map((entry) {
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
                        label: const Text('Retour'),
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
                              Text(state.isLoading ? 'Chargement...' : 'Continuer'),
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
