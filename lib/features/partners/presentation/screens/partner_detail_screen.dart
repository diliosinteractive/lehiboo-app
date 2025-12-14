
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import '../../../events/data/mappers/event_mapper.dart';
import '../providers/organizer_provider.dart';

class PartnerDetailScreen extends ConsumerStatefulWidget {
  final String partnerId;

  const PartnerDetailScreen({super.key, required this.partnerId});

  @override
  ConsumerState<PartnerDetailScreen> createState() => _PartnerDetailScreenState();
}

class _PartnerDetailScreenState extends ConsumerState<PartnerDetailScreen> {
  bool _isDescriptionExpanded = false;
  static const int _maxDescriptionLength = 200;

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(widget.partnerId);
    if (id == null) {
      return const Scaffold(body: Center(child: Text('ID Partenaire invalide')));
    }

    final organizerAsync = ref.watch(organizerProfileProvider(id));

    return Scaffold(
      backgroundColor: Colors.white,
      body: organizerAsync.when(
        data: (organizer) => _buildContent(context, ref, organizer),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF601F)),
        ),
        error: (error, stack) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Impossible de charger le partenaire',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF601F),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, EventOrganizerDto organizer) {
    return CustomScrollView(
      slivers: [
        _buildHeader(context, organizer),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSocialStats(organizer),
                const SizedBox(height: 20),
                if (organizer.description != null && organizer.description!.isNotEmpty) ...[
                  _buildExpandableDescription(organizer.description!),
                  const SizedBox(height: 24),
                ],
                _buildContactInfo(context, organizer),
                const SizedBox(height: 24),
                _buildPracticalInfo(organizer),
                const SizedBox(height: 24),
                const Text(
                  'Événements à venir',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        _buildEventsList(ref, organizer.id),
        const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
      ],
    );
  }

  Widget _buildExpandableDescription(String description) {
    final isLongText = description.length > _maxDescriptionLength;
    final displayText = _isDescriptionExpanded || !isLongText
        ? description
        : '${description.substring(0, _maxDescriptionLength)}...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey[800]),
        ),
        if (isLongText)
          GestureDetector(
            onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _isDescriptionExpanded ? 'Voir moins' : 'Lire la suite',
                style: const TextStyle(
                  color: Color(0xFFFF601F),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, EventOrganizerDto organizer) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Cover Image
            if (organizer.coverImage != null)
              CachedNetworkImage(
                imageUrl: organizer.coverImage!,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(color: Colors.grey[200]),
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF601F), Color(0xFFE55A2B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8),
                      ],
                    ),
                    child: ClipOval(
                      child: organizer.logo != null
                          ? CachedNetworkImage(
                              imageUrl: organizer.logo!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.grey),
                            )
                          : Center(
                              child: Text(
                                organizer.name.isNotEmpty ? organizer.name[0].toUpperCase() : '?',
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFF601F)),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                organizer.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (organizer.verified) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.verified, color: Colors.blue, size: 20),
                            ],
                          ],
                        ),
                        if (organizer.memberSince != null)
                          Text(
                            'Membre depuis ${_formatDate(organizer.memberSince!)}',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialStats(EventOrganizerDto organizer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Stats
        if (organizer.stats?.totalEvents != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF601F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_activity, size: 16, color: Color(0xFFFF601F)),
                const SizedBox(width: 8),
                Text(
                  '${organizer.stats!.totalEvents} événements',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF601F)),
                ),
              ],
            ),
          ),
        // Social Links
        if (organizer.socialLinks != null && organizer.socialLinks!.isNotEmpty)
          Row(
            children: organizer.socialLinks!.map((link) {
              return Padding(
                padding: const EdgeInsets.only(left: 12),
                child: InkWell(
                  onTap: () => _launchUrl(link.url),
                  child: link.type != null
                      ? FaIcon(
                          _getSocialIcon(link.type!),
                          color: const Color(0xFF1A1A2E),
                          size: 24,
                        )
                      : const Icon(
                          Icons.link,
                          color: Color(0xFF1A1A2E),
                          size: 24,
                        ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context, EventOrganizerDto organizer) {
    final hasAddress = organizer.location?.city != null || organizer.location?.address != null;
    
    return Column(
      children: [
        if (hasAddress) ...[
          ListTile(
            leading: const Icon(Icons.location_on_outlined, color: Color(0xFFFF601F)),
            title: Text(organizer.location?.city ?? organizer.location?.address ?? ''),
            subtitle: organizer.location?.city != null && organizer.location?.address != null 
                ? Text(organizer.location!.address!)
                : null,
            contentPadding: EdgeInsets.zero,
          ),
          // "Se rendre chez le partenaire" button
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openMaps(organizer.location),
                icon: const Icon(Icons.directions, size: 20),
                label: const Text('Se rendre chez le partenaire'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF601F),
                  side: const BorderSide(color: Color(0xFFFF601F)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
        if (organizer.contact?.phone != null)
          ListTile(
            leading: const Icon(Icons.phone_outlined, color: Color(0xFFFF601F)),
            title: Text(organizer.contact!.phone!),
            contentPadding: EdgeInsets.zero,
            onTap: () => _launchUrl('tel:${organizer.contact!.phone}'),
          ),
        if (organizer.contact?.email != null)
          ListTile(
            leading: const Icon(Icons.email_outlined, color: Color(0xFFFF601F)),
            title: Text(organizer.contact!.email!),
            contentPadding: EdgeInsets.zero,
            onTap: () => _launchUrl('mailto:${organizer.contact!.email}'),
          ),
        if (organizer.contact?.website != null)
          ListTile(
            leading: const Icon(Icons.language_outlined, color: Color(0xFFFF601F)),
            title: const Text('Visiter le site web'),
            contentPadding: EdgeInsets.zero,
            onTap: () => _launchUrl(organizer.contact!.website),
          ),
      ],
    );
  }

  Widget _buildPracticalInfo(EventOrganizerDto organizer) {
    if (organizer.practicalInfo == null) return const SizedBox();
    final info = organizer.practicalInfo!;
    
    final items = <Widget>[];

    if (info.pmr) {
      items.add(_buildInfoChip(Icons.accessible, 'Accès PMR', info.pmrInfos));
    }
    if (info.restauration) {
      items.add(_buildInfoChip(Icons.restaurant, 'Restauration', info.restaurationInfos));
    }
    if (info.boisson) {
      items.add(_buildInfoChip(Icons.local_bar, 'Boissons', info.boissonInfos));
    }
    if (info.stationnement != null) {
      items.add(_buildInfoChip(Icons.local_parking, 'Stationnement', info.stationnement));
    }
    if (info.eventType != null) {
      items.add(_buildInfoChip(
        info.eventType == 'interieur' ? Icons.home : Icons.park,
        info.eventType == 'interieur' ? 'Intérieur' : (info.eventType == 'exterieur' ? 'Extérieur' : 'Mixte'),
        null,
      ));
    }

    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Infos pratiques',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items,
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String? subLabel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: const Color(0xFFFF601F)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A1A2E)),
              ),
            ],
          ),
          if (subLabel != null && subLabel.isNotEmpty)
             Text(
               subLabel,
               style: const TextStyle(fontSize: 12, color: Colors.grey),
             ),
        ],
      ),
    );
  }

  Widget _buildEventsList(WidgetRef ref, int organizerId) {
    final eventsAsync = ref.watch(organizerEventsProvider(organizerId));

    return eventsAsync.when(
      data: (response) {
        final events = response.events.map(EventMapper.toEvent).toList();
        if (events.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Aucun événement à venir', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final event = events[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => context.push('/events/${event.id}'),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: event.coverImage != null && event.coverImage!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: event.coverImage!,
                                  width: 100,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 100,
                                    height: 70,
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF601F)),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, err) => Container(
                                    width: 100,
                                    height: 70,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                                  ),
                                )
                              : Container(
                                  width: 100,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.event, color: Colors.grey, size: 32),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                                  Text(
                                    // Simplified date display
                                    DateFormat('dd MMM yyyy', 'fr').format(event.startDate),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                              const SizedBox(height: 4),
                               Text(
                                event.city,
                                style: const TextStyle(fontSize: 12, color: Color(0xFFFF601F)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: events.length,
            ),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
      error: (e, s) => SliverToBoxAdapter(child: Text('Erreur: $e')),
    );
  }

  IconData _getSocialIcon(String type) {
    switch (type.toLowerCase()) {
      case 'facebook': return FontAwesomeIcons.facebook;
      case 'instagram': return FontAwesomeIcons.instagram;
      case 'twitter': return FontAwesomeIcons.twitter;
      case 'x': return FontAwesomeIcons.xTwitter;
      case 'linkedin': return FontAwesomeIcons.linkedin;
      case 'youtube': return FontAwesomeIcons.youtube;
      case 'tiktok': return FontAwesomeIcons.tiktok;
      case 'whatsapp': return FontAwesomeIcons.whatsapp;
      case 'telegram': return FontAwesomeIcons.telegram;
      case 'snapchat': return FontAwesomeIcons.snapchat;
      case 'pinterest': return FontAwesomeIcons.pinterest;
      default: return FontAwesomeIcons.link;
    }
  }

  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null) return;
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openMaps(OrganizerLocationDto? location) async {
    if (location == null) return;
    
    // Build address string for maps
    final parts = <String>[];
    if (location.address != null) parts.add(location.address!);
    if (location.postcode != null) parts.add(location.postcode!);
    if (location.city != null) parts.add(location.city!);
    if (location.country != null) parts.add(location.country!);
    
    if (parts.isEmpty) return;
    
    final address = parts.join(', ');
    final encodedAddress = Uri.encodeComponent(address);
    
    // Use Google Maps URL - opens in Google Maps app if installed, otherwise browser
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
    final googleUri = Uri.parse(googleMapsUrl);
    
    if (await canLaunchUrl(googleUri)) {
      await launchUrl(googleUri, mode: LaunchMode.externalApplication);
    }
  }
  
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
