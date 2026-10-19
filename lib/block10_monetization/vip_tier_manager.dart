enum UserVipTier { normal, vip, svip, executive }

class VipTierManager {
  // Get tier display name
  static String getTierName(UserVipTier tier) {
    switch (tier) {
      case UserVipTier.vip:
        return 'VIP Member';
      case UserVipTier.svip:
        return 'Super SVIP';
      case UserVipTier.executive:
        return 'Executive Elite';
      case UserVipTier.normal:
      default:
        return 'Standard User';
    }
  }

  // Check if user has entry animation privileges
  static bool hasSpecialEntry(UserVipTier tier) {
    return tier == UserVipTier.svip || tier == UserVipTier.executive;
  }

  // Get entry broadcast announcement text
  static String? getEntryAnnouncement(String userName, UserVipTier tier) {
    if (tier == UserVipTier.executive) {
      return '🚀 Executive Elite $userName entered the room with royal aura!';
    } else if (tier == UserVipTier.svip) {
      return '✨ SVIP Member $userName entered the room with grand sparkles!';
    }
    return null; // Normal or VIP users do not trigger full room alerts
  }
}

