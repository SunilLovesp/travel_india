import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/place.dart';
import '../../models/restaurant.dart';
import '../../models/hotel.dart';
import '../../providers/favorites_provider.dart';
import '../../services/maps_service.dart';
import '../../widgets/place/place_card.dart';
import '../../core/theme.dart';
import '../../data/restaurants_data.dart';
import '../../data/hotels_data.dart';
import '../../data/activities_data.dart';
import '../../models/activity.dart';
import '../../models/review.dart';
import '../restaurants/restaurants_screen.dart';
import '../restaurants/restaurant_detail_screen.dart';
import '../hotels/hotels_screen.dart';
import '../hotels/hotel_detail_screen.dart';
import '../activities/activities_screen.dart';
import '../activities/activity_detail_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: _PlaceDetailBody(place: place),
    );
  }
}

class _PlaceDetailBody extends StatelessWidget {
  final Place place;
  const _PlaceDetailBody({required this.place});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesProvider>();
    final isFav = favs.isFavorite(place.id);
    final catColor = categoryColor(place.category);
    final isTravChoice = place.rating >= 4.5 && place.isFeatured;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: catColor,
            forceElevated: innerBoxIsScrolled,
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
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFav ? AppColors.danger : Colors.white,
                    size: 18,
                  ),
                ),
                onPressed: () => favs.toggle(place.id),
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: place.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: catColor.withOpacity(0.3),
                      child: Center(
                        child: Text(place.category.emoji,
                            style: const TextStyle(fontSize: 70)),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: catColor.withOpacity(0.3),
                      child: Center(
                        child: Text(place.category.emoji,
                            style: const TextStyle(fontSize: 70)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.65),
                        ],
                        stops: const [0.5, 1.0],
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
                        if (isTravChoice)
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.workspace_premium,
                                    color: Colors.white, size: 12),
                                const SizedBox(width: 4),
                                Text("Travellers' Choice",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        Text(
                          place.name,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          place.nameHindi,
                          style: GoogleFonts.poppins(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w700),
              unselectedLabelStyle:
                  GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Photos'),
                Tab(text: 'Reviews'),
                Tab(text: 'Nearby'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          children: [
            _OverviewTab(place: place),
            _PhotosTab(place: place),
            _ReviewsTab(place: place),
            _NearbyTab(place: place),
          ],
        ),
      ),
    );
  }
}

