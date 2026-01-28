import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// Bottom sheet avec détails d'une info pratique
class PracticalInfoSheet extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? imageUrl;
  final Color color;
  final List<PracticalInfoAction>? actions;

  const PracticalInfoSheet({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.imageUrl,
    this.color = HbColors.brandPrimary,
    this.actions,
  });

  static Future<void> show(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? description,
    String? imageUrl,
    Color color = HbColors.brandPrimary,
    List<PracticalInfoAction>? actions,
  }) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PracticalInfoSheet(
        icon: icon,
        title: title,
        description: description,
        imageUrl: imageUrl,
        color: color,
        actions: actions,
      ),
    );
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
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: HbColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Disponible',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
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

          // Contenu
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Description
                if (description != null && description!.isNotEmpty) ...[
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Actions
                if (actions != null && actions!.isNotEmpty) ...[
                  const Text(
                    'Actions rapides',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: HbColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...actions!.map((action) => _buildActionButton(action)),
                ],
              ],
            ),
          ),

          // Bottom padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildActionButton(PracticalInfoAction action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: action.isPrimary
            ? color
            : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  action.icon,
                  color: action.isPrimary ? Colors.white : color,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    action.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: action.isPrimary ? Colors.white : color,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: action.isPrimary
                      ? Colors.white.withValues(alpha: 0.7)
                      : color.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Action pour le bottom sheet
class PracticalInfoAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const PracticalInfoAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });
}

/// Helper pour créer les actions de transport/parking
class PracticalInfoActions {
  static PracticalInfoAction googleMaps({
    required double lat,
    required double lng,
    String? label,
  }) {
    return PracticalInfoAction(
      icon: Icons.directions_car,
      label: label ?? 'Itinéraire en voiture',
      isPrimary: true,
      onTap: () async {
        final url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
    );
  }

  static PracticalInfoAction walkingDirections({
    required double lat,
    required double lng,
  }) {
    return PracticalInfoAction(
      icon: Icons.directions_walk,
      label: 'Y aller à pied',
      onTap: () async {
        final url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=walking',
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
    );
  }

  static PracticalInfoAction publicTransport({
    required double lat,
    required double lng,
  }) {
    return PracticalInfoAction(
      icon: Icons.directions_transit,
      label: 'Transports en commun',
      onTap: () async {
        final url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=transit',
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
    );
  }

  static PracticalInfoAction copyAddress({
    required String address,
    required BuildContext context,
  }) {
    return PracticalInfoAction(
      icon: Icons.copy,
      label: 'Copier l\'adresse',
      onTap: () {
        Clipboard.setData(ClipboardData(text: address));
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adresse copiée'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
