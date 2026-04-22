import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/place.dart';
import '../../providers/favorites_provider.dart';
import '../../core/theme.dart';

Color categoryColor(PlaceCategory cat) {
  switch (cat) {
    case PlaceCategory.temple:
      return AppColors.templeColor;
    case PlaceCategory.beach:
      return AppColors.beachColor;
    case PlaceCategory.hillStation:
      return AppColors.hillColor;
    case PlaceCategory.city:
      return AppColors.cityColor;
    case PlaceCategory.fort:
      return AppColors.fortColor;
    case PlaceCategory.wildlife:
      return AppColors.wildlifeColor;
    case PlaceCategory.waterfall:
      return AppColors.waterfallColor;
    case PlaceCategory.lake:
      return AppColors.lakeColor;
    case PlaceCategory.adventure:
      return AppColors.adventureColor;
    case PlaceCategory.museum:
      return AppColors.museumColor;
    case PlaceCategory.market:
      return AppColors.marketColor;
    case PlaceCategory.cave:
      return AppColors.caveColor;
    case PlaceCategory.valley:
      return AppColors.valleyColor;
    case PlaceCategory.desert:
      return AppColors.desertColor;
  }
}

Color seasonColor(Season s) {
  switch (s) {
    case Season.winter:
      return AppColors.winterColor;
    case Season.summer:
      return AppColors.summerColor;
    case Season.monsoon:
      return AppColors.monsoonColor;
    case Season.autumn:
      return AppColors.autumnColor;
  }
}

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;
  final double? distanceKm;

  const PlaceCard({
    super.key,
    required this.place,
    required this.onTap,
    this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesProvider>();
    final isFav = favs.isFavorite(place.id);
    final catColor = categoryColor(place.category);
    final isTravChoice = place.rating >= 4.5 && place.isFeatured;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Image section
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: place.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 140,
                    color: catColor.withOpacity(0.15),
                    child: Center(
                      child: Text(place.category.emoji,
                          style: const TextStyle(fontSize: 44)),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 140,
                    color: catColor.withOpacity(0.15),
                    child: Center(
                      child: Text(place.category.emoji,
                          style: const TextStyle(fontSize: 44)),
                    ),
                  ),
                ),
                // Travellers' Choice badge
                if (isTravChoice)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00AA6C),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.workspace_premium,
                              color: Colors.white, size: 10),
                          const SizedBox(width: 3),
                          Text("Travellers' Choice",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  )
                else
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: catColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${place.category.emoji} ${place.category.displayName}',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                // Heart button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => favs.toggle(place.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 4),
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 16,
                        color: isFav ? AppColors.danger : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
                // Distance badge
                if (distanceKm != null)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.near_me,
                              color: Colors.white, size: 10),
                          const SizedBox(width: 3),
                          Text(
                            '${distanceKm!.toStringAsFixed(0)} km',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 11, color: AppColors.textSecondary),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          place.state,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  // Rating bubble + season chips
                  Row(
                    children: [
                      // TA-style bubble rating
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
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
                            Text(
                              place.rating.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Best season emoji
                      if (place.bestSeasons.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: seasonColor(place.bestSeasons.first)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${place.bestSeasons.first.emoji} ${place.bestSeasons.first.displayName}',
                            style: GoogleFonts.poppins(
                                fontSize: 9,
                                color: seasonColor(place.bestSeasons.first),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
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
