import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../providers/business_register_provider.dart';

extension AuthRegistrationL10n on BuildContext {
  String organizationTypeLabel(OrganizationType type) {
    final l10n = this.l10n;
    return switch (type) {
      OrganizationType.company => l10n.authOrganizationCompanyLabel,
      OrganizationType.association => l10n.authOrganizationAssociationLabel,
      OrganizationType.municipality => l10n.authOrganizationMunicipalityLabel,
    };
  }

  String organizationTypeDescription(OrganizationType type) {
    final l10n = this.l10n;
    return switch (type) {
      OrganizationType.company => l10n.authOrganizationCompanyDescription,
      OrganizationType.association =>
        l10n.authOrganizationAssociationDescription,
      OrganizationType.municipality =>
        l10n.authOrganizationMunicipalityDescription,
    };
  }

  String organizationTypeLower(OrganizationType type) {
    final l10n = this.l10n;
    return switch (type) {
      OrganizationType.company => l10n.authOrganizationCompanyLower,
      OrganizationType.association => l10n.authOrganizationAssociationLower,
      OrganizationType.municipality => l10n.authOrganizationMunicipalityLower,
    };
  }

  String organizationTypeArticle(OrganizationType type) {
    final l10n = this.l10n;
    return switch (type) {
      OrganizationType.company => l10n.authOrganizationCompanyArticle,
      OrganizationType.association => l10n.authOrganizationAssociationArticle,
      OrganizationType.municipality => l10n.authOrganizationMunicipalityArticle,
    };
  }

  String organizationTypePossessive(OrganizationType type) {
    final l10n = this.l10n;
    return switch (type) {
      OrganizationType.company => l10n.authOrganizationCompanyPossessive,
      OrganizationType.association =>
        l10n.authOrganizationAssociationPossessive,
      OrganizationType.municipality =>
        l10n.authOrganizationMunicipalityPossessive,
    };
  }

  String usageModeLabel(UsageMode mode) {
    final l10n = this.l10n;
    return switch (mode) {
      UsageMode.personal => l10n.authUsageModePersonalLabel,
      UsageMode.team => l10n.authUsageModeTeamLabel,
    };
  }

  String usageModeDescription(UsageMode mode) {
    final l10n = this.l10n;
    return switch (mode) {
      UsageMode.personal => l10n.authUsageModePersonalDescription,
      UsageMode.team => l10n.authUsageModeTeamDescription,
    };
  }
}