// ── TAB 1: Overview ────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final Place place;
  const _OverviewTab({required this.place});

  @override
  Widget build(BuildContext context) {
    final catColor = categoryColor(place.category);
    final isTravChoice = place.rating >= 4.5 && place.isFeatured;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick info bar
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: AppColors.primary, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${place.nearestCity}, ${place.state}',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        place.rating.toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Quick facts: timings + entry fee
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    icon: Icons.access_time_rounded,
                    label: 'Timings',
                    value: place.timings,
                    color: catColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoTile(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Entry Fee',
                    value: place.entryFee,
                    color: catColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Travellers' Choice / UNESCO / Best Season quick facts row
          if (isTravChoice || place.rating >= 4.0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (isTravChoice)
                    const _QuickFactChip(
                      icon: Icons.workspace_premium,
                      label: "Travellers' Choice",
                      color: AppColors.primary,
                    ),
                  if (place.entryFee == 'Free')
                    const _QuickFactChip(
                      icon: Icons.money_off_outlined,
                      label: 'Free Entry',
                      color: Color(0xFF2E7D32),
                    ),
                  if (place.rating >= 4.5)
                    const _QuickFactChip(
                      icon: Icons.verified,
                      label: 'Top Rated',
                      color: AppColors.navy,
                    ),
                  if (place.category == PlaceCategory.temple ||
                      place.category == PlaceCategory.fort)
                    const _QuickFactChip(
                      icon: Icons.account_balance_outlined,
                      label: 'Heritage Site',
                      color: Color(0xFF795548),
                    ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Rating breakdown
          _RatingBreakdown(rating: place.rating),

          const SizedBox(height: 12),

          // Best For badges
          _BestForSection(place: place),

          const SizedBox(height: 12),

          // Best Time to Visit
          _Section(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(
                    icon: Icons.wb_sunny_outlined,
                    title: 'Best Time to Visit',
                    color: catColor),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: place.bestSeasons
                      .map((s) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: seasonColor(s).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: seasonColor(s).withOpacity(0.3)),
                            ),
                            child: Text(
                              '${s.emoji}  ${s.displayName} • ${s.months}',
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: seasonColor(s),
                                  fontWeight: FontWeight.w600),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // About
          _Section(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(
                    icon: Icons.info_outline, title: 'About', color: catColor),
                const SizedBox(height: 8),
                Text(
                  place.description,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.65),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Traveller Tips
          _TravellerTips(catColor: catColor),

          const SizedBox(height: 12),

          // How to reach
          _Section(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(
                    icon: Icons.directions_outlined,
                    title: 'How to Reach',
                    color: catColor),
                const SizedBox(height: 8),
                Text(
                  place.howToReach,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.65),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Attractions
          if (place.attractions.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: catColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.place, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Places to Visit Here',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: catColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${place.attractions.length} spots',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: catColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: place.attractions
                    .map((a) => _AttractionCard(attraction: a, color: catColor))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Tags
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: place.tags
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          '#$t',
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500),
                        ),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Map / Directions buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => MapsService.openOnMap(
                        place.latitude, place.longitude, place.name),
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: Text('View on Map',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => MapsService.openDirections(
                        place.latitude, place.longitude, place.name),
                    icon: const Icon(Icons.directions_car, size: 18),
                    label: Text('Get Directions',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── TAB 2: Photos ──────────────────────────────────────────────────────────────
class _PhotosTab extends StatelessWidget {
  final Place place;
  const _PhotosTab({required this.place});

  List<String> get _allPhotos {
    final List<String> photos = [place.imageUrl, ...place.photos];
    // Fill to at least 6 with Unsplash variations
    final variations = [
      '${place.imageUrl}&sig=1',
      '${place.imageUrl}&sig=2',
      '${place.imageUrl}&sig=3',
      '${place.imageUrl}&sig=4',
      '${place.imageUrl}&sig=5',
    ];
    int i = 0;
    while (photos.length < 6 && i < variations.length) {
      photos.add(variations[i]);
      i++;
    }
    return photos;
  }

  @override
  Widget build(BuildContext context) {
    final photos = _allPhotos;
    final catColor = categoryColor(place.category);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${photos.length} Photos',
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemCount: photos.length,
            itemBuilder: (_, i) {
              // Make first photo span 2 columns and rows
              if (i == 0) {
                return Container(); // placeholder; handled below
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: photos[i],
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: catColor.withOpacity(0.12),
                    child: Center(
                      child: Text(place.category.emoji,
                          style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: catColor.withOpacity(0.12),
                    child: Center(
                      child: Text(place.category.emoji,
                          style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                ),
              );
            },
          ),
          // Custom layout: big first photo + grid
          _PhotoGrid(photos: photos, catColor: catColor, emoji: place.category.emoji),
        ],
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  final List<String> photos;
  final Color catColor;
  final String emoji;

  const _PhotoGrid(
      {required this.photos, required this.catColor, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero photo
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CachedNetworkImage(
            imageUrl: photos[0],
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              height: 200,
              color: catColor.withOpacity(0.12),
              child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 56))),
            ),
            errorWidget: (_, __, ___) => Container(
              height: 200,
              color: catColor.withOpacity(0.12),
              child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 56))),
            ),
          ),
        ),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1,
          ),
          itemCount: photos.length > 1 ? photos.length - 1 : 0,
          itemBuilder: (_, i) {
            final url = photos[i + 1];
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: catColor.withOpacity(0.12),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: catColor.withOpacity(0.12),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ── TAB 3: Reviews ─────────────────────────────────────────────────────────────
class _ReviewsTab extends StatelessWidget {
  final Place place;
  const _ReviewsTab({required this.place});

  static const _fakeReviews = [
    Review(
      reviewerName: 'Amit Sharma',
      rating: 5.0,
      date: 'Jan 2025',
      comment:
          'Absolutely breathtaking! One of the most beautiful places I have visited in India. The atmosphere is spiritual and the scenery is magnificent. A must-visit!',
      helpfulCount: 89,
    ),
    Review(
      reviewerName: 'Priya Mehta',
      rating: 4.5,
      date: 'Dec 2024',
      comment:
          'Wonderful experience. The place has great historical significance and is very well maintained. Go early in the morning to avoid crowds. Highly recommended.',
      helpfulCount: 54,
    ),
    Review(
      reviewerName: 'Rajesh Kumar',
      rating: 4.0,
      date: 'Nov 2024',
      comment:
          'Beautiful location with stunning views. Facilities could be better but the overall experience is great. Perfect for photography enthusiasts.',
      helpfulCount: 32,
    ),
    Review(
      reviewerName: 'Sunita Rao',
      rating: 5.0,
      date: 'Oct 2024',
      comment:
          'A truly magical place. The colours, the energy and the surroundings are unlike anything else in India. Plan for a full day.',
      helpfulCount: 67,
    ),
    Review(
      reviewerName: 'David Wilson',
      rating: 4.5,
      date: 'Feb 2025',
      comment:
          'Incredible experience visiting this iconic destination. Hire a local guide for the best insights – you will not regret it.',
      helpfulCount: 41,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final reviews =
        place.reviews.isNotEmpty ? place.reviews : _fakeReviews;
    final rating = place.rating;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall rating display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < rating.round()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${reviews.length} reviews',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textHint),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(child: _RatingBars(rating: rating)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Review cards
          ...reviews.map((r) => _ReviewCard(review: r)),
        ],
      ),
    );
  }
}

class _RatingBars extends StatelessWidget {
  final double rating;
  const _RatingBars({required this.rating});

  @override
  Widget build(BuildContext context) {
    // Fake distribution based on overall rating
    final r = rating.clamp(1.0, 5.0);
    final List<double> fractions = [
      ((r - 1) / 4 * 0.55 + 0.35).clamp(0.0, 1.0), // 5 star
      ((r - 1) / 4 * 0.20 + 0.25).clamp(0.0, 1.0), // 4 star
      (1.0 - r / 5 * 0.6).clamp(0.05, 0.3),          // 3 star
      (1.0 - r / 5 * 0.8).clamp(0.02, 0.15),          // 2 star
      (1.0 - r / 5 * 0.9).clamp(0.01, 0.08),          // 1 star
    ];

    return Column(
      children: List.generate(5, (i) {
        final star = 5 - i;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Text('$star',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary)),
              const SizedBox(width: 4),
              const Icon(Icons.star_rounded,
                  size: 11, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: fractions[i],
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final r = review;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
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
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.15),
                child: Text(
                  r.reviewerName[0].toUpperCase(),
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.reviewerName,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy)),
                    Text(r.date,
                        style: GoogleFonts.poppins(
                            fontSize: 10, color: AppColors.textHint)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.white, size: 11),
                    const SizedBox(width: 3),
                    Text(r.rating.toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            r.comment,
            style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.6),
          ),
          if (r.helpfulCount > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.thumb_up_outlined,
                    size: 12, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text('${r.helpfulCount} found this helpful',
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: AppColors.textHint)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── TAB 4: Nearby ──────────────────────────────────────────────────────────────
class _NearbyTab extends StatelessWidget {
  final Place place;
  const _NearbyTab({required this.place});

  @override
  Widget build(BuildContext context) {
    final city = place.nearestCity;
    final state = place.state;

    final nearbyRestaurants = allRestaurants
        .where((r) =>
            r.city.toLowerCase().contains(city.toLowerCase()) ||
            r.state == state)
        .take(6)
        .toList();

    final nearbyHotels = allHotels
        .where((h) =>
            h.city.toLowerCase().contains(city.toLowerCase()) ||
            h.state == state)
        .take(6)
        .toList();

    final nearbyActivities = allActivities
        .where((a) =>
            a.city.toLowerCase().contains(city.toLowerCase()) ||
            a.state == state)
        .take(6)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurants
          if (nearbyRestaurants.isNotEmpty) ...[
            _NearbyHeader(
              icon: Icons.restaurant,
              title: 'Restaurants Nearby',
              onSeeAll: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RestaurantsScreen())),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nearbyRestaurants.length,
                itemBuilder: (_, i) {
                  final r = nearbyRestaurants[i];
                  return _NearbyMiniCard(
                    imageUrl: r.imageUrl,
                    title: r.name,
                    subtitle: r.cuisines.take(1).map((c) => c.displayName).join(),
                    rating: r.rating,
                    badge: r.priceRange.symbol,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              RestaurantDetailScreen(restaurant: r)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Hotels
          if (nearbyHotels.isNotEmpty) ...[
            _NearbyHeader(
              icon: Icons.hotel,
              title: 'Places to Stay',
              onSeeAll: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HotelsScreen())),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nearbyHotels.length,
                itemBuilder: (_, i) {
                  final h = nearbyHotels[i];
                  return _NearbyMiniCard(
                    imageUrl: h.imageUrl,
                    title: h.name,
                    subtitle: '${'★' * h.starRating.clamp(0, 5)} ${h.type.displayName}',
                    rating: h.rating,
                    badge: h.pricePerNight,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => HotelDetailScreen(hotel: h)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Activities
          if (nearbyActivities.isNotEmpty) ...[
            _NearbyHeader(
              icon: Icons.bolt,
              title: 'Things To Do',
              onSeeAll: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ActivitiesScreen())),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nearbyActivities.length,
                itemBuilder: (_, i) {
                  final a = nearbyActivities[i];
                  return _NearbyMiniCard(
                    imageUrl: a.imageUrl,
                    title: a.name,
                    subtitle: '${a.category.emoji} ${a.duration}',
                    rating: a.rating,
                    badge: a.pricePerPerson,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ActivityDetailScreen(activity: a)),
                    ),
                  );
                },
              ),
            ),
          ],

          if (nearbyRestaurants.isEmpty &&
              nearbyHotels.isEmpty &&
              nearbyActivities.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Text('🔍', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text('No nearby listings found',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NearbyHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onSeeAll;

  const _NearbyHeader(
      {required this.icon, required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ],
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text('See all',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _NearbyMiniCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final double rating;
  final String badge;
  final VoidCallback onTap;

  const _NearbyMiniCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                      height: 90,
                      color: AppColors.primary.withOpacity(0.1)),
                  errorWidget: (_, __, ___) => Container(
                      height: 90,
                      color: AppColors.primary.withOpacity(0.1)),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.white, size: 9),
                        const SizedBox(width: 2),
                        Text(rating.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 9, color: AppColors.textHint)),
                  const SizedBox(height: 3),
                  Text(badge,
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _RatingBreakdown extends StatelessWidget {
  final double rating;
  const _RatingBreakdown({required this.rating});

  @override
  Widget build(BuildContext context) {
    final r = rating.clamp(1.0, 5.0);
    final List<double> fractions = [
      ((r - 1) / 4 * 0.55 + 0.35).clamp(0.0, 1.0),
      ((r - 1) / 4 * 0.20 + 0.25).clamp(0.0, 1.0),
      (1.0 - r / 5 * 0.6).clamp(0.05, 0.3),
      (1.0 - r / 5 * 0.8).clamp(0.02, 0.15),
      (1.0 - r / 5 * 0.9).clamp(0.01, 0.08),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
        child: Row(
          children: [
            Column(
              children: [
                Text(rating.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy)),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < rating.round()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: List.generate(5, (i) {
                  final star = 5 - i;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text('$star',
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary)),
                        const SizedBox(width: 3),
                        const Icon(Icons.star_rounded,
                            size: 10, color: AppColors.primary),
                        const SizedBox(width: 5),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: fractions[i],
                              backgroundColor: Colors.grey.shade200,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                      AppColors.primary),
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BestForSection extends StatelessWidget {
  final Place place;
  const _BestForSection({required this.place});

  List<_BestForItem> _getBestFor() {
    final items = <_BestForItem>[];
    switch (place.category) {
      case PlaceCategory.beach:
        items.addAll(const [
          _BestForItem('Couples', Icons.favorite_outline),
          _BestForItem('Families', Icons.family_restroom),
          _BestForItem('Adventure Seekers', Icons.surfing),
        ]);
      case PlaceCategory.hillStation:
        items.addAll(const [
          _BestForItem('Couples', Icons.favorite_outline),
          _BestForItem('Solo Travel', Icons.person_outline),
          _BestForItem('Adventure Seekers', Icons.terrain),
        ]);
      case PlaceCategory.temple:
        items.addAll(const [
          _BestForItem('Families', Icons.family_restroom),
          _BestForItem('Solo Travel', Icons.self_improvement),
          _BestForItem('Groups', Icons.group_outlined),
        ]);
      case PlaceCategory.fort:
        items.addAll(const [
          _BestForItem('Families', Icons.family_restroom),
          _BestForItem('Groups', Icons.group_outlined),
          _BestForItem('Solo Travel', Icons.person_outline),
        ]);
      case PlaceCategory.wildlife:
        items.addAll(const [
          _BestForItem('Families', Icons.family_restroom),
          _BestForItem('Adventure Seekers', Icons.forest),
          _BestForItem('Couples', Icons.favorite_outline),
        ]);
      case PlaceCategory.city:
        items.addAll(const [
          _BestForItem('Families', Icons.family_restroom),
          _BestForItem('Solo Travel', Icons.person_outline),
          _BestForItem('Groups', Icons.group_outlined),
        ]);
      default:
        items.addAll(const [
          _BestForItem('Couples', Icons.favorite_outline),
          _BestForItem('Families', Icons.family_restroom),
          _BestForItem('Solo Travel', Icons.person_outline),
        ]);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _getBestFor();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Best For',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items
                  .map((item) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.navy.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.navy.withOpacity(0.15)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(item.icon,
                                size: 14, color: AppColors.navy),
                            const SizedBox(width: 5),
                            Text(item.label,
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.navy)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BestForItem {
  final String label;
  final IconData icon;
  const _BestForItem(this.label, this.icon);
}

class _TravellerTips extends StatelessWidget {
  final Color catColor;
  const _TravellerTips({required this.catColor});

  static const _tips = [
    _TipData(
      name: 'Ravi K.',
      tip: 'Visit early in the morning to avoid crowds and get the best photos. The golden hour light is spectacular!',
      icon: '📸',
    ),
    _TipData(
      name: 'Sophie M.',
      tip: 'Hire a local guide – they know all the hidden spots and share fascinating stories you would never discover alone.',
      icon: '🗺️',
    ),
    _TipData(
      name: 'Arjun S.',
      tip: 'Carry water and sunscreen. The heat can be intense. Also bargain at local shops – it\'s expected and fun!',
      icon: '☀️',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.lightbulb_outline, size: 16, color: catColor),
              const SizedBox(width: 6),
              Text('Traveller Tips',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ]),
            const SizedBox(height: 12),
            ..._tips.map((t) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: catColor.withOpacity(0.15)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.icon,
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.tip,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    height: 1.5)),
                            const SizedBox(height: 4),
                            Text('– ${t.name}',
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: catColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _TipData {
  final String name;
  final String tip;
  final String icon;
  const _TipData({required this.name, required this.tip, required this.icon});
}

class _QuickFactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickFactChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _Section({required this.child, required this.padding});

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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

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
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ── Attraction Card ────────────────────────────────────────────────────────────
class _AttractionCard extends StatefulWidget {
  final Attraction attraction;
  final Color color;
  const _AttractionCard({required this.attraction, required this.color});

  @override
  State<_AttractionCard> createState() => _AttractionCardState();
}

class _AttractionCardState extends State<_AttractionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.attraction;
    final c = widget.color;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color:
                  _expanded ? c.withOpacity(0.4) : Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: c.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(a.emoji,
                          style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.name,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        Text(a.nameHindi,
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: c,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(a.type,
                              style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: c,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
            if (_expanded) ...[
              Divider(height: 1, color: Colors.grey.shade100),
              if (a.imageUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: a.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 160,
                    color: c.withOpacity(0.1),
                    child: Center(
                      child: Text(a.emoji,
                          style: const TextStyle(fontSize: 48)),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 160,
                    color: c.withOpacity(0.1),
                    child: Center(
                      child: Text(a.emoji,
                          style: const TextStyle(fontSize: 48)),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.description,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.6)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _AttractionInfoChip(
                            icon: Icons.confirmation_number_outlined,
                            text: a.entryFee,
                            color: c),
                        const SizedBox(width: 8),
                        _AttractionInfoChip(
                            icon: Icons.access_time_outlined,
                            text: a.timings,
                            color: c),
                      ],
                    ),
                    if (a.activities.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _AttractionSection(
                        icon: Icons.directions_run,
                        title: 'Activities',
                        items: a.activities,
                        color: c,
                        itemIcon: Icons.check_circle_outline,
                      ),
                    ],
                    if (a.famousFoods.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _AttractionSection(
                        icon: Icons.restaurant_menu,
                        title: 'Famous Food',
                        items: a.famousFoods,
                        color: c,
                        itemIcon: Icons.fastfood_outlined,
                      ),
                    ],
                    if (a.vehicleRentals.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _AttractionSection(
                        icon: Icons.two_wheeler,
                        title: 'Vehicle Rentals',
                        items: a.vehicleRentals,
                        color: c,
                        itemIcon: Icons.directions_car_outlined,
                      ),
                    ],
                    if (a.latitude != 0.0 && a.longitude != 0.0) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => MapsService.openOnMap(
                              a.latitude, a.longitude, a.name),
                          icon: Icon(Icons.map_outlined, size: 14, color: c),
                          label: Text('View on Map',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: c)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: c,
                            side: BorderSide(color: c.withOpacity(0.5)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AttractionSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;
  final Color color;
  final IconData itemIcon;

  const _AttractionSection({
    required this.icon,
    required this.title,
    required this.items,
    required this.color,
    required this.itemIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: items
              .map((item) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(itemIcon, size: 10, color: color),
                        const SizedBox(width: 4),
                        Text(item,
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: color,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _AttractionInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _AttractionInfoChip(
      {required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
