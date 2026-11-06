import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../data/datasources/managed_organizations_api_datasource.dart';
import '../../data/models/managed_organization_dto.dart';

/// Vendor organizations eligible for the ticket-scanner picker.
///
/// The exact identity-based auth session is part of the provider key. An
/// A -> B -> A transition therefore creates a fresh request boundary instead
/// of briefly exposing a previous account's cached organizations.
final managedOrganizationsProvider =
    FutureProvider.family<List<ManagedOrganizationDto>, AuthSessionKey>(
        (ref, ownerSession) async {
  if (ownerSession.accountId == null) return const [];

  return ref
      .watch(managedOrganizationsApiDataSourceProvider)
      .getManagedOrganizations();
});
