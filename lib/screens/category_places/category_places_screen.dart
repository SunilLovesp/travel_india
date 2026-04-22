import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../data/places_data.dart';
import '../../models/place.dart';
import '../../widgets/place/place_card.dart';
import '../place_detail/place_detail_screen.dart';

class CategoryPlacesScreen extends StatefulWidget {
  final PlaceCategory category;
  const CategoryPlacesScreen({super.key, required this.category});

  @override
  State<CategoryPlacesScreen> createState() => _CategoryPlacesScreenState();
}

class _CategoryPlacesScreenState extends State<CategoryPlacesScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(widget.category);
    final all = allPlaces
        .where((p) => p.category == widget.category)
        .toList();
    final places = _query.isEmpty
        ? all
        : all.where((p) {
            final q = _query.toLowerCase();
            return p.name.toLowerCase().contains(q) ||
                p.state.toLowerCase().contains(q) ||
                p.shortDescription.toLowerCase().contains(q) ||
                p.tags.any((t) => t.toLowerCase().contains(q));
          }).toList();

    // Group by state for browsing (when no search)
    final Map<String, List<Place>> byState = {};
    if (_query.isEmpty) {
      for (final p in all) {
        byState.putIfAbsent(p.state, () => []).add(p);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withOpacity(0.7)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.category.emoji,
                                style: const TextStyle(fontSize: 36)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.category.displayName,
                                  style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white),
                                ),
                                Text(
                                  widget.category.displayNameHindi,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${all.length} places',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v.trim()),
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText:
                      'Search in ${widget.category.displayName}...',
                  hintStyle:
                      GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: color),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: Colors.grey.shade200),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),

          // Content
          if (_query.isNotEmpty)
            _buildSearchResults(places, color)
          else
            _buildGroupedByState(byState, color),
        ],
      ),
    );
  }

  // ── Search results grid ─────────────────────────────────────
  Widget _buildSearchResults(List<Place> places, Color color) {
    if (places.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔍', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 12),
              Text('No results found',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, i) {
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
          childCount: places.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
      ),
    );
  }

  // ── Grouped by state ────────────────────────────────────────
  Widget _buildGroupedByState(
      Map<String, List<Place>> byState, Color color) {
    final states = byState.keys.toList()..sort();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, i) {
          final state = states[i];
          final places = byState[state]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // State header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      state,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('${places.length}',
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: color,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              // Places grid for this state
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: places.length,
                itemBuilder: (_, j) {
                  final p = places[j];
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
              const SizedBox(height: 8),
            ],
          );
        },
        childCount: states.length,
      ),
    );
  }
}
