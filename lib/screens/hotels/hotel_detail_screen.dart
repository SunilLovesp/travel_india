import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../models/hotel.dart';
import '../../models/review.dart';
import '../../services/maps_service.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;
  const HotelDetailScreen({super.key, required this.hotel});

  IconData _amenityIcon(HotelAmenity amenity) {
    switch (amenity) {
      case HotelAmenity.wifi:
        return Icons.wifi;
      case HotelAmenity.pool:
        return Icons.pool;
      case HotelAmenity.spa:
        return Icons.spa;
      case HotelAmenity.gym:
        return Icons.fitness_center;
      case HotelAmenity.restaurant:
        return Icons.restaurant;
      case HotelAmenity.bar:
        return Icons.local_bar;
      case HotelAmenity.roomService:
        return Icons.room_service;
      case HotelAmenity.airConditioning:
        return Icons.ac_unit;
      case HotelAmenity.parking:
        return Icons.local_parking;
      case HotelAmenity.laundry:
        return Icons.local_laundry_service;
      case HotelAmenity.beachAccess:
        return Icons.beach_access;
      case HotelAmenity.mountainView:
        return Icons.landscape;
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = hotel;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero image + app bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.navy,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 16),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: h.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppColors.navy.withOpacity(0.3),
                      child: const Center(
                        child: Icon(Icons.hotel,
                            size: 70, color: Colors.white54),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.navy.withOpacity(0.3),
                      child: const Center(
                        child: Icon(Icons.hotel,
                            size: 70, color: Colors.white54),
                      ),
                    ),
                  ),
                  // Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.75),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type badge
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(h.type.displayName,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Text(
                          h.name,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.location_on,
                              color: Colors.white70, size: 13),
                          const SizedBox(width: 3),
                          Text('${h.city}, ${h.state}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white70, fontSize: 12)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick stats
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      // Rating bubble
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              h.rating.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < h.starRating
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                size: 15,
                                color: i < h.starRating
                                    ? AppColors.ratingYellow
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                          Text(
                            '${h.reviewCount} reviews',
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            h.pricePerNight,
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navy),
                          ),
                          Text(
                            'per night',
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: AppColors.textHint),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                _SectionCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionTitle(
                        icon: Icons.info_outline,
                        title: 'About',
                        color: AppColors.navy,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        h.description,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.65),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Check-in / check-out
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.login,
                          label: 'Check-in',
                          value: h.checkIn,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.logout,
                          label: 'Check-out',
                          value: h.checkOut,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Address
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _InfoTile(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: h.address,
                  ),
                ),

                const SizedBox(height: 12),

                // Amenities
                if (h.amenities.isNotEmpty) ...[
                  _SectionCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionTitle(
                          icon: Icons.local_offer_outlined,
                          title: 'Amenities',
                          color: AppColors.navy,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: h.amenities
                              .map((a) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withOpacity(0.08),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      border: Border.all(
                                          color: AppColors.primary
                                              .withOpacity(0.25)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(_amenityIcon(a),
                                            size: 13,
                                            color: AppColors.primary),
                                        const SizedBox(width: 5),
                                        Text(
                                          a.displayName,
                                          style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: AppColors.primary,
                                              fontWeight:
                                                  FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Map / Directions buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => MapsService.openOnMap(
                              h.latitude, h.longitude, h.name),
                          icon: const Icon(Icons.map_outlined, size: 18),
                          label: Text('View on Map',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => MapsService.openDirections(
                              h.latitude, h.longitude, h.name),
                          icon: const Icon(Icons.directions_car, size: 18),
                          label: Text('Get Directions',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Reviews
                if (h.reviews.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.reviews_outlined,
                              color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Traveller Reviews',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: h.reviews
                          .map((rev) => _ReviewCard(review: rev))
                          .toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 13, color: AppColors.navy),
            const SizedBox(width: 5),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _SectionCard({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: padding,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  const _SectionTitle(
      {required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.navy.withOpacity(0.12),
                child: Text(
                  review.reviewerName.isNotEmpty
                      ? review.reviewerName[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.reviewerName,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy)),
                    Text(review.date,
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.white, size: 11),
                    const SizedBox(width: 2),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.55),
          ),
          if (review.helpfulCount > 0) ...[
            const SizedBox(height: 6),
            Text(
              '${review.helpfulCount} people found this helpful',
              style: GoogleFonts.poppins(
                  fontSize: 10, color: AppColors.textHint),
            ),
          ],
        ],
      ),
    );
  }
}
