import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../../data/places_data.dart';
import '../state_places/state_places_screen.dart';

class _StateInfo {
  final String name;
  final String nameHindi;
  final String emoji;
  final double lat;
  final double lng;
  final Color color;

  const _StateInfo({
    required this.name,
    required this.nameHindi,
    required this.emoji,
    required this.lat,
    required this.lng,
    required this.color,
  });
}

const _states = [
  _StateInfo(name: 'Himachal Pradesh', nameHindi: 'हिमाचल प्रदेश', emoji: '🏔️', lat: 31.9, lng: 77.1, color: Color(0xFF1565C0)),
  _StateInfo(name: 'Rajasthan', nameHindi: 'राजस्थान', emoji: '🏜️', lat: 27.0, lng: 74.2, color: Color(0xFFE65100)),
  _StateInfo(name: 'Uttarakhand', nameHindi: 'उत्तराखंड', emoji: '🕉️', lat: 30.3, lng: 79.5, color: Color(0xFF2E7D32)),
  _StateInfo(name: 'Kerala', nameHindi: 'केरल', emoji: '🌴', lat: 10.8, lng: 76.2, color: Color(0xFF00695C)),
  _StateInfo(name: 'Goa', nameHindi: 'गोवा', emoji: '🏖️', lat: 15.3, lng: 74.1, color: Color(0xFF00838F)),
  _StateInfo(name: 'Jammu & Kashmir', nameHindi: 'जम्मू-कश्मीर', emoji: '❄️', lat: 34.0, lng: 74.7, color: Color(0xFF4527A0)),
  _StateInfo(name: 'Uttar Pradesh', nameHindi: 'उत्तर प्रदेश', emoji: '🕌', lat: 26.8, lng: 80.9, color: Color(0xFF6A1B9A)),
  _StateInfo(name: 'Karnataka', nameHindi: 'कर्नाटक', emoji: '🏛️', lat: 14.5, lng: 75.7, color: Color(0xFFAD1457)),
  _StateInfo(name: 'Andaman & Nicobar', nameHindi: 'अंडमान-निकोबार', emoji: '🐠', lat: 11.7, lng: 92.6, color: Color(0xFF00796B)),
  _StateInfo(name: 'Punjab', nameHindi: 'पंजाब', emoji: '🌾', lat: 31.1, lng: 75.3, color: Color(0xFFF57F17)),
  _StateInfo(name: 'Maharashtra', nameHindi: 'महाराष्ट्र', emoji: '🏙️', lat: 19.7, lng: 75.7, color: Color(0xFFBF360C)),
  _StateInfo(name: 'Tamil Nadu', nameHindi: 'तमिलनाडु', emoji: '🛕', lat: 11.1, lng: 78.6, color: Color(0xFF880E4F)),
  _StateInfo(name: 'Gujarat', nameHindi: 'गुजरात', emoji: '🦁', lat: 22.2, lng: 71.1, color: Color(0xFFE65100)),
  _StateInfo(name: 'West Bengal', nameHindi: 'पश्चिम बंगाल', emoji: '🐅', lat: 23.0, lng: 87.8, color: Color(0xFF1B5E20)),
  _StateInfo(name: 'Madhya Pradesh', nameHindi: 'मध्य प्रदेश', emoji: '🏯', lat: 23.5, lng: 78.6, color: Color(0xFF4A148C)),
  _StateInfo(name: 'Odisha', nameHindi: 'ओडिशा', emoji: '☀️', lat: 20.9, lng: 85.0, color: Color(0xFFE65100)),
  _StateInfo(name: 'Telangana', nameHindi: 'तेलंगाना', emoji: '🕌', lat: 18.1, lng: 79.0, color: Color(0xFF006064)),
  _StateInfo(name: 'Bihar', nameHindi: 'बिहार', emoji: '🌳', lat: 25.0, lng: 85.3, color: Color(0xFF33691E)),
  _StateInfo(name: 'Assam', nameHindi: 'असम', emoji: '🦏', lat: 26.2, lng: 92.9, color: Color(0xFF1A237E)),
  _StateInfo(name: 'Meghalaya', nameHindi: 'मेघालय', emoji: '💦', lat: 25.4, lng: 91.3, color: Color(0xFF006064)),
  _StateInfo(name: 'Sikkim', nameHindi: 'सिक्किम', emoji: '🏔️', lat: 27.5, lng: 88.5, color: Color(0xFF4527A0)),
  _StateInfo(name: 'Delhi', nameHindi: 'दिल्ली', emoji: '🇮🇳', lat: 28.6, lng: 77.2, color: Color(0xFFB71C1C)),
];

class IndiaMapScreen extends StatefulWidget {
  const IndiaMapScreen({super.key});

  @override
  State<IndiaMapScreen> createState() => _IndiaMapScreenState();
}

class _IndiaMapScreenState extends State<IndiaMapScreen> {
  final MapController _mapController = MapController();
  _StateInfo? _selectedState;

  void _onStateTap(_StateInfo state) {
    final hasPlaces = allPlaces.any(
        (p) => p.state.toLowerCase() == state.name.toLowerCase());
    if (!hasPlaces) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coming soon: ${state.name}',
              style: GoogleFonts.poppins()),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _selectedState = state);
    _mapController.move(LatLng(state.lat, state.lng), 7.0);
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StatePlacesScreen(stateName: state.name),
        ),
      ).then((_) => setState(() => _selectedState = null));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(22.5, 82.0),
              initialZoom: 4.5,
              minZoom: 3.5,
              maxZoom: 10.0,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.travelapp.travel_india',
              ),
              MarkerLayer(
                markers: _states.map((state) {
                  final isSelected = _selectedState?.name == state.name;
                  final hasPlaces = allPlaces.any(
                      (p) => p.state.toLowerCase() == state.name.toLowerCase());
                  return Marker(
                    point: LatLng(state.lat, state.lng),
                    width: isSelected ? 120 : 100,
                    height: isSelected ? 60 : 50,
                    child: GestureDetector(
                      onTap: () => _onStateTap(state),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? state.color
                              : (hasPlaces ? state.color.withOpacity(0.9) : Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: state.color.withOpacity(0.4),
                              blurRadius: isSelected ? 12 : 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.emoji,
                                style: TextStyle(fontSize: isSelected ? 16 : 14)),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                state.nameHindi,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: isSelected ? 9 : 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Top header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                bottom: 12,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  const Text('🇮🇳', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Incredible India',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      Text('अतुल्य भारत • Tap a state to explore',
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom state chips
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: _states.length,
                itemBuilder: (_, i) {
                  final state = _states[i];
                  final isSelected = _selectedState?.name == state.name;
                  return GestureDetector(
                    onTap: () => _onStateTap(state),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? state.color : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: isSelected
                            ? null
                            : Border.all(color: state.color.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.emoji,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            state.name.split(' ').first,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : state.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
    );
  }
}
