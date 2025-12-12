import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class GuestRestrictionDialog extends StatelessWidget {
  final String featureName;

  const GuestRestrictionDialog({
    super.key,
    required this.featureName,
  });

  static Future<void> show(BuildContext context, {required String featureName}) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => GuestRestrictionDialog(featureName: featureName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Animated Header Icon (No Gradient - Flat Brand Color)
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF601F).withOpacity(0.1), // Gentle background
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_person_rounded,
                  size: 32,
                  color: Color(0xFFFF601F), // Brand primary color
                ),
              )
              .animate()
              .scale(duration: 400.ms, curve: Curves.easeOutBack), // Kept animation but removed shimmer

              const SizedBox(height: 24),

              // 2. Title
              const Text(
                'Connectez-vous !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms).moveY(begin: 10, end: 0),

              const SizedBox(height: 12),

              // 3. Body
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF718096),
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Vous devez être connecté pour '),
                    TextSpan(
                      text: featureName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const TextSpan(text: '.\n'),
                    const TextSpan(
                      text: 'Cela ne prend que 2 minutes et c\'est gratuit !',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        color: Color(0xFFFF601F),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms).moveY(begin: 10, end: 0),

              const SizedBox(height: 32),

              // 4. Primary Button (Flat Brand Color)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop(); // Close dialog
                    context.push('/login'); // Go to login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF601F), // Solid Brand Color
                    foregroundColor: Colors.white,
                    elevation: 0, // Flat
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms).moveY(begin: 20, end: 0),

              const SizedBox(height: 12),

              // 5. Secondary Action
              TextButton(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(
                   foregroundColor: Colors.grey[500],
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  'Plus tard',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
