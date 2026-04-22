import 'review.dart';

enum ActivityCategory {
  trekking,
  rafting,
  paragliding,
  scubaDiving,
  camping,
  cycling,
  culturalTour,
  foodTour,
  wildlifeSafari,
  boatRide,
  skiingSnow,
  yogaMeditation,
  photography,
  cooking,
  shopping,
  nightLife,
}

class Activity {
  final String id;
  final String name;
  final String description;
  final ActivityCategory category;
  final String city;
  final String state;
  final double rating;
  final int reviewCount;
  final String duration;
  final String pricePerPerson;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final List<String> includes;
  final List<String> highlights;
  final bool isFeatured;
  final String bookingInfo;
  final List<Review> reviews;

  const Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.city,
    required this.state,
    required this.rating,
    this.reviewCount = 0,
    required this.duration,
    required this.pricePerPerson,
    required this.imageUrl,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.includes = const [],
    this.highlights = const [],
    this.isFeatured = false,
    this.bookingInfo = '',
    this.reviews = const [],
  });
}

extension ActivityCategoryExt on ActivityCategory {
  String get displayName {
    switch (this) {
      case ActivityCategory.trekking:
        return 'Trekking';
      case ActivityCategory.rafting:
        return 'River Rafting';
      case ActivityCategory.paragliding:
        return 'Paragliding';
      case ActivityCategory.scubaDiving:
        return 'Scuba Diving';
      case ActivityCategory.camping:
        return 'Camping';
      case ActivityCategory.cycling:
        return 'Cycling';
      case ActivityCategory.culturalTour:
        return 'Cultural Tours';
      case ActivityCategory.foodTour:
        return 'Food Tours';
      case ActivityCategory.wildlifeSafari:
        return 'Wildlife Safari';
      case ActivityCategory.boatRide:
        return 'Boat Rides';
      case ActivityCategory.skiingSnow:
        return 'Skiing';
      case ActivityCategory.yogaMeditation:
        return 'Yoga & Meditation';
      case ActivityCategory.photography:
        return 'Photography Tours';
      case ActivityCategory.cooking:
        return 'Cooking Classes';
      case ActivityCategory.shopping:
        return 'Shopping Tours';
      case ActivityCategory.nightLife:
        return 'Nightlife';
    }
  }

  String get emoji {
    switch (this) {
      case ActivityCategory.trekking:
        return '🥾';
      case ActivityCategory.rafting:
        return '🚣';
      case ActivityCategory.paragliding:
        return '🪂';
      case ActivityCategory.scubaDiving:
        return '🤿';
      case ActivityCategory.camping:
        return '⛺';
      case ActivityCategory.cycling:
        return '🚴';
      case ActivityCategory.culturalTour:
        return '🎭';
      case ActivityCategory.foodTour:
        return '🍛';
      case ActivityCategory.wildlifeSafari:
        return '🦁';
      case ActivityCategory.boatRide:
        return '⛵';
      case ActivityCategory.skiingSnow:
        return '⛷️';
      case ActivityCategory.yogaMeditation:
        return '🧘';
      case ActivityCategory.photography:
        return '📸';
      case ActivityCategory.cooking:
        return '👨‍🍳';
      case ActivityCategory.shopping:
        return '🛒';
      case ActivityCategory.nightLife:
        return '🌙';
    }
  }
}
