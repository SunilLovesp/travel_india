import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/place.dart';
import '../../models/restaurant.dart';
import '../../models/hotel.dart';
import '../../models/activity.dart';
import '../../providers/places_provider.dart';
import '../../core/theme.dart';
import '../../widgets/place/place_card.dart';
import '../../data/places_data.dart';
import '../../data/restaurants_data.dart';
import '../../data/hotels_data.dart';
import '../../data/activities_data.dart';
import '../place_detail/place_detail_screen.dart';
import '../category_places/category_places_screen.dart';
import '../explore/explore_screen.dart';
import '../state_places/state_places_screen.dart';
import '../all_states/all_states_screen.dart';
import '../restaurants/restaurants_screen.dart';
import '../restaurants/restaurant_detail_screen.dart';
import '../hotels/hotels_screen.dart';
import '../hotels/hotel_detail_screen.dart';
import '../activities/activities_screen.dart';
import '../activities/activity_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openDetail(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlacesProvider>();
    final featured = provider.featuredPlaces;
    final seasonal = provider.currentSeasonPlaces;
    final currentSeason = SeasonExtension.currentSeason();
    final trending = allPlaces
        .where((p) => p.rating >= 4.4)
        .toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final featuredActivities =
        allActivities.where((a) => a.isFeatured).toList();
    final travChoice = allPlaces
        .where((p) => p.rating >= 4.5)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 60,
            floating: true,
            snap: true,
            backgroundColor: AppColors.primary,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Travel India',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Text('भारत की यात्रा',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.white70)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ExploreScreen()),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Quick Category Row (TripAdvisor-style) ────────────────────
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('What are you looking for?',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _QuickCatTile(
                          emoji: '🏛️',
                          label: 'Attractions',
                          color: AppColors.templeColor,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ExploreScreen()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickCatTile(
                          emoji: '🍽️',
                          label: 'Restaurants',
                          color: AppColors.primary,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RestaurantsScreen()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickCatTile(
                          emoji: '🏨',
                          label: 'Hotels',
                          color: AppColors.navy,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HotelsScreen()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickCatTile(
                          emoji: '🎯',
                          label: 'Things To Do',
                          color: AppColors.adventureColor,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ActivitiesScreen()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Featured Carousel ─────────────────────────────────────────
                if (featured.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Featured Destinations',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (i) =>
                          setState(() => _currentPage = i),
                      itemCount: featured.length,
                      itemBuilder: (_, i) {
                        final p = featured[i];
                        return GestureDetector(
                          onTap: () => _openDetail(p),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: p.imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Container(
                                      color: categoryColor(p.category)
                                          .withOpacity(0.3),
                                      child: Center(
                                          child: Text(p.category.emoji,
                                              style: const TextStyle(
                                                  fontSize: 50))),
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      color: categoryColor(p.category)
                                          .withOpacity(0.3),
                                      child: Center(
                                          child: Text(p.category.emoji,
                                              style: const TextStyle(
                                                  fontSize: 50))),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.75),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    right: 16,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.name,
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Row(children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.white70,
                                              size: 14),
                                          const SizedBox(width: 2),
                                          Text(p.state,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white70,
                                                  fontSize: 12)),
                                          const Spacer(),
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 14),
                                          const SizedBox(width: 2),
                                          Text(
                                            p.rating.toString(),
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      featured.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentPage == i ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],

                // ── Trending Now ──────────────────────────────────────────────
                if (trending.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('🔥 Trending Now',
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        TextButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const ExploreScreen())),
                          child: Text('See all',
                              style: GoogleFonts.poppins(
                                  color: AppColors.primary, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: trending.take(8).length,
                      itemBuilder: (_, i) {
                        final p = trending[i];
                        return SizedBox(
                          width: 180,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: PlaceCard(
                                place: p, onTap: () => _openDetail(p)),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                // ── Season Banner ─────────────────────────────────────────────
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SeasonBanner(
                      season: currentSeason, count: seasonal.length),
                ),

                // ── Travellers' Choice Banner ─────────────────────────────────
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _TravellersChoiceBanner(
                    count: travChoice.length,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ExploreScreen()),
                    ),
                  ),
                ),

                // ── Things To Do ──────────────────────────────────────────────
                if (featuredActivities.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Things To Do',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        TextButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const ActivitiesScreen())),
                          child: Text('See all',
                              style: GoogleFonts.poppins(
                                  color: AppColors.primary, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: featuredActivities.length,
                      itemBuilder: (_, i) {
                        final a = featuredActivities[i];
                        return _ActivityCard(
                          activity: a,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ActivityDetailScreen(activity: a),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                // ── Categories ────────────────────────────────────────────────
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Explore by Category',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    children: PlaceCategory.values.map((cat) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CategoryPlacesScreen(category: cat),
                          ),
                        ),
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: categoryColor(cat)
                                      .withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  border: Border.all(
                                      color: categoryColor(cat)
                                          .withOpacity(0.3)),
                                ),
                                child: Center(
                                  child: Text(cat.emoji,
                                      style: const TextStyle(
                                          fontSize: 28)),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cat.displayName,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // ── Browse by State ───────────────────────────────────────────
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Browse by State',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AllStatesScreen()),
                        ),
                        child: Text('See all',
                            style: GoogleFonts.poppins(
                                color: AppColors.primary, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    children: _stateInfoList.map((s) {
                      final count = allPlaces
                          .where((p) => p.state == s.name)
                          .length;
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                StatePlacesScreen(stateName: s.name),
                          ),
                        ),
                        child: Container(
                          width: 90,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: s.color.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(s.emoji,
                                      style: const TextStyle(
                                          fontSize: 22)),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6),
                                child: Text(
                                  s.name.split(' ').take(2).join('\n'),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary),
                                ),
                              ),
                              Text(
                                '$count places',
                                style: GoogleFonts.poppins(
                                    fontSize: 8,
                                    color: s.color,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // ── Quick links: Restaurants & Hotels ─────────────────────────
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _QuickLinkCard(
                          icon: Icons.restaurant,
                          label: 'Restaurants',
                          subtitle: 'Where to eat',
                          color: AppColors.primary,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const RestaurantsScreen()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickLinkCard(
                          icon: Icons.hotel,
                          label: 'Hotels',
                          subtitle: 'Where to stay',
                          color: AppColors.navy,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HotelsScreen()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Top Restaurants ───────────────────────────────────────────
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Top Restaurants in India',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RestaurantsScreen()),
                        ),
                        child: Text('See all',
                            style: GoogleFonts.poppins(
                                color: AppColors.primary, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: allRestaurants
                        .where((r) => r.isFeatured)
                        .length,
                    itemBuilder: (_, i) {
                      final featuredR = allRestaurants
                          .where((r) => r.isFeatured)
                          .toList();
                      final r = featuredR[i];
                      return _RestaurantCard(
                        restaurant: r,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RestaurantDetailScreen(restaurant: r),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Places to Stay ────────────────────────────────────────────
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Places to Stay',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HotelsScreen()),
                        ),
                        child: Text('See all',
                            style: GoogleFonts.poppins(
                                color: AppColors.primary, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    itemCount:
                        allHotels.where((h) => h.isFeatured).length,
                    itemBuilder: (_, i) {
                      final featuredH =
                          allHotels.where((h) => h.isFeatured).toList();
                      final h = featuredH[i];
                      return _HotelCard(
                        hotel: h,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HotelDetailScreen(hotel: h),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Best for this Season ──────────────────────────────────────
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${currentSeason.emoji} Best for ${currentSeason.displayName}',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('See all',
                            style: GoogleFonts.poppins(
                                color: AppColors.primary, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: seasonal.length,
                    itemBuilder: (_, i) {
                      final p = seasonal[i];
                      return SizedBox(
                        width: 180,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: PlaceCard(
                              place: p, onTap: () => _openDetail(p)),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick Category Tile ────────────────────────────────────────────────────────
class _QuickCatTile extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickCatTile({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Travellers' Choice Banner ─────────────────────────────────────────────────
class _TravellersChoiceBanner extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _TravellersChoiceBanner(
      {required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Icon(Icons.workspace_premium,
                    color: Colors.white, size: 28),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Travellers' Choice 2024",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '$count top-rated destinations in India',
                    style: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Explore',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Activity Card (home) ──────────────────────────────────────────────────────
class _ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;
  const _ActivityCard({required this.activity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final a = activity;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 175,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
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
                  imageUrl: a.imageUrl,
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 110,
                    color: AppColors.primary.withOpacity(0.1),
                    child: Center(
                      child: Text(a.category.emoji,
                          style: const TextStyle(fontSize: 32)),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 110,
                    color: AppColors.primary.withOpacity(0.1),
                    child: Center(
                      child: Text(a.category.emoji,
                          style: const TextStyle(fontSize: 32)),
                    ),
                  ),
                ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.white, size: 10),
                        const SizedBox(width: 2),
                        Text(a.rating.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(a.category.emoji,
                          style: const TextStyle(fontSize: 10)),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${a.duration} • ${a.city}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 9, color: AppColors.textHint),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(a.pricePerPerson,
                      style: GoogleFonts.poppins(
                          fontSize: 11,
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

// ── Season Banner ─────────────────────────────────────────────────────────────
class _SeasonBanner extends StatelessWidget {
  final Season season;
  final int count;
  const _SeasonBanner({required this.season, required this.count});

  @override
  Widget build(BuildContext context) {
    final color = seasonColor(season);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(season.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'It\'s ${season.displayName} Season!',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  '${season.displayNameHindi} • ${season.months}',
                  style: GoogleFonts.poppins(
                      color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count places perfect right now',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text('Explore',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// ── Quick link card ───────────────────────────────────────────────────────────
class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickLinkCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Home restaurant card ──────────────────────────────────────────────────────
class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  const _RestaurantCard({required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = restaurant;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 175,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
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
                  imageUrl: r.imageUrl,
                  height: 115,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 115,
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Center(
                      child: Icon(Icons.restaurant,
                          color: AppColors.primary, size: 32),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 115,
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Center(
                      child: Icon(Icons.restaurant,
                          color: AppColors.primary, size: 32),
                    ),
                  ),
                ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.white, size: 10),
                        const SizedBox(width: 2),
                        Text(r.rating.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy)),
                  const SizedBox(height: 2),
                  Text(
                    r.cuisines.take(2).map((c) => c.displayName).join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 10, color: AppColors.textHint),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(r.city,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: AppColors.textHint)),
                      ),
                      Text(r.priceRange.symbol,
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Home hotel card ───────────────────────────────────────────────────────────
class _HotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback onTap;
  const _HotelCard({required this.hotel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final h = hotel;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
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
                  imageUrl: h.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 120,
                    color: AppColors.navy.withOpacity(0.1),
                    child: const Center(
                      child: Icon(Icons.hotel,
                          color: AppColors.navy, size: 32),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 120,
                    color: AppColors.navy.withOpacity(0.1),
                    child: const Center(
                      child: Icon(Icons.hotel,
                          color: AppColors.navy, size: 32),
                    ),
                  ),
                ),
                Positioned(
                  top: 7,
                  left: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.navy.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(h.type.displayName,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.white, size: 10),
                        const SizedBox(width: 2),
                        Text(h.rating.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(h.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      ...List.generate(
                        h.starRating.clamp(0, 5),
                        (_) => const Icon(Icons.star_rounded,
                            size: 11, color: AppColors.ratingYellow),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 10, color: AppColors.textHint),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(h.city,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: AppColors.textHint)),
                      ),
                      Text(h.pricePerNight,
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── State info model ──────────────────────────────────────────────────────────
class _StateInfo {
  final String name;
  final String emoji;
  final Color color;
  const _StateInfo(this.name, this.emoji, this.color);
}

const List<_StateInfo> _stateInfoList = [
  _StateInfo('Himachal Pradesh',          '🏔️', Color(0xFF1565C0)),
  _StateInfo('Jammu & Kashmir',           '❄️', Color(0xFF4527A0)),
  _StateInfo('Ladakh',                    '🏜️', Color(0xFF6D4C41)),
  _StateInfo('Uttarakhand',               '🕉️', Color(0xFF2E7D32)),
  _StateInfo('Rajasthan',                 '🏯', Color(0xFFE65100)),
  _StateInfo('Punjab',                    '🌾', Color(0xFFF57F17)),
  _StateInfo('Delhi',                     '🇮🇳', Color(0xFFB71C1C)),
  _StateInfo('Uttar Pradesh',             '🕌', Color(0xFF6A1B9A)),
  _StateInfo('Goa',                       '🏖️', Color(0xFF00838F)),
  _StateInfo('Maharashtra',               '🏙️', Color(0xFFBF360C)),
  _StateInfo('Gujarat',                   '🦁', Color(0xFFEF6C00)),
  _StateInfo('Karnataka',                 '🏛️', Color(0xFFAD1457)),
  _StateInfo('Kerala',                    '🌴', Color(0xFF00695C)),
  _StateInfo('Tamil Nadu',                '🛕', Color(0xFF880E4F)),
  _StateInfo('Andaman & Nicobar Islands', '🐠', Color(0xFF00796B)),
  _StateInfo('West Bengal',               '🐅', Color(0xFF1B5E20)),
  _StateInfo('Odisha',                    '☀️', Color(0xFFE65100)),
  _StateInfo('Madhya Pradesh',            '🐆', Color(0xFF4A148C)),
  _StateInfo('Telangana',                 '🕌', Color(0xFF006064)),
  _StateInfo('Bihar',                     '🌳', Color(0xFF33691E)),
  _StateInfo('Assam',                     '🦏', Color(0xFF1A237E)),
  _StateInfo('Meghalaya',                 '💦', Color(0xFF006064)),
  _StateInfo('Sikkim',                    '🏔️', Color(0xFF4527A0)),
];
