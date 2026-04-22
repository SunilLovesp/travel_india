import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../data/places_data.dart';
import '../../models/place.dart';
import '../../widgets/place/place_card.dart';
import '../place_detail/place_detail_screen.dart';

class StatePlacesScreen extends StatelessWidget {
  final String stateName;
  const StatePlacesScreen({super.key, required this.stateName});

  @override
  Widget build(BuildContext context) {
    final places = allPlaces.where((p) => p.state == stateName).toList();

    // Group by category
    final Map<PlaceCategory, List<Place>> grouped = {};
    for (final p in places) {
      grouped.putIfAbsent(p.category, () => []).add(p);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stateName,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text('${places.length} destinations',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: places.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🏗️', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text('Coming Soon!',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('Places for $stateName\nare being added.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((entry) {
                final category = entry.key;
                final catPlaces = entry.value;
                final color = categoryColor(category);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(category.emoji,
                                style: const TextStyle(fontSize: 14)),
                          ),
                          const SizedBox(width: 8),
                          Text(category.displayName,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('${catPlaces.length}',
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: color,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    ...catPlaces.map((place) => PlaceCard(
                          place: place,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlaceDetailScreen(place: place),
                            ),
                          ),
                        )),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
    );
  }
}
