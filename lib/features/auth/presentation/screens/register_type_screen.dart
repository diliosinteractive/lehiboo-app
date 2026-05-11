import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Account type selection
enum AccountType { customer, business }

/// Screen for choosing account type (Customer or Business)
/// Design matches web version with radio-button style selection
class RegisterTypeScreen extends StatefulWidget {
  const RegisterTypeScreen({super.key});

  @override
  State<RegisterTypeScreen> createState() => _RegisterTypeScreenState();
}

class _RegisterTypeScreenState extends State<RegisterTypeScreen> {
  AccountType? _selectedType = AccountType.customer;

  static const _orangeColor = Color(0xFFFF601F);

  void _handleContinue() {
    if (_selectedType == null) return;

    final route = _selectedType == AccountType.customer
        ? '/register/customer'
        : '/register/business';
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section label
              const Text(
                'TYPE DE COMPTE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _orangeColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // Title
              const Text(
                'Vous \u00eates...',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'S\u00e9lectionnez votre profil pour personnaliser votre exp\u00e9rience',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Customer option - Un particulier
              _AccountTypeCard(
                icon: Icons.person_outline,
                title: 'Un particulier',
                description: 'Je r\u00e9serve des activit\u00e9s pour moi ou mes proches.',
                isSelected: _selectedType == AccountType.customer,
                onTap: () => setState(() => _selectedType = AccountType.customer),
              ),
              const SizedBox(height: 16),

              // Business option - Une organisation (temporarily disabled)
              _AccountTypeCard(
                icon: Icons.business_outlined,
                title: 'Une organisation',
                description: 'Entreprise, association ou collectivit\u00e9 - je r\u00e9serve pour mon \u00e9quipe.',
                isSelected: false,
                onTap: () {},
                disabled: true,
                badge: 'Bient\u00f4t disponible',
              ),

              const Spacer(),

              // Continue button
              SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedType != null ? _handleContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orangeColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Cr\u00e9er mon compte',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'D\u00e9j\u00e0 un compte ? ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
                        color: _orangeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Account type selection card with radio-button style
class _AccountTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  final bool disabled;
  final String? badge;

  static const _orangeColor = Color(0xFFFF601F);

  const _AccountTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
    this.disabled = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final Color titleColor = disabled
        ? Colors.grey[500]!
        : (isSelected ? _orangeColor : const Color(0xFF2D3748));
    final Color descColor = disabled
        ? Colors.grey[400]!
        : (isSelected ? _orangeColor.withValues(alpha: 0.8) : Colors.grey[600]!);
    final Color iconBg = disabled
        ? Colors.grey[100]!
        : (isSelected ? _orangeColor.withValues(alpha: 0.15) : Colors.grey[100]!);
    final Color iconColor = disabled
        ? Colors.grey[400]!
        : (isSelected ? _orangeColor : Colors.grey[600]!);
    final Color borderColor = disabled
        ? Colors.grey[200]!
        : (isSelected ? _orangeColor : Colors.grey[300]!);

    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isSelected && !disabled ? 2 : 1,
          ),
          color: disabled
              ? Colors.grey[50]
              : (isSelected ? _orangeColor.withValues(alpha: 0.06) : Colors.white),
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _orangeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _orangeColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: descColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: disabled
                      ? Colors.grey[300]!
                      : (isSelected ? _orangeColor : Colors.grey[400]!),
                  width: 2,
                ),
              ),
              child: isSelected && !disabled
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: _orangeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
