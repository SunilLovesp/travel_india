import '../../models/place.dart';

const List<Place> uttarPradeshPlaces = [
  Place(
    id: 'agra_up',
    name: 'Agra',
    nameHindi: 'आगरा',
    state: 'Uttar Pradesh',
    shortDescription: 'Home of the Taj Mahal — 3 UNESCO World Heritage Sites',
    description: 'Agra was the capital of the Mughal Empire. It contains three UNESCO World Heritage Sites: Taj Mahal, Agra Fort and Fatehpur Sikri — all within 40 km. The Mughal legacy here is unmatched.',
    category: PlaceCategory.city,
    bestSeasons: [Season.winter, Season.autumn],
    latitude: 27.1767, longitude: 78.0081,
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Taj_Mahal%2C_Agra%2C_India_edit3.jpg/1280px-Taj_Mahal%2C_Agra%2C_India_edit3.jpg',
    rating: 4.9, entryFee: '₹50 Indians / ₹1,100 Foreigners', timings: 'Sunrise–Sunset (Closed Friday)',
    isFeatured: true,
    tags: ['UNESCO', 'Taj Mahal', 'Mughal', 'Wonder of World', 'Golden Triangle'],
    nearestCity: 'Agra',
    howToReach: 'Agra Airport or Delhi Airport (204 km). Gatimaan Express from Delhi (100 min).',
    attractions: [
      Attraction(
        name: 'Taj Mahal', nameHindi: 'ताज महल',
        description: 'Wonder of the World built by Shah Jahan (1632–53) for Mumtaz Mahal. White marble inlaid with 28 types of semi-precious stones. Visit at sunrise for golden light. Full moon nights special.',
        emoji: '🕌', type: 'Heritage Monument', entryFee: '₹50 Indians', timings: 'Sunrise–Sunset (Closed Friday)',
        latitude: 27.1751, longitude: 78.0421,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Taj_Mahal%2C_Agra%2C_India_edit3.jpg/1280px-Taj_Mahal%2C_Agra%2C_India_edit3.jpg',
      ),
      Attraction(
        name: 'Agra Fort', nameHindi: 'आगरा किला',
        description: 'UNESCO fort (1565) in red sandstone. Shah Jahan was imprisoned here by son Aurangzeb with a view of the Taj Mahal. Diwan-i-Am, Jahangiri Mahal, and Musamman Burj are highlights.',
        emoji: '🏯', type: 'Fort', entryFee: '₹50 Indians', timings: '6:00 AM – 6:00 PM',
        latitude: 27.1800, longitude: 78.0219,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Agra_Fort_-_panoramio.jpg/1280px-Agra_Fort_-_panoramio.jpg',
      ),
      Attraction(
        name: 'Fatehpur Sikri', nameHindi: 'फतेहपुर सीकरी',
        description: 'UNESCO ghost city 37 km from Agra — Akbar\'s red sandstone capital abandoned after 14 years. The Buland Darwaza (54m high) is the world\'s largest gateway.',
        emoji: '🏙️', type: 'Heritage City', entryFee: '₹35 Indians', timings: '6:00 AM – 6:00 PM',
        latitude: 27.0945, longitude: 77.6617,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/Fatehpur_Sikri_Mosque.jpg/1280px-Fatehpur_Sikri_Mosque.jpg',
      ),
      Attraction(
        name: 'Mehtab Bagh', nameHindi: 'मेहताब बाग',
        description: 'The "Moonlit Garden" across the Yamuna directly opposite the Taj — the perfect spot for sunset silhouette photos. Legend says Shah Jahan planned a black marble Taj here.',
        emoji: '🌙', type: 'Garden', entryFee: '₹20 Indians', timings: 'Sunrise–Sunset',
        latitude: 27.1812, longitude: 78.0421,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/m/me/Mehtab_Bagh_Agra.jpg/1280px-Mehtab_Bagh_Agra.jpg',
      ),
    ],
  ),
];
