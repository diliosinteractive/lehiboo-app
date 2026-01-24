import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Represents a company search result from the French government API
class CompanySearchResult {
  final String name;
  final String siret;
  final String siren;
  final String address;
  final String zipCode;
  final String city;
  final String? legalForm;
  final String? activity;

  const CompanySearchResult({
    required this.name,
    required this.siret,
    required this.siren,
    required this.address,
    required this.zipCode,
    required this.city,
    this.legalForm,
    this.activity,
  });

  /// Create from API JSON response
  factory CompanySearchResult.fromJson(Map<String, dynamic> json) {
    // Extract siege (headquarters) data
    final siege = json['siege'] as Map<String, dynamic>? ?? {};

    // Build full address from components
    String buildAddress() {
      final parts = <String>[];

      final numVoie = siege['numero_voie']?.toString() ?? '';
      final typeVoie = siege['type_voie']?.toString() ?? '';
      final libelleVoie = siege['libelle_voie']?.toString() ?? '';
      final complement = siege['complement_adresse']?.toString() ?? '';

      if (numVoie.isNotEmpty) parts.add(numVoie);
      if (typeVoie.isNotEmpty) parts.add(typeVoie);
      if (libelleVoie.isNotEmpty) parts.add(libelleVoie);

      var streetAddress = parts.join(' ');
      if (complement.isNotEmpty) {
        streetAddress = '$streetAddress, $complement';
      }

      return streetAddress;
    }

    return CompanySearchResult(
      name: json['nom_complet']?.toString() ?? json['nom_raison_sociale']?.toString() ?? '',
      siret: siege['siret']?.toString() ?? '',
      siren: json['siren']?.toString() ?? '',
      address: buildAddress(),
      zipCode: siege['code_postal']?.toString() ?? '',
      city: siege['libelle_commune']?.toString() ?? '',
      legalForm: json['nature_juridique']?.toString(),
      activity: json['libelle_activite_principale']?.toString() ?? siege['libelle_activite_principale']?.toString(),
    );
  }

  @override
  String toString() => 'CompanySearchResult(name: $name, siret: $siret, city: $city)';
}

/// Service for searching French companies using the government API
///
/// API Documentation: https://recherche-entreprises.api.gouv.fr/docs/
class CompanySearchService {
  static const _baseUrl = 'https://recherche-entreprises.api.gouv.fr';

  final http.Client _client;

  CompanySearchService({http.Client? client}) : _client = client ?? http.Client();

  /// Search companies by name
  ///
  /// [query] - Company name to search for (minimum 2 characters)
  /// [limit] - Maximum number of results (default: 8)
  ///
  /// Returns a list of matching companies
  Future<List<CompanySearchResult>> search(String query, {int limit = 8}) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.length < 2) {
      return [];
    }

    try {
      final uri = Uri.parse('$_baseUrl/search').replace(
        queryParameters: {
          'q': trimmedQuery,
          'per_page': limit.toString(),
          'page': '1',
        },
      );

      debugPrint('CompanySearchService: Searching for "$trimmedQuery"');

      final response = await _client.get(uri, headers: {
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>? ?? [];

        final companies = results
            .map((item) => CompanySearchResult.fromJson(item as Map<String, dynamic>))
            .where((company) => company.name.isNotEmpty && company.siret.isNotEmpty)
            .toList();

        debugPrint('CompanySearchService: Found ${companies.length} results');
        return companies;
      } else {
        debugPrint('CompanySearchService: API error ${response.statusCode}');
        return [];
      }
    } on TimeoutException {
      debugPrint('CompanySearchService: Request timed out');
      return [];
    } catch (e) {
      debugPrint('CompanySearchService: Error searching companies: $e');
      return [];
    }
  }

  /// Get company details by SIRET number
  ///
  /// [siret] - 14-digit SIRET number
  ///
  /// Returns company details or null if not found
  Future<CompanySearchResult?> getBySiret(String siret) async {
    final cleanedSiret = siret.replaceAll(RegExp(r'\s'), '');

    if (!RegExp(r'^\d{14}$').hasMatch(cleanedSiret)) {
      return null;
    }

    try {
      // Use SIREN (first 9 digits) for the search
      final siren = cleanedSiret.substring(0, 9);
      final uri = Uri.parse('$_baseUrl/search').replace(
        queryParameters: {
          'q': siren,
          'per_page': '10',
        },
      );

      final response = await _client.get(uri, headers: {
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>? ?? [];

        // Find the exact match by SIRET
        for (final item in results) {
          final company = CompanySearchResult.fromJson(item as Map<String, dynamic>);
          if (company.siret == cleanedSiret) {
            return company;
          }
        }

        // If exact SIRET not found, return first result with matching SIREN
        if (results.isNotEmpty) {
          return CompanySearchResult.fromJson(results.first as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      debugPrint('CompanySearchService: Error fetching company by SIRET: $e');
      return null;
    }
  }

  /// Format SIRET number with spaces for display
  ///
  /// Example: 12345678901234 -> 123 456 789 00012
  static String formatSiret(String siret) {
    final cleaned = siret.replaceAll(RegExp(r'\s'), '');
    if (cleaned.length != 14) return siret;

    return '${cleaned.substring(0, 3)} ${cleaned.substring(3, 6)} ${cleaned.substring(6, 9)} ${cleaned.substring(9)}';
  }

  /// Clean SIRET number (remove spaces)
  static String cleanSiret(String siret) {
    return siret.replaceAll(RegExp(r'\s'), '');
  }

  void dispose() {
    _client.close();
  }
}
