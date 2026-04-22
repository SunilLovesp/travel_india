import 'dart:math';
import 'review.dart';

class Attraction {
  final String name;
  final String nameHindi;
  final String description;
  final String emoji;
  final String entryFee;
  final String timings;
  final String type;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final List<String> activities;
  final List<String> famousFoods;
  final List<String> vehicleRentals;

  const Attraction({
    required this.name,
    required this.nameHindi,
    required this.description,
    required this.emoji,
    this.entryFee = 'Free',
    this.timings = 'Open all day',
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    this.activities = const [],
    this.famousFoods = const [],
    this.vehicleRentals = const [],
  });
}

enum PlaceCategory {
  temple,
  beach,
  hillStation,
  city,
  fort,
  wildlife,
  waterfall,
  lake,
  adventure,
  museum,
  market,
  cave,
  valley,
  desert,
}

enum Season { winter, summer, monsoon, autumn }

extension PlaceCategoryExtension on PlaceCategory {
  String get displayName {
    switch (this) {
      case PlaceCategory.temple:
        return 'Temples';
      case PlaceCategory.beach:
        return 'Beaches';
      case PlaceCategory.hillStation:
        return 'Hill Stations';
      case PlaceCategory.city:
        return 'Cities';
      case PlaceCategory.fort:
        return 'Forts & Heritage';
      case PlaceCategory.wildlife:
        return 'Wildlife';
      case PlaceCategory.waterfall:
        return 'Waterfalls';
      case PlaceCategory.lake:
        return 'Lakes';
      case PlaceCategory.adventure:
        return 'Adventure';
      case PlaceCategory.museum:
        return 'Museums';
      case PlaceCategory.market:
        return 'Markets & Bazaars';
      case PlaceCategory.cave:
        return 'Caves';
      case PlaceCategory.valley:
        return 'Valleys';
      case PlaceCategory.desert:
        return 'Deserts';
    }
  }

  String get displayNameHindi {
    switch (this) {
      case PlaceCategory.temple:
        return 'मंदिर';
      case PlaceCategory.beach:
        return 'समुद्र तट';
      case PlaceCategory.hillStation:
        return 'हिल स्टेशन';
      case PlaceCategory.city:
        return 'शहर';
      case PlaceCategory.fort:
        return 'किले';
      case PlaceCategory.wildlife:
        return 'वन्यजीव';
      case PlaceCategory.waterfall:
        return 'झरने';
      case PlaceCategory.lake:
        return 'झीलें';
      case PlaceCategory.adventure:
        return 'एडवेंचर';
      case PlaceCategory.museum:
        return 'संग्रहालय';
      case PlaceCategory.market:
        return 'बाज़ार';
      case PlaceCategory.cave:
        return 'गुफाएं';
      case PlaceCategory.valley:
        return 'घाटियाँ';
      case PlaceCategory.desert:
        return 'रेगिस्तान';
    }
  }

  String get emoji {
    switch (this) {
      case PlaceCategory.temple:
        return '🛕';
      case PlaceCategory.beach:
        return '🏖️';
      case PlaceCategory.hillStation:
        return '⛰️';
      case PlaceCategory.city:
        return '🏙️';
      case PlaceCategory.fort:
        return '🏯';
      case PlaceCategory.wildlife:
        return '🐅';
      case PlaceCategory.waterfall:
        return '💦';
      case PlaceCategory.lake:
        return '🏞️';
      case PlaceCategory.adventure:
        return '🧗';
      case PlaceCategory.museum:
        return '🏛️';
      case PlaceCategory.market:
        return '🛍️';
      case PlaceCategory.cave:
        return '🕳️';
      case PlaceCategory.valley:
        return '🏔️';
      case PlaceCategory.desert:
        return '🏜️';
    }
  }
}

extension SeasonExtension on Season {
  String get displayName {
    switch (this) {
      case Season.winter:
        return 'Winter';
      case Season.summer:
        return 'Summer';
      case Season.monsoon:
        return 'Monsoon';
      case Season.autumn:
        return 'Autumn';
    }
  }

  String get displayNameHindi {
    switch (this) {
      case Season.winter:
        return 'सर्दी';
      case Season.summer:
        return 'गर्मी';
      case Season.monsoon:
        return 'बारिश';
      case Season.autumn:
        return 'शरद';
    }
  }

  String get months {
    switch (this) {
      case Season.winter:
        return 'Nov – Feb';
      case Season.summer:
        return 'Mar – Jun';
      case Season.monsoon:
        return 'Jul – Sep';
      case Season.autumn:
        return 'Oct';
    }
  }

  String get emoji {
    switch (this) {
      case Season.winter:
        return '❄️';
      case Season.summer:
        return '☀️';
      case Season.monsoon:
        return '🌧️';
      case Season.autumn:
        return '🍂';
    }
  }

  static Season currentSeason() {
    final month = DateTime.now().month;
    if (month >= 11 || month <= 2) return Season.winter;
    if (month >= 3 && month <= 6) return Season.summer;
    if (month >= 7 && month <= 9) return Season.monsoon;
    return Season.autumn;
  }
}

class Place {
  final String id;
  final String name;
  final String nameHindi;
  final String state;
  final String description;
  final String shortDescription;
  final PlaceCategory category;
  final List<Season> bestSeasons;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final double rating;
  final String entryFee;
  final String timings;
  final bool isFeatured;
  final List<String> tags;
  final String nearestCity;
  final String howToReach;
  final List<Attraction> attractions;
  final List<Review> reviews;
  final List<String> photos;

  const Place({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.state,
    required this.description,
    required this.shortDescription,
    required this.category,
    required this.bestSeasons,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.rating,
    required this.entryFee,
    required this.timings,
    this.isFeatured = false,
    required this.tags,
    required this.nearestCity,
    required this.howToReach,
    this.attractions = const [],
    this.reviews = const [],
    this.photos = const [],
  });

  double distanceFrom(double userLat, double userLng) {
    const earthRadius = 6371.0;
    final dLat = _toRad(latitude - userLat);
    final dLng = _toRad(longitude - userLng);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(userLat)) *
            cos(_toRad(latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRad(double deg) => deg * pi / 180;
}
