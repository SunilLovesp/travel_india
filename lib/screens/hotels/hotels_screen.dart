import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../data/hotels_data.dart';
import '../../models/hotel.dart';
import 'hotel_detail_screen.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final _searchController = TextEditingController();
  HotelType? _selectedType;
  int? _minStars;
  String? _selectedState;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Hotel> get _filtered {
    return allHotels.where((h) {
      final q = _query.toLowerCase();
      final matchesSearch = q.isEmpty ||
          h.name.toLowerCase().contains(q) ||
          h.city.toLowerCase().contains(q) ||
          h.state.toLowerCase().contains(q);
      final matchesType = _selectedType == null || h.type == _selectedType;
      final matchesStars =
          _minStars == null || h.starRating >= _minStars!;
      final matchesState =
          _selectedState == null || h.state == _selectedState;
      return matchesSearch && matchesType && matchesStars && matchesState;
    }).toList();
  }

  List<String> get _states {
    final states = allHotels.map((h) => h.state).toSet().toList()..sort();
    return states;
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Hotels & Stays',
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
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search hotels, cities, states…',
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
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(
                        label: _selectedType == null
                            ? 'Type'
                            : _selectedType!.displayName,
                        selected: _selectedType != null,
                        onClear: () => setState(() => _selectedType = null),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          builder: (_) => _TypeSheet(
                            value: _selectedType,
                            onChanged: (v) {
                              setState(() => _selectedType = v);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: _minStars == null
                            ? 'Stars'
                            : '${'★' * _minStars!}+',
                        selected: _minStars != null,
                        onClear: () => setState(() => _minStars = null),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          builder: (_) => _StarsSheet(
                            value: _minStars,
                            onChanged: (v) {
                              setState(() => _minStars = v);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: _selectedState ?? 'State',
                        selected: _selectedState != null,
                        onClear: () =>
                            setState(() => _selectedState = null),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          builder: (_) => _StateSheet(
                            states: _states,
                            value: _selectedState,
                            onChanged: (v) {
                              setState(() => _selectedState = v);
                              Navigator.pop(context);
                            },
                          ),
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
                  '${results.length} properties',
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
                        const Icon(Icons.hotel,
                            size: 56, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        Text('No hotels found',
                            style: GoogleFonts.poppins(
                                color: AppColors.textHint, fontSize: 15)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: results.length,
                    itemBuilder: (_, i) => _HotelListCard(
                      hotel: results[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HotelDetailScreen(hotel: results[i]),
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

// ── Filter chip ───────────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onClear;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onClear,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.12)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
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

class _TypeSheet extends StatelessWidget {
  final HotelType? value;
  final ValueChanged<HotelType?> onChanged;
  const _TypeSheet({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Type',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: HotelType.values
                    .map((t) => ListTile(
                          title: Text(t.displayName,
                              style: GoogleFonts.poppins(fontSize: 14)),
                          trailing: value == t
                              ? const Icon(Icons.check_circle,
                                  color: AppColors.primary)
                              : null,
                          onTap: () => onChanged(t),
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

class _StarsSheet extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;
  const _StarsSheet({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Minimum Star Rating',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...[3, 4, 5].map((s) => ListTile(
                title: Text(
                  '${'★' * s} ($s star${s > 1 ? 's' : ''} & above)',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                trailing: value == s
                    ? const Icon(Icons.check_circle,
                        color: AppColors.primary)
                    : null,
                onTap: () => onChanged(s),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _StateSheet extends StatelessWidget {
  final List<String> states;
  final String? value;
  final ValueChanged<String?> onChanged;
  const _StateSheet(
      {required this.states, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
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
                          onTap: () => onChanged(s),
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

// ── Hotel list card ────────────────────────────────────────────────────────────
class _HotelListCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback onTap;
  const _HotelListCard({required this.hotel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final h = hotel;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: h.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 160,
                    color: AppColors.navy.withOpacity(0.1),
                    child: const Center(
                      child: Icon(Icons.hotel,
                          color: AppColors.navy, size: 40),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 160,
                    color: AppColors.navy.withOpacity(0.1),
                    child: const Center(
                      child: Icon(Icons.hotel,
                          color: AppColors.navy, size: 40),
                    ),
                  ),
                ),
                // Type badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.navy.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(h.type.displayName,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                // Price badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${h.pricePerNight}/night',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          h.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy),
                        ),
                      ),
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
                              h.rating.toStringAsFixed(1),
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
                  const SizedBox(height: 4),
                  // Star rating
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < h.starRating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 14,
                          color: i < h.starRating
                              ? AppColors.ratingYellow
                              : Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${h.reviewCount} reviews',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.textHint),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 11, color: AppColors.textHint),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          '${h.city}, ${h.state}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: AppColors.textHint),
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
