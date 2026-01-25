import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/models/event_filter.dart';

/// Result returned when user saves a search
class SaveSearchResult {
  final String name;
  final bool enablePush;
  final bool enableEmail;

  SaveSearchResult({
    required this.name,
    required this.enablePush,
    required this.enableEmail,
  });
}

/// Modal sheet for saving a search with notification options
/// Design inspired by Airbnb/Le Hiboo web version
class SaveSearchSheet extends StatefulWidget {
  final EventFilter filter;
  final bool Function(String name)? isNameAlreadyUsed;

  const SaveSearchSheet({
    super.key,
    required this.filter,
    this.isNameAlreadyUsed,
  });

  /// Show the save search modal and return the result
  static Future<SaveSearchResult?> show(
    BuildContext context, {
    required EventFilter filter,
    bool Function(String name)? isNameAlreadyUsed,
  }) {
    return showModalBottomSheet<SaveSearchResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SaveSearchSheet(
        filter: filter,
        isNameAlreadyUsed: isNameAlreadyUsed,
      ),
    );
  }

  @override
  State<SaveSearchSheet> createState() => _SaveSearchSheetState();
}

class _SaveSearchSheetState extends State<SaveSearchSheet> {
  late TextEditingController _nameController;
  bool _enablePush = true;
  bool _enableEmail = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _generateDefaultName());
    _nameController.addListener(_clearError);
  }

  @override
  void dispose() {
    _nameController.removeListener(_clearError);
    _nameController.dispose();
    super.dispose();
  }

  void _clearError() {
    if (_nameError != null) {
      setState(() => _nameError = null);
    }
  }

  String _generateDefaultName() {
    final filter = widget.filter;
    if (filter.searchQuery.isNotEmpty) return filter.searchQuery;
    if (filter.cityName != null) return filter.cityName!;
    if (filter.categoriesSlugs.isNotEmpty) {
      return 'Ma recherche';
    }
    return 'Ma recherche';
  }

  String _buildFilterSummary() {
    final filter = widget.filter;
    final parts = <String>[];

    // Categories
    if (filter.categoriesSlugs.isNotEmpty) {
      parts.add(filter.categoriesSlugs.join(', '));
    }

    // Location
    if (filter.cityName != null) {
      parts.add('à ${filter.cityName}');
    } else if (filter.latitude != null) {
      parts.add('à ${filter.radiusKm.toInt()} km');
    }

    // Date
    if (filter.dateFilterLabel != null) {
      parts.add(filter.dateFilterLabel!.toLowerCase());
    } else if (filter.startDate != null) {
      final formatter = DateFormat('d MMM yyyy', 'fr_FR');
      parts.add('à partir du ${formatter.format(filter.startDate!)}');
    }

    // Other filters
    if (filter.familyFriendly) parts.add('famille');
    if (filter.onlyFree) parts.add('gratuit');
    if (filter.accessiblePMR) parts.add('PMR');

    if (parts.isEmpty) return 'Tous les événements';
    return parts.join(', ');
  }

  void _save() {
    final name = _nameController.text.trim();

    // Validate name
    if (name.isEmpty) {
      setState(() => _nameError = 'Veuillez entrer un nom pour la recherche');
      return;
    }

    // Check if name is already used
    if (widget.isNameAlreadyUsed != null && widget.isNameAlreadyUsed!(name)) {
      setState(() => _nameError = 'Ce nom est déjà utilisé. Choisissez un autre nom.');
      return;
    }

    Navigator.of(context).pop(SaveSearchResult(
      name: name,
      enablePush: _enablePush,
      enableEmail: _enableEmail,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding + safeBottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sauvegarder la recherche',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Retrouvez facilement cette recherche et recevez des alertes pour les nouveaux événements.',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Filter summary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tune,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Filtres : ${_buildFilterSummary()}',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Name field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nom de la recherche',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      style: GoogleFonts.montserrat(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Ex: Concerts à Paris ce week-end',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                        errorText: _nameError,
                        errorStyle: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.red.shade600,
                        ),
                        filled: true,
                        fillColor: _nameError != null
                            ? Colors.red.shade50
                            : Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _nameError != null
                                ? Colors.red.shade400
                                : Colors.grey.shade300,
                            width: _nameError != null ? 2 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _nameError != null
                                ? Colors.red.shade400
                                : const Color(0xFFFF601F),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.red.shade400,
                            width: 2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.red.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Notifications section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Push toggle
                    _NotificationToggle(
                      icon: Icons.notifications_outlined,
                      title: 'Push',
                      subtitle: 'Notifications sur l\'app mobile',
                      value: _enablePush,
                      onChanged: (v) => setState(() => _enablePush = v),
                    ),

                    const SizedBox(height: 10),

                    // Email toggle
                    _NotificationToggle(
                      icon: Icons.mail_outline,
                      title: 'Email',
                      subtitle: 'Recevez un email pour chaque nouvel événement',
                      value: _enableEmail,
                      onChanged: (v) => setState(() => _enableEmail = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Footer buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'Annuler',
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Save button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF601F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'Sauvegarder',
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Toggle row for notification options
class _NotificationToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value ? const Color(0xFFFF601F).withValues(alpha: 0.3) : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: value
                    ? const Color(0xFFFF601F).withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: value ? const Color(0xFFFF601F) : Colors.grey.shade500,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: const Color(0xFFFF601F),
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.grey.shade400;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
