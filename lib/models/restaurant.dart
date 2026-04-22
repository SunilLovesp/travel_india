import 'review.dart';

enum CuisineType {
  northIndian,
  southIndian,
  seafood,
  chinese,
  continental,
  streetFood,
  mughlai,
  rajasthani,
  gujarati,
  bengali,
  kerala,
  goan,
  italian,
  cafe,
  bakery,
  fastFood,
}

enum PriceRange { budget, moderate, expensive, luxury }

extension CuisineTypeExtension on CuisineType {
  String get displayName {
    switch (this) {
      case CuisineType.northIndian:
        return 'North Indian';
      case CuisineType.southIndian:
        return 'South Indian';
      case CuisineType.seafood:
        return 'Seafood';
      case CuisineType.chinese:
        return 'Chinese';
      case CuisineType.continental:
        return 'Continental';
      case CuisineType.streetFood:
        return 'Street Food';
      case CuisineType.mughlai:
        return 'Mughlai';
      case CuisineType.rajasthani:
        return 'Rajasthani';
      case CuisineType.gujarati:
        return 'Gujarati';
      case CuisineType.bengali:
        return 'Bengali';
      case CuisineType.kerala:
        return 'Kerala';
      case CuisineType.goan:
        return 'Goan';
      case CuisineType.italian:
        return 'Italian';
      case CuisineType.cafe:
        return 'Cafe';
      case CuisineType.bakery:
        return 'Bakery';
      case CuisineType.fastFood:
        return 'Fast Food';
    }
  }
}

extension PriceRangeExtension on PriceRange {
  String get symbol {
    switch (this) {
      case PriceRange.budget:
        return '₹';
      case PriceRange.moderate:
        return '₹₹';
      case PriceRange.expensive:
        return '₹₹₹';
      case PriceRange.luxury:
        return '₹₹₹₹';
    }
  }

  String get label {
    switch (this) {
      case PriceRange.budget:
        return 'Budget';
      case PriceRange.moderate:
        return 'Moderate';
      case PriceRange.expensive:
        return 'Expensive';
      case PriceRange.luxury:
        return 'Luxury';
    }
  }
}

class Restaurant {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final List<CuisineType> cuisines;
  final PriceRange priceRange;
  final double rating;
  final int reviewCount;
  final String timings;
  final String phone;
  final List<String> mustTry;
  final List<String> features;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final bool isFeatured;
  final List<Review> reviews;

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.cuisines,
    required this.priceRange,
    required this.rating,
    this.reviewCount = 0,
    required this.timings,
    this.phone = '',
    this.mustTry = const [],
    this.features = const [],
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.isFeatured = false,
    this.reviews = const [],
  });
}
