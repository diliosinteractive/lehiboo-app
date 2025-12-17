
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hibons_wallet.freezed.dart';
part 'hibons_wallet.g.dart';

@freezed
class HibonsWallet with _$HibonsWallet {
  const factory HibonsWallet({
    required String userId,
    @Default(0) int balance,
    @Default(0) int xp,
    @Default(1) int level,
    @Default('Hibou Curieux') String rank,
    @Default(0) int currentStreak,
    @Default(false) bool streakShieldActive,
    DateTime? lastActionDate,
  }) = _HibonsWallet;

  factory HibonsWallet.fromJson(Map<String, dynamic> json) =>
      _$HibonsWalletFromJson(json);
}
