import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/trip.dart';
import '../../providers/trip_provider.dart';
import 'trip_detail_screen.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _destinationController = TextEditingController();
  int _days = 5;

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _createTrip() {
    if (!_formKey.currentState!.validate()) return;

    final days = List.generate(
      _days,
      (i) => TripDay(dayNumber: i + 1),
    );

    final trip = Trip(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      title: _nameController.text.trim(),
      destination: _destinationController.text.trim(),
      totalDays: _days,
      days: days,
      createdAt: DateTime.now(),
    );

    context.read<TripProvider>().addTrip(trip);

    // Navigate to the detail screen replacing this screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TripDetailScreen(trip: trip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Create a Trip',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: AppColors.navy)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.navy),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text('🗺️', style: TextStyle(fontSize: 52)),
                    const SizedBox(height: 10),
                    Text(
                      'Plan Your Perfect Trip',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Build a day-by-day itinerary',
                      style: GoogleFonts.poppins(
                          color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const _FieldLabel('Trip Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g. Goa Family Vacation 2025',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textHint),
                  prefixIcon: const Icon(Icons.edit_outlined,
                      color: AppColors.textHint, size: 18),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a trip name' : null,
              ),

              const SizedBox(height: 20),

              const _FieldLabel('Destination'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _destinationController,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g. Goa, Rajasthan, Kerala',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textHint),
                  prefixIcon: const Icon(Icons.location_on_outlined,
                      color: AppColors.textHint, size: 18),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a destination' : null,
              ),

              const SizedBox(height: 24),

              const _FieldLabel('Duration'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$_days day${_days == 1 ? '' : 's'}',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        Row(
                          children: [
                            _DayButton(
                              icon: Icons.remove,
                              onTap: _days > 1
                                  ? () => setState(() => _days--)
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            _DayButton(
                              icon: Icons.add,
                              onTap: _days < 30
                                  ? () => setState(() => _days++)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: AppColors.primary,
                        thumbColor: AppColors.primary,
                        inactiveTrackColor: Colors.grey.shade200,
                        overlayColor: AppColors.primary.withOpacity(0.1),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: _days.toDouble(),
                        min: 1,
                        max: 30,
                        divisions: 29,
                        onChanged: (v) => setState(() => _days = v.round()),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('1 day',
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: AppColors.textHint)),
                        Text('30 days',
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: AppColors.textHint)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _createTrip,
                  icon: const Icon(Icons.rocket_launch_outlined, size: 20),
                  label: Text(
                    'Start Planning',
                    style:
                        GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary),
    );
  }
}

class _DayButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _DayButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: onTap != null
                ? AppColors.primary.withOpacity(0.3)
                : Colors.grey.shade200,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? AppColors.primary : Colors.grey.shade400,
        ),
      ),
    );
  }
}
