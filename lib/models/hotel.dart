import 'review.dart';

enum HotelType { budget, guesthouse, boutique, business, resort, heritage, luxury }

enum HotelAmenity {
  wifi,
  pool,
  spa,
  gym,
  restaurant,
  bar,
  roomService,
  airConditioning,
  parking,
  laundry,
  beachAccess,
  mountainView,
}

extension HotelTypeExtension on HotelType {
  String get displayName {
    switch (this) {
      case HotelType.budget:
        return 'Budget';
      case HotelType.guesthouse:
        return 'Guesthouse';
      case HotelType.boutique:
        return 'Boutique';
      case HotelType.business:
        return 'Business';
      case HotelType.resort:
        return 'Resort';
      case HotelType.heritage:
        return 'Heritage';
      case HotelType.luxury:
        return 'Luxury';
    }
  }
}

extension HotelAmenityExtension on HotelAmenity {
  String get displayName {
    switch (this) {
      case HotelAmenity.wifi:
        return 'Free WiFi';
      case HotelAmenity.pool:
        return 'Swimming Pool';
      case HotelAmenity.spa:
        return 'Spa';
      case HotelAmenity.gym:
        return 'Fitness Center';
      case HotelAmenity.restaurant:
        return 'Restaurant';
      case HotelAmenity.bar:
        return 'Bar';
      case HotelAmenity.roomService:
        return 'Room Service';
      case HotelAmenity.airConditioning:
        return 'Air Conditioning';
      case HotelAmenity.parking:
        return 'Free Parking';
      case HotelAmenity.laundry:
        return 'Laundry';
      case HotelAmenity.beachAccess:
        return 'Beach Access';
      case HotelAmenity.mountainView:
        return 'Mountain View';
    }
  }

  String get icon {
    switch (this) {
      case HotelAmenity.wifi:
        return 'wifi';
      case HotelAmenity.pool:
        return 'pool';
      case HotelAmenity.spa:
        return 'spa';
      case HotelAmenity.gym:
        return 'fitness_center';
      case HotelAmenity.restaurant:
        return 'restaurant';
      case HotelAmenity.bar:
        return 'local_bar';
      case HotelAmenity.roomService:
        return 'room_service';
      case HotelAmenity.airConditioning:
        return 'ac_unit';
      case HotelAmenity.parking:
        return 'local_parking';
      case HotelAmenity.laundry:
        return 'local_laundry_service';
      case HotelAmenity.beachAccess:
        return 'beach_access';
      case HotelAmenity.mountainView:
        return 'landscape';
    }
  }
}

class Hotel {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final HotelType type;
  final int starRating;
  final double rating;
  final int reviewCount;
  final String pricePerNight;
  final List<HotelAmenity> amenities;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final bool isFeatured;
  final String description;
  final String checkIn;
  final String checkOut;
  final List<Review> reviews;

  const Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.type,
    required this.starRating,
    required this.rating,
    this.reviewCount = 0,
    required this.pricePerNight,
    this.amenities = const [],
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.isFeatured = false,
    required this.description,
    this.checkIn = '12:00 PM',
    this.checkOut = '11:00 AM',
    this.reviews = const [],
  });
}
