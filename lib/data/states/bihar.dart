import '../../models/place.dart';

const List<Place> biharPlaces = [
  Place(
    id: 'bodhgaya_br',
    name: 'Bodh Gaya & Nalanda',
    nameHindi: 'बोधगया और नालंदा',
    state: 'Bihar',
    shortDescription: 'Where Buddha attained enlightenment — holiest Buddhist site on Earth',
    description: 'Bodh Gaya is the most sacred site in Buddhism — the Bodhi Tree under which Siddhartha Gautama attained enlightenment 2,500 years ago still stands here. The Mahabodhi Temple Complex is a UNESCO World Heritage Site. Nearby Nalanda was the world\'s first great university (5th–12th century AD).',
    category: PlaceCategory.temple,
    bestSeasons: [Season.winter, Season.autumn],
    latitude: 24.6961, longitude: 84.9910,
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Mahabodhi_Temple_Bodh_Gaya.jpg/1280px-Mahabodhi_Temple_Bodh_Gaya.jpg',
    rating: 4.8, entryFee: 'Free', timings: 'Temple: 5:00 AM – 9:00 PM',
    isFeatured: false,
    tags: ['Buddhism', 'Enlightenment', 'UNESCO', 'Pilgrimage', 'Bodhi Tree'],
    nearestCity: 'Gaya',
    howToReach: 'Gaya Airport (17 km). Gaya railway station (16 km). Buses from Patna (130 km).',
    attractions: [
      Attraction(
        name: 'Mahabodhi Temple & Bodhi Tree', nameHindi: 'महाबोधि मंदिर',
        description: 'UNESCO World Heritage Site — the 55m spire marks the spot of Buddha\'s enlightenment under the sacred Bodhi Tree (Ficus religiosa). Pilgrims from Japan, Tibet, Thailand, and Sri Lanka meditate here constantly.',
        emoji: '🌳', type: 'UNESCO Pilgrimage', entryFee: 'Free', timings: '5:00 AM – 9:00 PM',
        latitude: 24.6961, longitude: 84.9910,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Mahabodhi_Temple_Bodh_Gaya.jpg/1280px-Mahabodhi_Temple_Bodh_Gaya.jpg',
        activities: ['Meditation', 'Prayer', 'Pilgrimage Walk', 'Monastery Visits', 'Photography'],
        famousFoods: ['Litti Chokha', 'Dal Puri', 'Sattu Paratha', 'Rice & Dal'],
        vehicleRentals: ['Auto: ₹50–150 from Gaya', 'E-Rickshaw: ₹20–50', 'Taxi: ₹500 from Gaya'],
      ),
      Attraction(
        name: 'Nalanda University Ruins', nameHindi: 'नालंदा विश्वविद्यालय अवशेष',
        description: 'UNESCO World Heritage ruins of the ancient Nalanda University, which taught 10,000+ students from across Asia (5th–12th century). The vast monastic complex includes temples, dormitories, and libraries. Nalanda Museum displays excavated artefacts.',
        emoji: '📚', type: 'Archaeological Site', entryFee: '₹15 (Indian), ₹200 (Foreign)', timings: '9:00 AM – 5:00 PM (closed Fri)',
        latitude: 25.1353, longitude: 85.4439,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Nalanda_University.jpg/1280px-Nalanda_University.jpg',
        activities: ['Heritage Walk', 'Photography', 'Museum Visit', 'Meditation'],
        famousFoods: ['Litti Chokha', 'Til Barfi', 'Thekua'],
        vehicleRentals: ['Taxi from Bodh Gaya: ₹1200', 'Bus from Rajgir: ₹30'],
      ),
    ],
  ),
];
