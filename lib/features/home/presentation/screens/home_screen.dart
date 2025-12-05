import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedTimeFilter = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo-header.png',
              width: 120,
              height: 32,
              fit: BoxFit.contain,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1E3A8A)),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF1E3A8A)),
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF1E3A8A)),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero section avec image et texte + section de recherche superposée
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Hero background
                Container(
                  height: 320,
                  child: Stack(
                    children: [
                      // Image de fond
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80'
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Overlay gradient
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                      // Texte overlay
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 140,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trouvez votre prochaine',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'aventure ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10.0,
                                          color: Colors.black.withOpacity(0.5),
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'locale',
                                    style: TextStyle(
                                      color: Color(0xFFFF6B35),
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10.0,
                                          color: Colors.black.withOpacity(0.5),
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' près de',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10.0,
                                          color: Colors.black.withOpacity(0.5),
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'chez vous',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(2, 2),
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
                // Section de recherche superposée
                Positioned(
                  bottom: -20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barre de recherche
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFFE5E5E5),
                        ),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Recherchez votre ville, une activité ...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Boutons de filtre temporel
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTimeFilterChip('Aujourd\'hui', 0),
                          const SizedBox(width: 8),
                          _buildTimeFilterChip('Demain', 1),
                          const SizedBox(width: 8),
                          _buildTimeFilterChip('Cette semaine', 2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Bouton rechercher
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/search'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Rechercher',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Recherche avancée
                    Center(
                      child: TextButton.icon(
                        onPressed: () => context.push('/filters'),
                        icon: Icon(
                          Icons.tune,
                          color: Color(0xFFFF6B35),
                          size: 18,
                        ),
                        label: Text(
                          'Recherche avancée',
                          style: TextStyle(
                            color: Color(0xFFFF6B35),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                  ),
                ),
              ],
            ),
          ),

          // Espace pour compenser la superposition
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),

          // Section catégories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grid des catégories
                  Row(
                    children: [
                      Expanded(
                        child: _buildCategoryCard(
                          'Concert',
                          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?q=80&w=2070',
                          Icons.music_note,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCategoryCard(
                          'Médiathèque',
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=2070',
                          Icons.library_books,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Section Activités recommandées
          SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Les recommandations',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/events'),
                            child: Text(
                              'Voir plus',
                              style: TextStyle(
                                color: Color(0xFFFF6B35),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final events = _getDemoEvents();
                          final event = events[index % events.length];
                          return Container(
                            width: 260,
                            margin: const EdgeInsets.only(right: 16),
                            child: _buildEventCard(event),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Section Web/Retrouvez-nous
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8B5A)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Retrouvez vos événements en toute simplicité',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Notre site web offre une expérience complète pour découvrir et réserver vos activités locales.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFFFF6B35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Découvrir le site'),
                      ),
                    ],
                  ),
                ),
              ),

              // Section Promotions
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Offres et bons plans',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.electric_bolt,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ELECTRO',
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Jusqu\'à -50% sur les spectacles',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Section Top 6 des villes
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Top 6 des villes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.count(
                        crossAxisCount: 2,
                        scrollDirection: Axis.horizontal,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                        children: [
                          _buildCityCard('Paris', 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073'),
                          _buildCityCard('Lyon', 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?q=80&w=2071'),
                          _buildCityCard('Marseille', 'https://images.unsplash.com/photo-1557750255-c76072a7aad1?q=80&w=2070'),
                          _buildCityCard('Toulouse', 'https://images.unsplash.com/photo-1574958269340-fa927503f3dd?q=80&w=2070'),
                          _buildCityCard('Nice', 'https://images.unsplash.com/photo-1491166617655-0723a0999cfc?q=80&w=2071'),
                          _buildCityCard('Bordeaux', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2071'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Section Articles
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Les articles',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Voir tout',
                              style: TextStyle(
                                color: Color(0xFFFF6B35),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildArticleCard(
                            'Top des activités famille',
                            'Découvrez les meilleures activités pour profiter en famille ce week-end dans votre région.',
                            'https://images.unsplash.com/photo-1609220136736-443140cffec6?q=80&w=2070',
                          ),
                          const SizedBox(height: 16),
                          _buildArticleCard(
                            'Nouveaux partenaires',
                            'De nouveaux lieux et activités rejoignent Le Hiboo pour enrichir votre expérience locale.',
                            'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?q=80&w=2069',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Section Newsletter
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFFE5E5E5)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.mail_outline,
                        size: 48,
                        color: Color(0xFFFF6B35),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nos meilleures découvertes dans votre boîte mail',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Recevez chaque semaine une sélection d\'activités adaptées à vos envies',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Votre adresse email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF6B35),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'S\'inscrire',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Espace en bas
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
    );
  }


  Widget _buildTimeFilterChip(String label, int index) {
    final isSelected = _selectedTimeFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFE5E5E5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2D3748),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl, IconData icon) {
    return GestureDetector(
      onTap: () => context.push('/events?category=$title'),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: Color(0xFF2D3748),
          fontSize: 14,
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Color(0xFFE5E5E5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image avec badges
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(event['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Badge category
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      event['category'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        event['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                        color: event['isFavorite'] ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {},
                      padding: const EdgeInsets.all(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${event['date']} • ${event['time']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${event['location']} • ${event['distance']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event['price'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                      if (event['spotsLeft'] != null)
                        Text(
                          '${event['spotsLeft']} places',
                          style: TextStyle(
                            fontSize: 12,
                            color: event['spotsLeft'] <= 5 ? Colors.red : Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityCard(String cityName, String imageUrl) {
    return GestureDetector(
      onTap: () => context.push('/events?city=$cityName'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(8),
          child: Text(
            cityName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(String title, String description, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lire l\'article',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFFF6B35),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  List<Map<String, dynamic>> _getDemoEvents() {
    return [
      {
        'id': '1',
        'title': 'Atelier poterie pour enfants',
        'category': 'Atelier',
        'date': 'Samedi 15 juin',
        'time': '14h00 - 16h00',
        'location': 'Centre culturel',
        'distance': '0.8 km',
        'price': 'Gratuit',
        'image': 'https://picsum.photos/400/300?random=1',
        'isFavorite': false,
        'spotsLeft': 3,
        'totalSpots': 12,
        'tags': ['Enfants', 'Créatif', 'Intérieur'],
      },
      {
        'id': '2',
        'title': 'Concert Jazz au parc',
        'category': 'Concert',
        'date': 'Dimanche 16 juin',
        'time': '17h00',
        'location': 'Parc municipal',
        'distance': '1.2 km',
        'price': '15€',
        'image': 'https://picsum.photos/400/300?random=2',
        'isFavorite': true,
        'spotsLeft': 20,
        'totalSpots': 50,
        'tags': ['Musique', 'Extérieur', 'Tout public'],
      },
      {
        'id': '3',
        'title': 'Marché des producteurs locaux',
        'category': 'Marché',
        'date': 'Samedi 15 juin',
        'time': '8h00 - 13h00',
        'location': 'Place du marché',
        'distance': '0.5 km',
        'price': 'Gratuit',
        'image': 'https://picsum.photos/400/300?random=3',
        'isFavorite': false,
        'tags': ['Alimentation', 'Local', 'Famille'],
      },
      {
        'id': '4',
        'title': 'Spectacle de magie',
        'category': 'Spectacle',
        'date': 'Vendredi 14 juin',
        'time': '20h30',
        'location': 'Théâtre municipal',
        'distance': '2.1 km',
        'price': '12€ - 18€',
        'image': 'https://picsum.photos/400/300?random=4',
        'isFavorite': false,
        'spotsLeft': 10,
        'totalSpots': 80,
        'tags': ['Famille', 'Divertissement', 'Intérieur'],
      },
      {
        'id': '5',
        'title': 'Cours de yoga en plein air',
        'category': 'Sport',
        'date': 'Dimanche 16 juin',
        'time': '9h00 - 10h30',
        'location': 'Jardin botanique',
        'distance': '1.8 km',
        'price': '10€',
        'image': 'https://picsum.photos/400/300?random=5',
        'isFavorite': true,
        'spotsLeft': 5,
        'totalSpots': 15,
        'tags': ['Sport', 'Bien-être', 'Extérieur'],
      },
    ];
  }
}
