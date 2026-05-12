import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/env_config.dart';

/// The five canonical legal documents seeded on the backend.
///
/// Slugs are a stable contract with the backend; see
/// `docs/LEGAL_PAGES_MOBILE_SPEC.md` §1.
enum LegalDocument {
  terms('cgu', "Conditions Générales d'Utilisation",
      Icons.description_outlined),
  sales('cgv', 'Conditions Générales de Vente', Icons.shopping_bag_outlined),
  privacy('privacy', 'Politique de confidentialité', Icons.privacy_tip_outlined),
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

  // TODO(i18n): derive from app locale once localization is wired up.
  static const String _currentLocale = 'fr';

  static Uri urlFor(LegalDocument doc) =>
      Uri.parse('${EnvConfig.websiteUrl}/$_currentLocale/${doc.slug}');

  static Future<void> open(BuildContext context, LegalDocument doc) async {
    final uri = urlFor(doc);
    final ok = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    if (ok) return;
    if (!context.mounted) return;

    final fallbackOk =
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (fallbackOk) return;
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Impossible d'ouvrir ${doc.label}")),
    );
  }
}
