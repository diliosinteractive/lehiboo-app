import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/env_config.dart';
import '../../core/l10n/app_locale.dart';
import '../../core/l10n/l10n.dart';

/// The five canonical legal documents seeded on the backend.
///
/// Slugs are a stable contract with the backend; see
/// `docs/LEGAL_PAGES_MOBILE_SPEC.md` §1.
enum LegalDocument {
  terms(
      'cgu', "Conditions Générales d'Utilisation", Icons.description_outlined),
  sales('cgv', 'Conditions Générales de Vente', Icons.shopping_bag_outlined),
  privacy(
      'privacy', 'Politique de confidentialité', Icons.privacy_tip_outlined),
  cookies('cookies', 'Politique cookies', Icons.cookie_outlined),
  legalNotices('mentions-legales', 'Mentions légales', Icons.gavel_outlined);

  const LegalDocument(this.slug, this.label, this.icon);

  final String slug;
  final String label;
  final IconData icon;
}

/// Strategy A from the legal pages spec: tap → open the web page in an
/// in-app browser (SFSafariViewController on iOS, Chrome Custom Tabs on
/// Android). Web is the source of truth, so legal copy can change without a
/// mobile release.
class LegalLinks {
  LegalLinks._();

  static Uri urlFor(LegalDocument doc, {String? languageCode}) {
    final locale =
        normalizeLanguageCode(languageCode) ?? fallbackAppLocale.languageCode;
    return Uri.parse('${EnvConfig.websiteUrl}/$locale/${doc.slug}');
  }

  static String labelFor(BuildContext context, LegalDocument doc) {
    final l10n = context.l10n;
    return switch (doc) {
      LegalDocument.terms => l10n.legalTerms,
      LegalDocument.sales => l10n.legalSales,
      LegalDocument.privacy => l10n.legalPrivacy,
      LegalDocument.cookies => l10n.legalCookies,
      LegalDocument.legalNotices => l10n.legalNotices,
    };
  }

  static Future<void> open(BuildContext context, LegalDocument doc) async {
    final docLabel = labelFor(context, doc);
    final failedMessage = context.l10n.legalOpenFailed(docLabel);
    final uri = urlFor(doc, languageCode: context.appLanguageCode);
    final ok = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    if (ok) return;
    if (!context.mounted) return;

    final fallbackOk =
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (fallbackOk) return;
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(failedMessage)),
    );
  }
}
