import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../data/places_data.dart';
import '../state_places/state_places_screen.dart';

class _StateInfo {
  final String name;
  final String emoji;
  final Color color;
  const _StateInfo(this.name, this.emoji, this.color);
}

const List<_StateInfo> _allStates = [
  _StateInfo('Himachal Pradesh',          '🏔️', Color(0xFF1565C0)),
  _StateInfo('Jammu & Kashmir',           '❄️', Color(0xFF4527A0)),
  _StateInfo('Ladakh',                    '🏜️', Color(0xFF6D4C41)),
  _StateInfo('Uttarakhand',               '🕉️', Color(0xFF2E7D32)),
  _StateInfo('Rajasthan',                 '🏯', Color(0xFFE65100)),
  _StateInfo('Punjab',                    '🌾', Color(0xFFF57F17)),
  _StateInfo('Delhi',                     '🇮🇳', Color(0xFFB71C1C)),
  _StateInfo('Uttar Pradesh',             '🕌', Color(0xFF6A1B9A)),
  _StateInfo('Goa',                       '🏖️', Color(0xFF00838F)),
  _StateInfo('Maharashtra',               '🏙️', Color(0xFFBF360C)),
  _StateInfo('Gujarat',                   '🦁', Color(0xFFEF6C00)),
  _StateInfo('Karnataka',                 '🏛️', Color(0xFFAD1457)),
  _StateInfo('Kerala',                    '🌴', Color(0xFF00695C)),
  _StateInfo('Tamil Nadu',                '🛕', Color(0xFF880E4F)),
  _StateInfo('Andaman & Nicobar Islands', '🐠', Color(0xFF00796B)),
  _StateInfo('West Bengal',               '🐅', Color(0xFF1B5E20)),
  _StateInfo('Odisha',                    '☀️', Color(0xFFE65100)),
  _StateInfo('Madhya Pradesh',            '🐆', Color(0xFF4A148C)),
  _StateInfo('Telangana',                 '🕌', Color(0xFF006064)),
  _StateInfo('Bihar',                     '🌳', Color(0xFF33691E)),
  _StateInfo('Assam',                     '🦏', Color(0xFF1A237E)),
  _StateInfo('Meghalaya',                 '💦', Color(0xFF006064)),
  _StateInfo('Sikkim',                    '🏔️', Color(0xFF4527A0)),
  _StateInfo('Andhra Pradesh',            '🐬', Color(0xFF0277BD)),
  _StateInfo('Chhattisgarh',              '🌿', Color(0xFF558B2F)),
  _StateInfo('Jharkhand',                 '⛏️', Color(0xFF4E342E)),
  _StateInfo('Haryana',                   '🌻', Color(0xFF9E9D24)),
  _StateInfo('Arunachal Pradesh',         '🦅', Color(0xFF00695C)),
  _StateInfo('Manipur',                   '🌺', Color(0xFFC62828)),
  _StateInfo('Nagaland',                  '🦅', Color(0xFF37474F)),
  _StateInfo('Mizoram',                   '🌄', Color(0xFF283593)),
  _StateInfo('Tripura',                   '🏛️', Color(0xFF6A1B9A)),
];

class AllStatesScreen extends StatefulWidget {
  const AllStatesScreen({super.key});

  @override
  State<AllStatesScreen> createState() => _AllStatesScreenState();
}

class _AllStatesScreenState extends State<AllStatesScreen> {
  String _search = '';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allStates
        .where((s) => s.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('All States & UTs',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            Text('Explore every corner of India',
                style: GoogleFonts.poppins(
                    fontSize: 10, color: Colors.white70)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: TextField(
              controller: _controller,
              onChanged: (v) => setState(() => _search = v),
              style: GoogleFonts.poppins(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search state...',
                hintStyle:
                    GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _search = '');
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
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ),
          ),

          // Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.82,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final s = filtered[i];
                final count = allPlaces
                    .where((p) => p.state == s.name)
                    .length;
                final hasPlaces = count > 0;

                return GestureDetector(
                  onTap: hasPlaces
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StatePlacesScreen(stateName: s.name),
                            ),
                          )
                      : null,
                  child: Container(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: s.color.withOpacity(0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: s.color.withOpacity(0.25), width: 1.5),
                          ),
                          child: Center(
                            child: Text(s.emoji,
                                style: const TextStyle(fontSize: 24)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            s.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: hasPlaces
                                    ? AppColors.textPrimary
                                    : Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: hasPlaces
                                ? s.color.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            hasPlaces ? '$count places' : 'Coming soon',
                            style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: hasPlaces ? s.color : Colors.grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
