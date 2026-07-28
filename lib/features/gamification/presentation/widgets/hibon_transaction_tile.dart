import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../data/models/hibon_transaction.dart';

/// Ligne d'historique d'une transaction Hibons.
///
/// Crédit/débit dérivés du **signe du montant** (plus robuste que l'enum à
/// 3 valeurs), libellé via `typeLabel`/`title`/`description`. Tap → fiche
/// event/organisation liée si présente dans le contexte.
class HibonTransactionTile extends StatelessWidget {
  final HibonTransaction transaction;

  const HibonTransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final tx = transaction;
    final isCredit = tx.amount >= 0;
    final pillarColor = _parsePillarColor(tx.pillarColor);
    final dateLabel = context
        .appDateFormat('dd/MM/yyyy HH:mm', enPattern: 'MM/dd/yyyy HH:mm')
        .format(tx.timestamp);

    return ListTile(
      onTap: _navigationTarget(tx) != null ? () => _navigate(context, tx) : null,
      leading: tx.context?.imageUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(tx.context!.imageUrl!),
            )
          : CircleAvatar(
              backgroundColor: pillarColor != null
                  ? pillarColor.withValues(alpha: 0.15)
                  : (isCredit ? Colors.green.shade100 : Colors.red.shade100),
              child: Icon(
                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: pillarColor ?? (isCredit ? Colors.green : Colors.red),
                size: 20,
              ),
            ),
      title: Text(tx.title ?? tx.typeLabel ?? tx.description ?? ''),
      subtitle: Text(
        tx.subtitle != null ? '${tx.subtitle} • $dateLabel' : dateLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        tx.formattedAmount ?? '${isCredit ? '+' : ''}${tx.amount}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isCredit ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  /// Retourne la route cible selon le contexte, ou `null` si non navigable.
  String? _navigationTarget(HibonTransaction tx) {
    final ctx = tx.context;
    if (ctx == null) return null;
    final identifier = ctx.slug ?? ctx.uuid;
    if (identifier == null) return null;
    switch (ctx.type) {
      case 'event':
        return '/event/$identifier';
      case 'organization':
        return '/organizers/$identifier';
      default:
        // booking : pas d'identifiant routable (uniquement `reference`).
        return null;
    }
  }

  void _navigate(BuildContext context, HibonTransaction tx) {
    final target = _navigationTarget(tx);
    if (target != null) context.push(target);
  }

  Color? _parsePillarColor(String? hex) {
    if (hex == null) return null;
    final cleaned = hex.replaceAll('#', '');
    final value = int.tryParse(cleaned, radix: 16);
    if (value == null) return null;
    if (cleaned.length == 6) return Color(0xFF000000 | value);
    return Color(value);
  }
}
