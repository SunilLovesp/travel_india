import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../data/restaurants_data.dart';
import '../../models/restaurant.dart';
import 'restaurant_detail_screen.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final _searchController = TextEditingController();
  CuisineType? _selectedCuisine;
  PriceRange? _selectedPrice;
  String? _selectedState;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Restaurant> get _filtered {
    return allRestaurants.where((r) {
      final q = _query.toLowerCase();
      final matchesSearch = q.isEmpty ||
          r.name.toLowerCase().contains(q) ||
          r.city.toLowerCase().contains(q) ||
          r.state.toLowerCase().contains(q) ||
          r.cuisines.any((c) => c.displayName.toLowerCase().contains(q));
      final matchesCuisine =
          _selectedCuisine == null || r.cuisines.contains(_selectedCuisine);
      final matchesPrice =
          _selectedPrice == null || r.priceRange == _selectedPrice;
      final matchesState =
          _selectedState == null || r.state == _selectedState;
      return matchesSearch && matchesCuisine && matchesPrice && matchesState;
    }).toList();
  }

  List<String> get _states {
    final states = allRestaurants.map((r) => r.state).toSet().toList()..sort();
    return states;
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Restaurants',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: AppColors.navy)),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black12,
        iconTheme: const IconThemeData(color: AppColors.navy),
      ),
      body: Column(
        children: [
          // Search + filter bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                // Search
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search restaurants, cuisines, cities…',
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textHint, size: 20),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                const SizedBox(height: 10),
                // Filter chips row
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Price filter
                      _FilterDropdown<PriceRange>(
                        label: _selectedPrice == null
                            ? 'Price'
                            : _selectedPrice!.symbol,
                        selected: _selectedPrice != null,
                        onClear: () => setState(() => _selectedPrice = null),
                        child: _PriceDropdown(
                          value: _selectedPrice,
                          onChanged: (v) =>
                              setState(() => _selectedPrice = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Cuisine filter
                      _FilterDropdown<CuisineType>(
                        label: _selectedCuisine == null
                            ? 'Cuisine'
                            : _selectedCuisine!.displayName,
                        selected: _selectedCuisine != null,
                        onClear: () =>
                            setState(() => _selectedCuisine = null),
                        child: _CuisineDropdown(
                          value: _selectedCuisine,
                          onChanged: (v) =>
                              setState(() => _selectedCuisine = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // State filter
                      _FilterDropdown<String>(
                        label: _selectedState ?? 'State',
                        selected: _selectedState != null,
                        onClear: () => setState(() => _selectedState = null),
                        child: _StateDropdown(
                          states: _states,
                          value: _selectedState,
                          onChanged: (v) =>
                              setState(() => _selectedState = v),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results count
          Container(
            color: AppColors.background,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${results.length} restaurants',
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.restaurant,
                            size: 56, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        Text('No restaurants found',
                            style: GoogleFonts.poppins(
                                color: AppColors.textHint, fontSize: 15)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: results.length,
                    itemBuilder: (_, i) => _RestaurantListCard(
                      restaurant: results[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(
                              restaurant: results[i]),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Filter dropdown wrapper ────────────────────────────────────────────────────
class _FilterDropdown<T> extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onClear;
  final Widget child;

  const _FilterDropdown({
    required this.label,
    required this.selected,
    required this.onClear,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => child,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.12)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                selected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondary)),
            const SizedBox(width: 4),
            if (selected)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close,
                    size: 14, color: AppColors.primary),
              )
            else
              const Icon(Icons.keyboard_arrow_down,
                  size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class _PriceDropdown extends StatelessWidget {
  final PriceRange? value;
  final ValueChanged<PriceRange?> onChanged;
  const _PriceDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter by Price',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...PriceRange.values.map((p) => ListTile(
                title: Text('${p.symbol} – ${p.label}',
                    style: GoogleFonts.poppins(fontSize: 14)),
                trailing: value == p
                    ? const Icon(Icons.check_circle,
                        color: AppColors.primary)
                    : null,
                onTap: () {
                  onChanged(p);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }
}

class _CuisineDropdown extends StatelessWidget {
  final CuisineType? value;
  final ValueChanged<CuisineType?> onChanged;
  const _CuisineDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Cuisine',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: CuisineType.values
                    .map((c) => ListTile(
                          title: Text(c.displayName,
                              style: GoogleFonts.poppins(fontSize: 14)),
                          trailing: value == c
                              ? const Icon(Icons.check_circle,
                                  color: AppColors.primary)
                              : null,
                          onTap: () {
                            onChanged(c);
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateDropdown extends StatelessWidget {
  final List<String> states;
  final String? value;
  final ValueChanged<String?> onChanged;
  const _StateDropdown(
      {required this.states, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by State',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: states
                    .map((s) => ListTile(
                          title: Text(s,
                              style: GoogleFonts.poppins(fontSize: 14)),
                          trailing: value == s
                              ? const Icon(Icons.check_circle,
                                  color: AppColors.primary)
                              : null,
                          onTap: () {
                            onChanged(s);
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Restaurant list card ───────────────────────────────────────────────────────
class _RestaurantListCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  const _RestaurantListCard(
      {required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = restaurant;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 12),
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
        child: Row(
          children: [
            // Image
            SizedBox(
              width: 110,
              height: 110,
              child: CachedNetworkImage(
                imageUrl: r.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.primary.withOpacity(0.1),
                  child: const Center(
                    child: Icon(Icons.restaurant,
                        color: AppColors.primary, size: 32),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.primary.withOpacity(0.1),
                  child: const Center(
                    child: Icon(Icons.restaurant,
                        color: AppColors.primary, size: 32),
                  ),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            r.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy),
                          ),
                        ),
                        // Rating bubble
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
                              const SizedBox(width: 2),
                              Text(
                                r.rating.toStringAsFixed(1),
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
                    const SizedBox(height: 3),
                    Text(
                      r.cuisines
                          .take(2)
                          .map((c) => c.displayName)
                          .join(' • '),
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 11, color: AppColors.textHint),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '${r.city}, ${r.state}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: AppColors.textHint),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            r.priceRange.symbol,
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (r.mustTry.isNotEmpty)
                          Expanded(
                            child: Text(
                              r.mustTry.first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
