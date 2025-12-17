import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/onboarding_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    const OnboardingContent(
      title: 'Vibrez au rythme de votre ville',
      description: 'Découvrez les concerts, festivals et soirées qui font bouger votre région. Ne ratez plus aucun événement musical.',
      imagePath: 'assets/images/onboarding_n_1.png',
    ),
    const OnboardingContent(
      title: 'Savourez chaque instant',
      description: 'Des marchés gourmands aux meilleures adresses de street food, trouvez les pépites culinaires autour de vous.',
      imagePath: 'assets/images/onboarding_n_2.png',
    ),
    const OnboardingContent(
      title: 'Restez Connecté',
      description: 'Recevez toutes les communications de la ville, restez informé des événements de votre municipalité et gardez le contact avec votre mairie.',
      imagePath: 'assets/images/onboarding_city_comms.png',
    ),
    const OnboardingContent(
      title: 'Libérez votre créativité',
      description: 'Participez à des ateliers uniques : poterie, peinture, et bien plus. Rencontrez des passionnés et apprenez en vous amusant.',
      imagePath: 'assets/images/onboarding_n_3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingCompleted, true);

    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with PageView
          PageView.builder(
            controller: _pageController,
            itemCount: _contents.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildPage(_contents[index]);
            },
          ),

          // LeHiboo Logo
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            child: Image.asset(
              'assets/images/logo_lehiboo_blanc_x3_2.png',
              width: 100, // Adjust size as needed
              fit: BoxFit.contain,
            ),
          ),

          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: TextButton(
              onPressed: _completeOnboarding,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Passer',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Bottom Section (Indicators & Button)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicators
                Row(
                  children: List.generate(
                    _contents.length,
                    (index) => _buildDot(index),
                  ),
                ),

                // Next / Finish Button
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _contents.length - 1) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF601F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == _contents.length - 1 ? 'C\'est parti' : 'Suivant',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Stack(
      children: [
        // Full screen image
        Positioned.fill(
          child: Image.asset(
            content.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.white54, size: 50),
                ),
              );
            },
          ),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
        ),

        // Text Content
        Positioned(
          bottom: 140, // Space for bottom navigation
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? const Color(0xFFFF601F)
            : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
