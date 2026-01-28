import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Bottom sheet de partage social
///
/// Options:
/// - Copier le lien
/// - WhatsApp
/// - Facebook
/// - Instagram Story
/// - Plus d'options (share natif)
class EventShareSheet extends StatelessWidget {
  final Event event;
  final String? shareUrl;

  const EventShareSheet({
    super.key,
    required this.event,
    this.shareUrl,
  });

  static Future<void> show(
    BuildContext context, {
    required Event event,
    String? shareUrl,
  }) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventShareSheet(
        event: event,
        shareUrl: shareUrl,
      ),
    );
  }

  String get _shareUrl => shareUrl ?? 'https://lehiboo.com/event/${event.id}';

  String get _shareText {
    final title = event.title;
    final venue = event.venue.isNotEmpty ? event.venue : event.city;
    final date = _formatDate(event.startDate);

    final parts = <String>[title];
    if (venue.isNotEmpty) parts.add('📍 $venue');
    parts.add('📅 $date');
    parts.add(_shareUrl);

    return parts.join('\n');
  }

  String _formatDate(DateTime date) {
    final months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: HbColors.brandPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.share,
                    color: HbColors.brandPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Partager cet événement',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: HbColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Options de partage
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Grille d'icônes sociales
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShareIcon(
                      context,
                      icon: Icons.link,
                      label: 'Copier',
                      color: Colors.grey.shade700,
                      onTap: () => _copyLink(context),
                    ),
                    _buildShareIcon(
                      context,
                      icon: FontAwesomeIcons.whatsapp,
                      label: 'WhatsApp',
                      color: const Color(0xFF25D366),
                      onTap: () => _shareWhatsApp(context),
                    ),
                    _buildShareIcon(
                      context,
                      icon: FontAwesomeIcons.facebook,
                      label: 'Facebook',
                      color: const Color(0xFF1877F2),
                      onTap: () => _shareFacebook(context),
                    ),
                    _buildShareIcon(
                      context,
                      icon: FontAwesomeIcons.instagram,
                      label: 'Instagram',
                      color: const Color(0xFFE4405F),
                      onTap: () => _shareInstagram(context),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Bouton partage natif
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _shareNative(context),
                    icon: const Icon(Icons.ios_share),
                    label: const Text('Plus d\'options'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HbColors.brandPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildShareIcon(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _shareUrl));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lien copié'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _shareWhatsApp(BuildContext context) async {
    Navigator.pop(context);
    final encodedText = Uri.encodeComponent(_shareText);
    final url = Uri.parse('https://wa.me/?text=$encodedText');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Fallback vers share natif
      await Share.share(_shareText);
    }
  }

  Future<void> _shareFacebook(BuildContext context) async {
    Navigator.pop(context);
    final encodedUrl = Uri.encodeComponent(_shareUrl);
    final url = Uri.parse('https://www.facebook.com/sharer/sharer.php?u=$encodedUrl');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareInstagram(BuildContext context) async {
    Navigator.pop(context);
    // Instagram ne supporte pas le partage direct de liens
    // On ouvre l'app ou le share natif
    await Share.share(_shareText);
  }

  Future<void> _shareNative(BuildContext context) async {
    Navigator.pop(context);
    await Share.share(
      _shareText,
      subject: event.title,
    );
  }
}

/// Bouton de partage circulaire pour l'AppBar
class ShareButton extends StatelessWidget {
  final Event event;
  final String? shareUrl;
  final Color? backgroundColor;
  final Color? iconColor;

  const ShareButton({
    super.key,
    required this.event,
    this.shareUrl,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          Icons.share_outlined,
          size: 20,
          color: iconColor ?? HbColors.textPrimary,
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          EventShareSheet.show(
            context,
            event: event,
            shareUrl: shareUrl,
          );
        },
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        style: IconButton.styleFrom(padding: EdgeInsets.zero),
      ),
    );
  }
}
