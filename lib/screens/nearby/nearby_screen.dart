import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/places_provider.dart';
import '../../core/theme.dart';
import '../../widgets/place/place_card.dart';
import '../place_detail/place_detail_screen.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  double _radius = 500;

  @override
  Widget build(BuildContext context) {
    final locProvider = context.watch<LocationProvider>();
    final placesProvider = context.watch<PlacesProvider>();
    final status = locProvider.status;

    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Places',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: Colors.white)),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          if (status == LocationStatus.granted) ...[
            // Radius selector
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Text('Radius: ',
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w500)),
                  ...([50.0, 100.0, 200.0, 500.0]).map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _radius = r),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _radius == r
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _radius == r
                                    ? AppColors.primary
                                    : Colors.grey.shade300),
                          ),
                          child: Text(
                            '${r.toInt()} km',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: _radius == r
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: _radius == r
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: _buildBody(locProvider, placesProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
      LocationProvider locProvider, PlacesProvider placesProvider) {
    switch (locProvider.status) {
      case LocationStatus.initial:
        return _PermissionCard(
          onAllow: () => locProvider.fetchLocation(),
        );
      case LocationStatus.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text('Getting your location...'),
            ],
          ),
        );
      case LocationStatus.denied:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📍', style: TextStyle(fontSize: 60)),
                const SizedBox(height: 16),
                Text('Location Access Denied',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  'Please enable location permission in your device settings to see nearby places.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => locProvider.fetchLocation(),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        );
      case LocationStatus.granted:
        final nearby =
            locProvider.nearbyPlaces(placesProvider.allList, radiusKm: _radius);
        if (nearby.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🗺️', style: TextStyle(fontSize: 50)),
                const SizedBox(height: 12),
                Text('No places within ${_radius.toInt()} km',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                Text('Try increasing the radius',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: nearby.length,
          itemBuilder: (_, i) {
            final p = nearby[i];
            final dist = locProvider.distanceTo(p);
            return PlaceCard(
              place: p,
              distanceKm: dist,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PlaceDetailScreen(place: p)),
              ),
            );
          },
        );
    }
  }
}

class _PermissionCard extends StatelessWidget {
  final VoidCallback onAllow;
  const _PermissionCard({required this.onAllow});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('📍', style: TextStyle(fontSize: 50)),
              ),
            ),
            const SizedBox(height: 24),
            Text('Find Nearby Places',
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(
              'Allow location access to discover amazing travel destinations near you across India.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: AppColors.textSecondary, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAllow,
                icon: const Icon(Icons.near_me),
                label: const Text('Use My Location'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
