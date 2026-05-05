import '../../../../domain/entities/user.dart';
import '../models/auth_response_dto.dart';

class AuthMapper {
  static HbUser toUser(UserDto dto) {
    final role = _parseRole(dto.role);
    return HbUser(
      id: dto.id.toString(),
      email: dto.email,
      // Fallback chain: displayName (login) -> name (register) -> email
      displayName: dto.displayName ?? dto.name ?? dto.email,
      firstName: dto.firstName,
      lastName: dto.lastName,
      phone: dto.phone,
      avatarUrl: dto.avatarUrl,
      city: dto.city,
      bio: dto.bio,
      birthDate: dto.birthDate != null ? DateTime.tryParse(dto.birthDate!) : null,
      membershipCity: dto.membershipCity,
      role: role,
      registeredAt: dto.registeredAt != null ? DateTime.tryParse(dto.registeredAt!) : null,
      isVerified: dto.isVerified,
      newsletter: dto.newsletter,
      pushNotificationsEnabled: dto.pushNotificationsEnabled,
      capabilities: dto.capabilities != null
          ? UserCapabilities(
              canBook: dto.capabilities!.canBook,
              canScanTickets: dto.capabilities!.canScanTickets,
              canManageEvents: dto.capabilities!.canManageEvents,
            )
          : _capabilitiesFromRole(role),
    );
  }

  static UserRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      // Laravel v2 roles
      case 'vendor':
      case 'el_event_manager':
      case 'partner':
        return UserRole.partner;
      case 'administrator':
      case 'admin':
        return UserRole.admin;
      case 'customer':
      case 'subscriber':
      default:
        return UserRole.subscriber;
    }
  }

  /// Synthesizes capabilities from the auth role when the backend's auth
  /// response doesn't include the `capabilities` block (current state of
  /// `/auth/login` as of 2026-05-05). When the backend ships explicit
  /// capabilities, the DTO branch above takes precedence.
  ///
  /// The mapping mirrors what the backend would return for each role:
  /// vendors and admins can scan tickets and manage events; subscribers
  /// can only book.
  static UserCapabilities _capabilitiesFromRole(UserRole role) {
    switch (role) {
      case UserRole.partner:
      case UserRole.admin:
        return const UserCapabilities(
          canBook: true,
          canScanTickets: true,
          canManageEvents: true,
        );
      case UserRole.subscriber:
        return const UserCapabilities();
    }
  }
}
