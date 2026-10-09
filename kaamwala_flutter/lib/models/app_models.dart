class Locality {
  final String id;
  final String name;
  final String area;
  final String city;
  final String state;
  final String pincode;
  final double lat;
  final double lng;
  final bool isPopular;

  const Locality({
    required this.id,
    required this.name,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
    required this.lat,
    required this.lng,
    this.isPopular = false,
  });

  String get fullAddress => '$name, $area, $city • $pincode';
}

class SubService {
  final String id;
  final String title;
  final String titleHi;
  final int price;
  final String duration;

  const SubService({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.price,
    required this.duration,
  });
}

class ServiceCategory {
  final String id;
  final String name;
  final String nameHi;
  final String icon;
  final String bookingCount;
  final String desc;
  final int startingPrice;
  final List<SubService> subServices;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.nameHi,
    required this.icon,
    required this.bookingCount,
    required this.desc,
    required this.startingPrice,
    required this.subServices,
  });
}

class WorkerProfile {
  final String id;
  final String name;
  final String avatar;
  final String category;
  final List<String> skills;
  final String bio;
  final String experienceYears;
  final double rating;
  final int totalReviews;
  final int jobsCompleted;
  final double onTimeRate;
  final double completionRate;
  final String responseTime;
  final int visitFee;
  final bool isIdentityVerified;
  final bool isSkillVerified;
  final bool isTopRated;
  final bool isFastResponder;
  final String distance;
  final String serviceAreas;

  const WorkerProfile({
    required this.id,
    required this.name,
    required this.avatar,
    required this.category,
    required this.skills,
    required this.bio,
    required this.experienceYears,
    required this.rating,
    required this.totalReviews,
    required this.jobsCompleted,
    required this.onTimeRate,
    required this.completionRate,
    required this.responseTime,
    required this.visitFee,
    required this.isIdentityVerified,
    required this.isSkillVerified,
    required this.isTopRated,
    required this.isFastResponder,
    required this.distance,
    required this.serviceAreas,
  });
}

class CustomerJob {
  final String id;
  final String category;
  final String serviceName;
  final String description;
  final String address;
  final String date;
  final String time;
  String status;
  final int visitFee;
  int estimatedAmount;
  int finalAmount;
  WorkerProfile? assignedWorker;
  final List<String> mediaUrls;
  final String? arrivalEta;
  bool isInspectionApproved;
  bool isCompletedConfirmed;

  CustomerJob({
    required this.id,
    required this.category,
    required this.serviceName,
    required this.description,
    required this.address,
    required this.date,
    required this.time,
    required this.status,
    required this.visitFee,
    required this.estimatedAmount,
    required this.finalAmount,
    this.assignedWorker,
    this.mediaUrls = const [],
    this.arrivalEta,
    this.isInspectionApproved = false,
    this.isCompletedConfirmed = false,
  });
}

class WalletTransaction {
  final String id;
  final String type; // 'CREDIT' or 'DEBIT'
  final double amount;
  final String title;
  final String date;
  final String status;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.title,
    required this.date,
    required this.status,
  });
}

class ReferralInfo {
  final String code;
  final double rewardPerReferral;
  final double friendDiscount;
  final int totalReferrals;
  final double totalEarned;

  const ReferralInfo({
    required this.code,
    required this.rewardPerReferral,
    required this.friendDiscount,
    required this.totalReferrals,
    required this.totalEarned,
  });
}

class AppUser {
  final String id;
  String name;
  String email;
  final String phone;
  String avatar;
  final String authProvider;
  final bool isAadhaarVerified;
  final int profileCompletion; // 0 to 100

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.authProvider,
    this.isAadhaarVerified = true,
    this.profileCompletion = 40,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isUnread = true,
  });
}
