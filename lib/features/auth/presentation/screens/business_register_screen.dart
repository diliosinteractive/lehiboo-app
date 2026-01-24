import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/business_register_provider.dart';
import '../widgets/step_indicator.dart';
import '../widgets/personal_info_form.dart';
import '../widgets/otp_verification_form.dart';
import '../widgets/company_info_form.dart';
import '../widgets/usage_mode_form.dart';
import '../widgets/terms_acceptance_form.dart';

/// Business registration multi-step screen
class BusinessRegisterScreen extends ConsumerStatefulWidget {
  const BusinessRegisterScreen({super.key});

  @override
  ConsumerState<BusinessRegisterScreen> createState() => _BusinessRegisterScreenState();
}

class _BusinessRegisterScreenState extends ConsumerState<BusinessRegisterScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleBack() {
    final state = ref.read(businessRegisterProvider);
    if (state.canGoBack) {
      ref.read(businessRegisterProvider.notifier).previousStep();
      _goToPage(state.stepIndex - 1);
    } else {
      context.pop();
    }
  }

  void _handleRegistrationComplete() {
    final state = ref.read(businessRegisterProvider);

    // Set authenticated user in auth provider
    if (state.authenticatedUser != null) {
      ref.read(authProvider.notifier).setAuthenticatedUser(state.authenticatedUser!);
    }

    // Show success dialog and navigate to home
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SuccessDialog(
        organizationName: state.organization?.name,
        onContinue: () {
          Navigator.pop(context);
          // Reset provider state
          ref.read(businessRegisterProvider.notifier).reset();
          // Navigate to home
          context.go('/');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessRegisterProvider);

    // Listen for step changes and animate PageView
    ref.listen<BusinessRegisterState>(businessRegisterProvider, (previous, next) {
      if (previous?.stepIndex != next.stepIndex) {
        _goToPage(next.stepIndex);
      }

      // Handle registration completion
      if (next.isRegistrationComplete && !previous!.isRegistrationComplete) {
        _handleRegistrationComplete();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: _handleBack,
        ),
        title: Text(
          'Compte Professionnel',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          // Close button
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF2D3748)),
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Annuler l\'inscription ?'),
                  content: const Text(
                    'Votre progression sera perdue.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Continuer'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(businessRegisterProvider.notifier).reset();
                        context.go('/login');
                      },
                      child: const Text(
                        'Annuler',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: StepIndicator(
                currentStep: state.stepIndex,
                totalSteps: state.totalSteps,
              ),
            ),

            // Success message
            if (state.successMessage != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.successMessage!,
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        ref.read(businessRegisterProvider.notifier).clearSuccess();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

            // Error message
            if (state.errorMessage != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        ref.read(businessRegisterProvider.notifier).clearError();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

            // Forms
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Step 1: Personal Info
                  PersonalInfoForm(
                    onSubmit: () {}, // Navigation handled by state listener
                  ),

                  // Step 2: OTP Verification
                  OtpVerificationForm(
                    onSubmit: () {},
                    onBack: _handleBack,
                  ),

                  // Step 3: Company Info
                  CompanyInfoForm(
                    onSubmit: () {},
                    onBack: _handleBack,
                  ),

                  // Step 4: Usage Mode
                  UsageModeForm(
                    onSubmit: () {},
                    onBack: _handleBack,
                  ),

                  // Step 5: Terms & Summary
                  TermsAcceptanceForm(
                    onSubmit: () {},
                    onBack: _handleBack,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Success dialog shown after registration with confetti animation
class _SuccessDialog extends StatefulWidget {
  final String? organizationName;
  final VoidCallback onContinue;

  const _SuccessDialog({
    this.organizationName,
    required this.onContinue,
  });

  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    // Start confetti animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dialog
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon with animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF48BB78).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF48BB78),
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Inscription réussie !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  widget.organizationName != null
                      ? 'Votre compte professionnel pour "${widget.organizationName}" a été créé avec succès.'
                      : 'Votre compte professionnel a été créé avec succès.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Vous pouvez maintenant accéder à toutes les fonctionnalités de LeHiboo.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: widget.onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF601F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Commencer',
                      style: TextStyle(
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

        // Confetti from top center
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2, // Down
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.1,
            shouldLoop: false,
            colors: const [
              Color(0xFFFF601F), // Orange LeHiboo
              Color(0xFF48BB78), // Green
              Color(0xFFFFD93D), // Yellow
              Color(0xFF6C63FF), // Purple
              Color(0xFFFF6B6B), // Red
            ],
          ),
        ),
      ],
    );
  }
}
