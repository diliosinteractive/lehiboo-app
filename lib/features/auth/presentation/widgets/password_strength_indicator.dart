import 'package:flutter/material.dart';

/// Password strength levels
enum PasswordStrength {
  weak,
  fair,
  good,
  strong,
}

extension PasswordStrengthExtension on PasswordStrength {
  Color get color {
    switch (this) {
      case PasswordStrength.weak:
        return const Color(0xFFE53E3E); // Red
      case PasswordStrength.fair:
        return const Color(0xFFED8936); // Orange
      case PasswordStrength.good:
        return const Color(0xFFECC94B); // Yellow
      case PasswordStrength.strong:
        return const Color(0xFF48BB78); // Green
    }
  }

  String get label {
    switch (this) {
      case PasswordStrength.weak:
        return 'Faible';
      case PasswordStrength.fair:
        return 'Moyen';
      case PasswordStrength.good:
        return 'Bon';
      case PasswordStrength.strong:
        return 'Fort';
    }
  }

  double get percentage {
    switch (this) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.fair:
        return 0.5;
      case PasswordStrength.good:
        return 0.75;
      case PasswordStrength.strong:
        return 1.0;
    }
  }
}

/// A widget that displays password strength with a progress bar
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final bool showRequirements;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.showRequirements = true,
  });

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength(password);
    final requirements = _getRequirements(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bar
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: password.isEmpty ? 0 : strength.percentage,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(strength.color),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              password.isEmpty ? '' : strength.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: strength.color,
              ),
            ),
          ],
        ),

        // Requirements list
        if (showRequirements && password.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...requirements.map((req) => _buildRequirement(req)),
        ],
      ],
    );
  }

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character type checks
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.fair;
    if (score <= 5) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  List<_Requirement> _getRequirements(String password) {
    return [
      _Requirement(
        label: 'Au moins 8 caractères',
        isMet: password.length >= 8,
      ),
      _Requirement(
        label: 'Une lettre majuscule',
        isMet: RegExp(r'[A-Z]').hasMatch(password),
      ),
      _Requirement(
        label: 'Un chiffre',
        isMet: RegExp(r'[0-9]').hasMatch(password),
      ),
      _Requirement(
        label: 'Un caractère spécial',
        isMet: RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
      ),
    ];
  }

  Widget _buildRequirement(_Requirement requirement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            requirement.isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: requirement.isMet
                ? const Color(0xFF48BB78)
                : Colors.grey[400],
          ),
          const SizedBox(width: 8),
          Text(
            requirement.label,
            style: TextStyle(
              fontSize: 12,
              color: requirement.isMet
                  ? const Color(0xFF48BB78)
                  : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _Requirement {
  final String label;
  final bool isMet;

  _Requirement({
    required this.label,
    required this.isMet,
  });
}

/// A compact password strength indicator with just segments
class CompactPasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const CompactPasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final score = _calculateScore(password);

    return Row(
      children: List.generate(4, (index) {
        final isActive = index < score;
        final color = _getColorForSegment(score, index);

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isActive ? color : Colors.grey[200],
            ),
          ),
        );
      }),
    );
  }

  int _calculateScore(String password) {
    if (password.isEmpty) return 0;

    int score = 0;

    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    return score;
  }

  Color _getColorForSegment(int score, int index) {
    if (score == 1) return const Color(0xFFE53E3E); // Red
    if (score == 2) return const Color(0xFFED8936); // Orange
    if (score == 3) return const Color(0xFFECC94B); // Yellow
    if (score >= 4) return const Color(0xFF48BB78); // Green
    return Colors.grey[200]!;
  }
}
