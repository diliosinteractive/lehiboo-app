import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../data/services/company_search_service.dart';

/// Widget for searching and selecting a company with autocomplete
///
/// Features:
/// - Debounced search (300ms)
/// - Minimum 2 characters to trigger search
/// - Light green background matching the web version
/// - Dropdown results with company details
class CompanyAutocomplete extends StatefulWidget {
  /// Callback when a company is selected
  final void Function(CompanySearchResult company) onSelect;

  /// Dynamic wording for the organization type (e.g., "entreprise", "association")
  final String organizationName;

  /// Dynamic possessive wording (e.g., "votre entreprise", "votre association")
  final String organizationPossessive;

  /// Optional injection point used by tests and alternate directory clients.
  final CompanySearchService? searchService;

  const CompanyAutocomplete({
    super.key,
    required this.onSelect,
    required this.organizationName,
    required this.organizationPossessive,
    this.searchService,
  });

  @override
  State<CompanyAutocomplete> createState() => _CompanyAutocompleteState();
}

class _CompanyAutocompleteState extends State<CompanyAutocomplete> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  late final CompanySearchService _service;
  late final bool _ownsService;

  Timer? _debounceTimer;
  List<CompanySearchResult> _results = [];
  CompanyLookupException? _lookupError;
  bool _isLoading = false;
  bool _showResults = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _ownsService = widget.searchService == null;
    _service = widget.searchService ?? CompanySearchService();
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _focusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _focusNode.dispose();
    if (_ownsService) _service.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      // Delay hiding results to allow tap on result item
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus) {
          setState(() => _showResults = false);
        }
      });
    }
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();

    final query = _searchController.text.trim();
    if (query.length < 2) {
      setState(() {
        _results = [];
        _showResults = false;
        _isLoading = false;
        _hasSearched = false;
        _lookupError = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showResults = false;
      _hasSearched = false;
      _lookupError = null;
    });

    _debounceTimer = Timer(
      const Duration(milliseconds: 300),
      () => _search(query),
    );
  }

  Future<void> _search(String query) async {
    if (!mounted) return;

    try {
      final results = await _service.search(query, limit: 8);

      if (mounted && _searchController.text.trim() == query) {
        setState(() {
          _results = results;
          _showResults = results.isNotEmpty;
          _isLoading = false;
          _hasSearched = true;
          _lookupError = null;
        });
      }
    } on CompanyLookupException catch (e) {
      _setLookupFailure(query, e);
    } catch (e) {
      debugPrint('CompanyAutocomplete: Unexpected lookup failure: $e');
      _setLookupFailure(
        query,
        const CompanyLookupException(
          CompanyLookupFailureType.serviceUnavailable,
        ),
      );
    }
  }

  void _setLookupFailure(String query, CompanyLookupException error) {
    if (!mounted || _searchController.text.trim() != query) return;
    setState(() {
      _results = [];
      _showResults = false;
      _isLoading = false;
      _hasSearched = true;
      _lookupError = error;
    });
  }

  void _retrySearch() {
    final query = _searchController.text.trim();
    if (_isLoading || query.length < 2) return;
    setState(() {
      _isLoading = true;
      _hasSearched = false;
      _lookupError = null;
    });
    unawaited(_search(query));
  }

  void _onSelectCompany(CompanySearchResult company) {
    setState(() {
      _searchController.clear();
      _results = [];
      _showResults = false;
    });
    _focusNode.unfocus();
    widget.onSelect(company);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Green background section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9), // Light green
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFC8E6C9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                l10n.authCompanySearchTitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF601F), // Orange
                ),
              ),
              const SizedBox(height: 12),

              // Search input
              TextField(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText:
                      l10n.authCompanySearchHint(widget.organizationPossessive),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: _isLoading
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(12),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFFF601F),
                          ),
                        )
                      : const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFFFF601F), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Helper text
              Text(
                l10n.authCompanySearchHelper(widget.organizationPossessive),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (_lookupError != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 20,
                        color: Colors.deepOrange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _lookupErrorMessage(l10n, _lookupError!),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5D4037),
                            height: 1.35,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading ? null : _retrySearch,
                        child: Text(l10n.commonRetry),
                      ),
                    ],
                  ),
                ),
              ] else if (_hasSearched && !_isLoading && _results.isEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.authCompanySearchNoResults,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Results dropdown
        if (_showResults && _results.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _results.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                final company = _results[index];
                return _CompanyResultItem(
                  company: company,
                  onTap: () => _onSelectCompany(company),
                );
              },
            ),
          ),
      ],
    );
  }

  String _lookupErrorMessage(
    AppLocalizations l10n,
    CompanyLookupException failure,
  ) {
    return switch (failure.type) {
      CompanyLookupFailureType.network ||
      CompanyLookupFailureType.timeout =>
        l10n.authCompanySearchConnectionError,
      CompanyLookupFailureType.serviceUnavailable ||
      CompanyLookupFailureType.invalidResponse =>
        l10n.authCompanySearchUnavailable,
    };
  }
}

/// Individual company result item in the dropdown
class _CompanyResultItem extends StatelessWidget {
  final CompanySearchResult company;
  final VoidCallback onTap;

  const _CompanyResultItem({
    required this.company,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.business,
                color: Colors.grey,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Company details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company name
                  Text(
                    company.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Address
                  if (company.address.isNotEmpty || company.city.isNotEmpty)
                    Text(
                      _formatAddress(company),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // SIRET
                  Text(
                    context.l10n.authSiretLine(
                      CompanySearchService.formatSiret(company.siret),
                    ),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAddress(CompanySearchResult company) {
    final parts = <String>[];
    if (company.address.isNotEmpty) parts.add(company.address);
    if (company.zipCode.isNotEmpty || company.city.isNotEmpty) {
      parts.add('${company.zipCode} ${company.city}'.trim());
    }
    return parts.join(', ');
  }
}
