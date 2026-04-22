import '../../models/place.dart';

const List<Place> assamPlaces = [
  Place(
    id: 'kaziranga_as',
    name: 'Kaziranga National Park',
    nameHindi: 'काजीरंगा राष्ट्रीय उद्यान',
    state: 'Assam',
    shortDescription: 'UNESCO home of the One-Horned Rhinoceros & Assam\'s wild heartland',
    description: 'Kaziranga National Park, a UNESCO World Heritage Site, has two-thirds of the world\'s population of the endangered Indian One-Horned Rhinoceros (2,600+). It also has the world\'s highest density of tigers, plus large populations of wild water buffalo, elephants, gaur, and hundreds of bird species.',
    category: PlaceCategory.wildlife,
    bestSeasons: [Season.winter, Season.autumn],
    latitude: 26.5775, longitude: 93.1696,
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Indian_one-horned_rhinoceros_Kaziranga.jpg/1280px-Indian_one-horned_rhinoceros_Kaziranga.jpg',
    rating: 4.8, entryFee: '₹50 (Indian) + Elephant: ₹900, Jeep: ₹2500', timings: 'Nov–Apr; 5:30–8 AM, 1:30–5 PM',
    isFeatured: true,
    tags: ['One-Horned Rhino', 'UNESCO', 'Elephant Safari', 'Tiger', 'Assam'],
    nearestCity: 'Jorhat',
    howToReach: 'Jorhat Airport (80 km) or Guwahati Airport (230 km). Buses from Guwahati on NH37.',
    attractions: [
      Attraction(
        name: 'Elephant Safari', nameHindi: 'हाथी सफारी',
        description: 'Dawn elephant safari through tall elephant grass offers the best rhino encounter experience. You approach much closer than jeeps can. The Kohora (Central) zone is best for rhinos and tigers.',
        emoji: '🐘', type: 'Safari', entryFee: '₹900/person', timings: '5:30–7:00 AM only',
        latitude: 26.5775, longitude: 93.1696,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Indian_one-horned_rhinoceros_Kaziranga.jpg/1280px-Indian_one-horned_rhinoceros_Kaziranga.jpg',
        activities: ['Elephant Safari', 'Rhino Spotting', 'Tiger Watching', 'Photography'],
        famousFoods: ['Assamese Fish Curry', 'Luchi & Aloo Bhaji', 'Pitha', 'Xaj (rice beer)'],
        vehicleRentals: ['Elephant Safari: ₹900', 'Jeep Safari: ₹2500', 'Book 1 day ahead'],
      ),
    ],
  ),
];
