import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/legal/legal_links.dart';
import '../analytics_consent.dart';

/// Bottom sheet de consentement RGPD.
///
/// Affichée au 1er launch (et tant que [AnalyticsConsentStatus.unknown]) par
/// `MainScaffold`. Non-dismissible : l'utilisateur doit choisir Accepter ou
/// Refuser. Pas de croix de fermeture (conformité CNIL : éviter les dark
/// patterns, boutons équivalents visuellement).
///
/// Strings hardcodées en français pour ce premier livrable — à migrer vers
/// `lib/l10n/app_fr.arb` + `app_en.arb` puis régénération via
/// `flutter gen-l10n` quand le SDK Dart sera aligné.
class ConsentGateModal extends ConsumerWidget {
  const ConsentGateModal._();

  /// Affiche le bottom sheet et résout quand l'utilisateur a tranché.
  /// Retourne le statut choisi (granted / denied) ou null si dismissed
  /// par un événement système (ne devrait pas arriver — isDismissible:false).
  static Future<AnalyticsConsentStatus?> show(BuildContext context) {
    return showModalBottomSheet<AnalyticsConsentStatus>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const ConsentGateModal._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      // Empêche la fermeture par le geste back système — l'utilisateur DOIT
      // choisir. Conforme à l'option A de l'étape 7 (onboarding bloquant).
      canPop: false,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle visuel (purement décoratif, pas d'action).
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.privacy_tip_outlined,
                size: 40,
                color: Color(0xFFFF601F),
              ),
              const SizedBox(height: 12),
              const Text(
                'Aider à améliorer Le Hiboo ?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Nous mesurons l\'usage anonyme de l\'application pour améliorer '
                'les fonctionnalités. Aucune donnée personnelle (nom, e-mail, '
                'téléphone) n\'est collectée. Vous pouvez changer d\'avis à tout '
                'moment dans Paramètres > Confidentialité.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => LegalLinks.open(context, LegalDocument.privacy),
                child: const Text(
                  'En savoir plus sur la politique de confidentialité',
                  style: TextStyle(
                    color: Color(0xFFFF601F),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              // Boutons équivalents visuellement (CNIL : pas de dark pattern).
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _handleChoice(
                        context,
                        ref,
                        AnalyticsConsentStatus.denied,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Refuser',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _handleChoice(
                        context,
                        ref,
                        AnalyticsConsentStatus.granted,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFFFF601F),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Accepter',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleChoice(
    BuildContext context,
    WidgetRef ref,
    AnalyticsConsentStatus choice,
  ) async {
    final notifier = ref.read(analyticsConsentProvider.notifier);
    if (choice == AnalyticsConsentStatus.granted) {
      await notifier.grant();
    } else {
      await notifier.deny();
    }
    if (context.mounted) Navigator.of(context).pop(choice);
  }
}
