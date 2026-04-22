import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../data/activities_data.dart';
import '../../data/places_data.dart';
import '../../models/activity.dart';
import '../../models/place.dart';
import '../../models/trip.dart';
import '../../providers/trip_provider.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;
  const TripDetailScreen({super.key, required this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late Trip _trip;
  final Set<int> _expandedDays = {0};

  @override
  void initState() {
    super.initState();
    _trip = widget.trip;
  }

  void _saveTrip() {
    context.read<TripProvider>().updateTrip(_trip);
  }

  void _shareTrip() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Share Trip',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.navy)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📤', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              '"${_trip.title}" would be shared with friends and family.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _addPlaceToDay(int dayIndex) {
    final places = allPlaces.take(20).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Add a Place',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy)),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: places.length,
                itemBuilder: (ctx, i) {
                  final p = places[i];
                  final alreadyAdded =
                      _trip.days[dayIndex].placeIds.contains(p.id);
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(p.category.emoji,
                            style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    title: Text(p.name,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy)),
                    subtitle: Text('${p.nearestCity}, ${p.state}',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.textSecondary)),
                    trailing: alreadyAdded
                        ? const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 20)
                        : Icon(Icons.add_circle_outline,
                            color: Colors.grey.shade400, size: 20),
                    onTap: alreadyAdded
                        ? null
                        : () {
                            setState(() {
                              final updatedDay = _trip.days[dayIndex].copyWith(
                                placeIds: [
                                  ..._trip.days[dayIndex].placeIds,
                                  p.id,
                                ],
                              );
                              final updatedDays =
                                  List<TripDay>.from(_trip.days);
                              updatedDays[dayIndex] = updatedDay;
                              _trip = Trip(
                                id: _trip.id,
                                title: _trip.title,
                                destination: _trip.destination,
                                totalDays: _trip.totalDays,
                                days: updatedDays,
                                createdAt: _trip.createdAt,
                              );
                            });
                            _saveTrip();
                            Navigator.pop(context);
                          },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addActivityToDay(int dayIndex) {
    final activities = allActivities.take(20).toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Add an Activity',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy)),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: activities.length,
                itemBuilder: (ctx, i) {
                  final a = activities[i];
                  final alreadyAdded =
                      _trip.days[dayIndex].activityIds.contains(a.id);
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(a.category.emoji,
                            style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    title: Text(a.name,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy)),
                    subtitle: Text('${a.city} • ${a.pricePerPerson}',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.textSecondary)),
                    trailing: alreadyAdded
                        ? const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 20)
                        : Icon(Icons.add_circle_outline,
                            color: Colors.grey.shade400, size: 20),
                    onTap: alreadyAdded
                        ? null
                        : () {
                            setState(() {
                              final updatedDay = _trip.days[dayIndex].copyWith(
                                activityIds: [
                                  ..._trip.days[dayIndex].activityIds,
                                  a.id,
                                ],
                              );
                              final updatedDays =
                                  List<TripDay>.from(_trip.days);
                              updatedDays[dayIndex] = updatedDay;
                              _trip = Trip(
                                id: _trip.id,
                                title: _trip.title,
                                destination: _trip.destination,
                                totalDays: _trip.totalDays,
                                days: updatedDays,
                                createdAt: _trip.createdAt,
                              );
                            });
                            _saveTrip();
                            Navigator.pop(context);
                          },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 16),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: _shareTrip,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 36),
                        Text(
                          _trip.title,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.white70, size: 13),
                            const SizedBox(width: 3),
                            Text(_trip.destination,
                                style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 12)),
                            const SizedBox(width: 10),
                            const Icon(Icons.calendar_today,
                                color: Colors.white70, size: 13),
                            const SizedBox(width: 3),
                            Text(
                                '${_trip.totalDays} day${_trip.totalDays == 1 ? '' : 's'}',
                                style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _DayCard(
                  day: _trip.days[i],
                  isExpanded: _expandedDays.contains(i),
                  onToggle: () => setState(() {
                    if (_expandedDays.contains(i)) {
                      _expandedDays.remove(i);
                    } else {
                      _expandedDays.add(i);
                    }
                  }),
                  onAddPlace: () => _addPlaceToDay(i),
                  onAddActivity: () => _addActivityToDay(i),
                  onUpdateNotes: (notes) {
                    setState(() {
                      final updatedDay =
                          _trip.days[i].copyWith(notes: notes);
                      final updatedDays = List<TripDay>.from(_trip.days);
                      updatedDays[i] = updatedDay;
                      _trip = Trip(
                        id: _trip.id,
                        title: _trip.title,
                        destination: _trip.destination,
                        totalDays: _trip.totalDays,
                        days: updatedDays,
                        createdAt: _trip.createdAt,
                      );
                    });
                    _saveTrip();
                  },
                ),
                childCount: _trip.days.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatefulWidget {
  final TripDay day;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAddPlace;
  final VoidCallback onAddActivity;
  final ValueChanged<String> onUpdateNotes;

  const _DayCard({
    required this.day,
    required this.isExpanded,
    required this.onToggle,
    required this.onAddPlace,
    required this.onAddActivity,
    required this.onUpdateNotes,
  });

  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.day.notes);
  }

  @override
  void didUpdateWidget(_DayCard old) {
    super.didUpdateWidget(old);
    if (old.day.notes != widget.day.notes &&
        widget.day.notes != _notesController.text) {
      _notesController.text = widget.day.notes;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.day;
    final placesForDay = allPlaces
        .where((p) => d.placeIds.contains(p.id))
        .toList();
    final activitiesForDay = allActivities
        .where((a) => d.activityIds.contains(a.id))
        .toList();
    final itemCount = placesForDay.length + activitiesForDay.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header tap to expand
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            onTap: widget.onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${d.dayNumber}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Day ${d.dayNumber}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          itemCount == 0
                              ? 'Nothing planned yet'
                              : '$itemCount item${itemCount == 1 ? '' : 's'} planned',
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    widget.isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (widget.isExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade100),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Places
                  if (placesForDay.isNotEmpty) ...[
                    const _SubSectionLabel(icon: Icons.place_outlined, label: 'Places'),
                    const SizedBox(height: 6),
                    ...placesForDay.map(
                      (p) => _ItemRow(
                        emoji: p.category.emoji,
                        title: p.name,
                        subtitle: '${p.nearestCity}, ${p.state}',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Activities
                  if (activitiesForDay.isNotEmpty) ...[
                    const _SubSectionLabel(icon: Icons.bolt_outlined, label: 'Activities'),
                    const SizedBox(height: 6),
                    ...activitiesForDay.map(
                      (a) => _ItemRow(
                        emoji: a.category.emoji,
                        title: a.name,
                        subtitle: '${a.city} • ${a.duration}',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Add buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: widget.onAddPlace,
                          icon: const Icon(Icons.add, size: 14),
                          label: Text('Add Place',
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: widget.onAddActivity,
                          icon: const Icon(Icons.add, size: 14),
                          label: Text('Add Activity',
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Notes
                  const _SubSectionLabel(icon: Icons.notes_outlined, label: 'Notes'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    onChanged: widget.onUpdateNotes,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Add notes for this day…',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textHint),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubSectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SubSectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.primary),
        const SizedBox(width: 5),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary)),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  const _ItemRow(
      {required this.emoji, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy)),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: AppColors.textHint)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
