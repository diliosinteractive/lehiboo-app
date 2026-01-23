import '../../../../domain/entities/user.dart';
import '../models/auth_response_dto.dart';

class AuthMapper {
  static HbUser toUser(UserDto dto) {
    return HbUser(
      id: dto.id.toString(),
      email: dto.email,
      displayName: dto.displayName,
      firstName: dto.firstName,
      lastName: dto.lastName,
      phone: dto.phone,
      avatarUrl: dto.avatarUrl,
      city: dto.city,
      bio: dto.bio,
      birthDate: dto.birthDate != null ? DateTime.tryParse(dto.birthDate!) : null,
      role: _parseRole(dto.role),
      registeredAt: dto.registeredAt != null ? DateTime.tryParse(dto.registeredAt!) : null,
      isVerified: dto.isVerified,
      capabilities: dto.capabilities != null
          ? UserCapabilities(
              canBook: dto.capabilities!.canBook,
              canScanTickets: dto.capabilities!.canScanTickets,
              canManageEvents: dto.capabilities!.canManageEvents,
            )
          : const UserCapabilities(),
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
}
