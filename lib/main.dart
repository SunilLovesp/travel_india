import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/places_provider.dart';
import 'providers/location_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/trip_provider.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favs = FavoritesProvider();
  await favs.load();
  runApp(TravelIndiaApp(favs: favs));
}

class TravelIndiaApp extends StatelessWidget {
  final FavoritesProvider favs;
  const TravelIndiaApp({super.key, required this.favs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlacesProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider.value(value: favs),
        ChangeNotifierProvider(create: (_) => TripProvider()),
      ],
      child: MaterialApp(
        title: 'Travel India',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const MainScreen(),
      ),
    );
  }
}
