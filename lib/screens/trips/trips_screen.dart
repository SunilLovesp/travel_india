import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/trip.dart';
import '../../providers/trip_provider.dart';
import 'create_trip_screen.dart';
import 'trip_detail_screen.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TripProvider>();
    final trips = provider.trips;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            leading: Navigator.canPop(context)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 18),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Trips',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Text('Plan your adventures',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.white70)),
              ],
            ),
            actions: [
              if (trips.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${trips.length} trip${trips.length == 1 ? '' : 's'}',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          if (trips.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🗺️',
                              style: TextStyle(fontSize: 50)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Plan Your Next Adventure',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      Text(
                        'Create a day-by-day itinerary for your India trip. Add places, activities and notes for each day.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            height: 1.5),
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        onPressed: () => _goToCreateTrip(context),
                        icon: const Icon(Icons.add, size: 20),
                        label: Text('Create a Trip',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final trip = trips[i];
                    return _TripCard(
                      trip: trip,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TripDetailScreen(trip: trip),
                        ),
                      ),
                      onDelete: () => provider.removeTrip(trip.id),
                    );
                  },
                  childCount: trips.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: trips.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _goToCreateTrip(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('New Trip',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            )
          : null,
    );
  }

  void _goToCreateTrip(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTripScreen()),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TripCard({
    required this.trip,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final destinations = _destinationEmojis[trip.destination] ?? '🗺️';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top coloured header
            Container(
              height: 90,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(destinations,
                        style: const TextStyle(fontSize: 50)),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.white70, size: 20),
                      onPressed: () => _confirmDelete(context),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 13, color: AppColors.textHint),
                      const SizedBox(width: 3),
                      Text(
                        trip.destination,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _TripInfoChip(
                        icon: Icons.calendar_month_outlined,
                        label: '${trip.totalDays} day${trip.totalDays == 1 ? '' : 's'}',
                      ),
                      const SizedBox(width: 8),
                      _TripInfoChip(
                        icon: Icons.place_outlined,
                        label: '${_totalPlaces(trip)} places',
                      ),
                      const SizedBox(width: 8),
                      _TripInfoChip(
                        icon: Icons.bolt_outlined,
                        label: '${_totalActivities(trip)} activities',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created ${_formatDate(trip.createdAt)}',
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _totalPlaces(Trip t) =>
      t.days.fold(0, (sum, d) => sum + d.placeIds.length);

  int _totalActivities(Trip t) =>
      t.days.fold(0, (sum, d) => sum + d.activityIds.length);

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Trip',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text(
            'Are you sure you want to delete "${trip.title}"?',
            style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger),
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text('Delete',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  static const _destinationEmojis = {
    'Goa': '🏖️',
    'Rajasthan': '🏯',
    'Kerala': '🌴',
    'Himachal Pradesh': '🏔️',
    'Uttarakhand': '🕉️',
    'Delhi': '🇮🇳',
    'Mumbai': '🏙️',
    'Ladakh': '🏜️',
    'Andaman': '🐠',
    'Sikkim': '⛰️',
  };
}

class _TripInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TripInfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark)),
        ],
      ),
    );
  }
}
