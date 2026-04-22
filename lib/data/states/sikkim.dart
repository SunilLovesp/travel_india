import '../../models/place.dart';

const List<Place> sikkimPlaces = [
  Place(
    id: 'sikkim_sk',
    name: 'Sikkim — Gangtok & Tsomgo',
    nameHindi: 'सिक्किम — गंगटोक और त्सोमगो',
    state: 'Sikkim',
    shortDescription: 'Himalayan kingdom — Buddhist monasteries, yak rides & Tsomgo Lake',
    description: 'Sikkim is India\'s smallest state and a Himalayan paradise of Buddhist monasteries, rhododendron forests, and snow peaks. Gangtok, the capital, offers stunning views of Kangchenjunga. Tsomgo (Changu) Lake at 3,753m changes colour with the seasons. The state is famously clean, eco-friendly, and completely organic.',
    category: PlaceCategory.hillStation,
    bestSeasons: [Season.summer, Season.autumn],
    latitude: 27.3389, longitude: 88.6065,
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Tsomgo_Lake_Sikkim.jpg/1280px-Tsomgo_Lake_Sikkim.jpg',
    rating: 4.7, entryFee: 'Permit required (₹100)', timings: 'Open all day',
    isFeatured: false,
    tags: ['Buddhist', 'Monasteries', 'Tsomgo Lake', 'Kangchenjunga', 'Organic State'],
    nearestCity: 'Gangtok',
    howToReach: 'Bagdogra Airport (124 km). Shared taxis from Siliguri (4 hrs). ILP required for some areas.',
    attractions: [
      Attraction(
        name: 'Tsomgo (Changu) Lake', nameHindi: 'त्सोमगो झील',
        description: 'Sacred glacial lake at 3,753m, 40 km from Gangtok. Changes colour seasonally — green in summer, azure in autumn, frozen white in winter. Yak rides around the lake are iconic. Inner Line Permit required.',
        emoji: '🏔️', type: 'Lake', entryFee: '₹100 (permit)', timings: 'Open all day',
        latitude: 27.3742, longitude: 88.7696,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Tsomgo_Lake_Sikkim.jpg/1280px-Tsomgo_Lake_Sikkim.jpg',
        activities: ['Yak Riding', 'Photography', 'Lake Walk', 'Snowfall (winter)'],
        famousFoods: ['Thukpa', 'Gundruk', 'Momos', 'Butter Tea'],
        vehicleRentals: ['Jeep from Gangtok: ₹1500 return', 'Shared taxi: ₹400/person', 'Yak: ₹200/ride'],
      ),
      Attraction(
        name: 'Rumtek Monastery', nameHindi: 'रुमटेक मठ',
        description: 'One of the largest Buddhist monasteries outside Tibet, seat of the Kagyu lineage. Located 24 km from Gangtok with stunning mountain views. The four-storey golden dharma chakra is especially beautiful at dusk.',
        emoji: '🛕', type: 'Monastery', entryFee: 'Free', timings: '6:00 AM – 6:00 PM',
        latitude: 27.3044, longitude: 88.5333,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Rumtek_Monastery_Sikkim.jpg/1280px-Rumtek_Monastery_Sikkim.jpg',
        activities: ['Monastery Visit', 'Meditation', 'Photography', 'Buddhist Culture'],
        famousFoods: ['Momos', 'Thukpa', 'Sel Roti'],
        vehicleRentals: ['Taxi from Gangtok: ₹600 return'],
      ),
    ],
  ),
];
