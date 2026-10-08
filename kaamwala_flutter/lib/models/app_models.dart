class Locality {
  final String id;
  final String name;
  final String area;
  final String city;
  final String state;
  final bool isPopular;

  const Locality({
    required this.id,
    required this.name,
    required this.area,
    required this.city,
    required this.state,
    this.isPopular = false,
  });

  String get fullAddress => '$name, $city ($area)';
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
  final String badge;
  final String desc;
  final int startingPrice;
  final List<SubService> subServices;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.nameHi,
    required this.icon,
    required this.badge,
    required this.desc,
    required this.startingPrice,
    required this.subServices,
  });
}

class WorkerProfile {
  final String id;
  final String name;
  final String category;
  final List<String> skills;
  final String bio;
  final int experienceYears;
  final double rating;
  final int totalReviews;
  final int jobsCompleted;
  final int onTimeRate;
  final String responseTime;
  final int visitFee;
  final bool isIdentityVerified;
  final bool isSkillVerified;
  final bool isTopRated;
  final bool isFastResponder;
  final String photoUrl;
  final String serviceAreas;

  const WorkerProfile({
    required this.id,
    required this.name,
    required this.category,
    required this.skills,
    required this.bio,
    required this.experienceYears,
    required this.rating,
    required this.totalReviews,
    required this.jobsCompleted,
    required this.onTimeRate,
    required this.responseTime,
    required this.visitFee,
    required this.isIdentityVerified,
    required this.isSkillVerified,
    required this.isTopRated,
    required this.isFastResponder,
    required this.photoUrl,
    required this.serviceAreas,
  });
}

class Quote {
  final String id;
  final String workerId;
  final String workerName;
  final double workerRating;
  final int workerJobs;
  final String workerPhoto;
  final int visitFee;
  final int estimateMin;
  final int estimateMax;
  final bool partsExtra;
  final String message;
  final String arrivalTime;

  const Quote({
    required this.id,
    required this.workerId,
    required this.workerName,
    required this.workerRating,
    required this.workerJobs,
    required this.workerPhoto,
    required this.visitFee,
    required this.estimateMin,
    required this.estimateMax,
    this.partsExtra = true,
    required this.message,
    required this.arrivalTime,
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
  Quote? selectedWorker;
  List<Quote> quotes;

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
    this.selectedWorker,
    required this.quotes,
  });
}
