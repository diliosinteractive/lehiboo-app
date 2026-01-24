import 'package:flutter/material.dart';

/// Step configuration with icon and label
class StepConfig {
  final IconData icon;
  final String label;

  const StepConfig({required this.icon, required this.label});
}

/// Default steps for business registration
const List<StepConfig> businessRegisterSteps = [
  StepConfig(icon: Icons.person_outline, label: 'Infos'),
  StepConfig(icon: Icons.mail_outline, label: 'Vérif.'),
  StepConfig(icon: Icons.business_outlined, label: 'Entreprise'),
  StepConfig(icon: Icons.people_outline, label: 'Usage'),
  StepConfig(icon: Icons.description_outlined, label: 'Termes'),
];

/// A step indicator widget that displays progress through multi-step registration
/// Matches the desktop design with icons and pill-shaped active step
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;
  final List<StepConfig>? steps;
  final Color activeColor;
  final Color inactiveColor;
  final Color completedColor;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.steps,
    this.activeColor = const Color(0xFFFF601F),
    this.inactiveColor = const Color(0xFFE8E8E8),
    this.completedColor = const Color(0xFFFF601F),
  });

  List<StepConfig> get _steps => steps ?? businessRegisterSteps;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              return _buildStep(stepIndex);
            } else {
              final lineIndex = index ~/ 2;
              return _buildLine(lineIndex);
            }
          }),
        );
      },
    );
  }

  Widget _buildStep(int stepIndex) {
    final isActive = stepIndex == currentStep;
    final isCompleted = stepIndex < currentStep;
    final config = stepIndex < _steps.length ? _steps[stepIndex] : null;
    final label = stepLabels != null && stepIndex < stepLabels!.length
        ? stepLabels![stepIndex]
        : config?.label ?? '';

    if (isActive) {
      // Active step: pill shape with icon and label
      return Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: activeColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              config?.icon ?? Icons.circle,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      // Inactive or completed step: circle with icon
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? activeColor.withValues(alpha: 0.15) : inactiveColor,
        ),
        child: Center(
          child: Icon(
            isCompleted ? Icons.check : (config?.icon ?? Icons.circle),
            color: isCompleted ? activeColor : Colors.grey[500],
            size: 18,
          ),
        ),
      );
    }
  }

  Widget _buildLine(int lineIndex) {
    final isCompleted = lineIndex < currentStep;

    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isCompleted ? activeColor.withValues(alpha: 0.5) : Colors.grey[300],
    );
  }
}

/// Alternative step indicator with numbers (mobile-first design)
class NumberedStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;
  final Color activeColor;
  final Color inactiveColor;
  final Color completedColor;
  final double dotSize;

  const NumberedStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.activeColor = const Color(0xFFFF601F),
    this.inactiveColor = const Color(0xFFE2E8F0),
    this.completedColor = const Color(0xFF48BB78),
    this.dotSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress indicator row
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              return _buildDot(stepIndex);
            } else {
              final lineIndex = index ~/ 2;
              return _buildLine(lineIndex);
            }
          }),
        ),
        // Step labels
        if (stepLabels != null && stepLabels!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              final isActive = index == currentStep;
              final isCompleted = index < currentStep;
              return Expanded(
                child: Text(
                  index < stepLabels!.length ? stepLabels![index] : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isCompleted
                        ? completedColor
                        : isActive
                            ? activeColor
                            : Colors.grey[400],
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildDot(int stepIndex) {
    final isActive = stepIndex == currentStep;
    final isCompleted = stepIndex < currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? completedColor
            : isActive
                ? activeColor
                : inactiveColor,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              )
            : Text(
                '${stepIndex + 1}',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  Widget _buildLine(int lineIndex) {
    final isCompleted = lineIndex < currentStep;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: isCompleted ? completedColor : inactiveColor,
      ),
    );
  }
}

/// A compact step indicator with just dots
class CompactStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color activeColor;
  final Color inactiveColor;

  const CompactStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor = const Color(0xFFFF601F),
    this.inactiveColor = const Color(0xFFE2E8F0),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isCompleted || isActive ? activeColor : inactiveColor,
            ),
          ),
        );
      }),
    );
  }
}
