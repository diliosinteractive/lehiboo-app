import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n.dart';
import '../../domain/models/onboarding_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingContent> _contents(BuildContext context) {
    final l10n = context.l10n;
    return [
      OnboardingContent(
        title: l10n.onboardingExploreTitle,
        description: l10n.onboardingExploreDescription,
        imagePath: 'assets/images/onboarding_screen_1.png',
      ),
      OnboardingContent(
        title: l10n.onboardingMusicTitle,
        description: l10n.onboardingMusicDescription,
        imagePath: 'assets/images/onboarding_n_1.png',
      ),
      OnboardingContent(
        title: l10n.onboardingLocalTitle,
        description: l10n.onboardingLocalDescription,
        imagePath: 'assets/images/onboarding_n_2.png',
      ),
      OnboardingContent(
        title: l10n.onboardingAssociationTitle,
        description: l10n.onboardingAssociationDescription,
        imagePath: 'assets/images/onboarding_association.png',
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingCompleted, true);

    if (mounted) {
      // Location permission is the last step of first-launch onboarding.
      // Marking the flag completed BEFORE navigation means if the user kills
      // the app on the permission screen, the next launch goes straight to
      // /login — they don't get the carousel again. On-demand location
      // requests in search filters still re-prompt if needed.
      context.go('/post-signup/location');
    }
  }

  @override
  Widget build(BuildContext context) {
    final contents = _contents(context);
    final l10n = context.l10n;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with PageView
          PageView.builder(
            controller: _pageController,
            itemCount: contents.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildPage(contents[index]);
            },
          ),

          // Top gradient to keep the logo and skip button readable.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: MediaQuery.of(context).padding.top + 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.55, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.28),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // LeHiboo Logo
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: Image.asset(
              'assets/images/logo_lehiboo_experience.png',
              width: 120,
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
              child: Text(
                l10n.onboardingSkip,
                style: const TextStyle(
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
                    contents.length,
                    (index) => _buildDot(index),
                  ),
                ),

                // Next / Finish Button
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == contents.length - 1) {
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == contents.length - 1
                        ? l10n.onboardingGetStarted
                        : l10n.commonNext,
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
                  child: Icon(Icons.image_not_supported,
                      color: Colors.white54, size: 50),
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
