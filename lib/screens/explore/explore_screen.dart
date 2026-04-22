import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/place.dart';
import '../../providers/places_provider.dart';
import '../../core/theme.dart';
import '../../widgets/place/place_card.dart';
import '../place_detail/place_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  final PlaceCategory? initialCategory;
  const ExploreScreen({super.key, this.initialCategory});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _isSearching = _searchController.text.isNotEmpty);
    });
    if (widget.initialCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<PlacesProvider>().setCategory(widget.initialCategory);
        setState(() => _isSearching = true);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _clearSearch(PlacesProvider provider) {
    _searchController.clear();
    provider.clearFilters();
    _searchFocus.unfocus();
    setState(() => _isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlacesProvider>();
    final showResults = _isSearching ||
        provider.selectedCategory != null ||
        provider.selectedSeason != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(provider, showResults),
          if (!showResults) _buildSeasonChips(provider),
          Expanded(
            child: showResults
                ? _buildSearchResults(provider)
                : _buildCategoryBrowse(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(PlacesProvider provider, bool showResults) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!showResults) ...[
            Text('Explore India',
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            Text('अतुल्य भारत • Discover every corner',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
          ],
          // Search bar
          TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            onChanged: (v) {
              provider.setSearch(v);
              setState(() => _isSearching = v.isNotEmpty);
            },
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search places, states, categories...',
              hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon: showResults
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => _clearSearch(provider),
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 13),
            ),
          ),
          if (showResults) ...[
            const SizedBox(height: 10),
            _buildFilterChips(provider),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChips(PlacesProvider provider) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _Chip(
            label: 'All',
            emoji: '🗺️',
            selected: provider.selectedCategory == null && provider.selectedSeason == null,
            onTap: () {
              provider.setCategory(null);
              provider.setSeason(null);
            },
            color: AppColors.primary,
          ),
          ...PlaceCategory.values.map((cat) => _Chip(
                label: cat.displayName,
                emoji: cat.emoji,
                selected: provider.selectedCategory == cat,
                onTap: () => provider.setCategory(
                    provider.selectedCategory == cat ? null : cat),
                color: categoryColor(cat),
              )),
          const SizedBox(width: 8),
          ...Season.values.map((s) => _Chip(
                label: s.displayName,
                emoji: s.emoji,
                selected: provider.selectedSeason == s,
                onTap: () => provider.setSeason(
                    provider.selectedSeason == s ? null : s),
                color: seasonColor(s),
              )),
        ],
      ),
    );
  }

  Widget _buildSeasonChips(PlacesProvider provider) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: Season.values.map((s) {
          final color = seasonColor(s);
          return Expanded(
            child: GestureDetector(
              onTap: () {
                provider.setSeason(s);
                setState(() => _isSearching = true);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(s.emoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 2),
                    Text(s.displayNameHindi,
                        style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: color,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Browsing mode: grouped by category ──────────────────────
  Widget _buildCategoryBrowse(PlacesProvider provider) {
    final all = provider.allList;

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: PlaceCategory.values.map((cat) {
        final places = all.where((p) => p.category == cat).toList();
        if (places.isEmpty) return const SizedBox.shrink();
        final color = categoryColor(cat);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(cat.emoji,
                          style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cat.displayName,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      Text(cat.displayNameHindi,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: color)),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      provider.setCategory(cat);
                      setState(() => _isSearching = true);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text('${places.length} places',
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: color,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios,
                              size: 10, color: color),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Horizontal cards row
            SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: places.length,
                itemBuilder: (_, i) {
                  final p = places[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PlaceDetailScreen(place: p)),
                    ),
                    child: _HorizontalPlaceCard(place: p, color: color),
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  // ── Search / filter results mode ────────────────────────────
  Widget _buildSearchResults(PlacesProvider provider) {
    final places = provider.filteredPlaces;

    if (places.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 50)),
            const SizedBox(height: 12),
            Text('No places found',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            Text('Try a different search',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          child: Row(
            children: [
              Text('${places.length} places found',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: places.length,
            itemBuilder: (_, i) {
              final p = places[i];
              return PlaceCard(
                place: p,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PlaceDetailScreen(place: p)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Horizontal card for browse mode ─────────────────────────────────────────
class _HorizontalPlaceCard extends StatelessWidget {
  final Place place;
  final Color color;
  const _HorizontalPlaceCard({required this.place, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: place.imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                height: 110,
                color: color.withOpacity(0.15),
                child: Center(
                  child: Text(place.category.emoji,
                      style: const TextStyle(fontSize: 36)),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                height: 110,
                color: color.withOpacity(0.15),
                child: Center(
                  child: Text(place.category.emoji,
                      style: const TextStyle(fontSize: 36)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  place.state,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                    const SizedBox(width: 3),
                    Text(place.rating.toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        place.entryFee == 'Free' ? 'Free' : '₹',
                        style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: color,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter chip ──────────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _Chip({
    required this.label,
    required this.emoji,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? color : Colors.grey.shade300),
          boxShadow: selected
              ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 6)]
              : [],
        ),
        child: Text(
          '$emoji $label',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
