import '../../models/place.dart';

const List<Place> odishaPlaces = [
  Place(
    id: 'puri_konark_od',
    name: 'Puri & Konark',
    nameHindi: 'पुरी और कोणार्क',
    state: 'Odisha',
    shortDescription: 'Jagannath Temple & Sun Temple on Odisha\'s Golden Triangle',
    description: 'Puri is one of the four Hindu Char Dhams — home to the 12th-century Jagannath Temple with its annual Rath Yatra (Chariot Festival) drawing millions. Konark\'s 13th-century Sun Temple (UNESCO) is built in the form of a giant stone chariot for the Sun God.',
    category: PlaceCategory.temple,
    bestSeasons: [Season.winter, Season.autumn],
    latitude: 19.8135, longitude: 85.8312,
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Konark_Sun_Temple.jpg/1280px-Konark_Sun_Temple.jpg',
    rating: 4.7, entryFee: 'Temple: Free, Konark: ₹40', timings: '6:00 AM – 9:00 PM',
    isFeatured: false,
    tags: ['Char Dham', 'Jagannath', 'Sun Temple', 'UNESCO', 'Rath Yatra', 'Beach'],
    nearestCity: 'Bhubaneswar',
    howToReach: 'Bhubaneswar Airport (60 km from Puri). Puri railway station. Buses from Bhubaneswar.',
    attractions: [
      Attraction(
        name: 'Jagannath Temple', nameHindi: 'जगन्नाथ मंदिर',
        description: 'One of the four sacred Char Dhams — 12th-century temple dedicated to Lord Jagannath (a form of Vishnu). Famous for the spectacular Rath Yatra chariot festival every June–July. Non-Hindus cannot enter the inner sanctum.',
        emoji: '🛕', type: 'Char Dham', entryFee: 'Free', timings: '5:00 AM – 11:00 PM',
        latitude: 19.8046, longitude: 85.8180,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Jagannath_Temple_Puri.jpg/1280px-Jagannath_Temple_Puri.jpg',
        activities: ['Pilgrimage', 'Rath Yatra (Jul)', 'Mahaprasad', 'Sea Bath'],
        famousFoods: ['Mahaprasad (temple food)', 'Chenna Poda', 'Khaja', 'Dahi Bara Aloo Dum'],
        vehicleRentals: ['Auto: ₹50–100', 'Taxi: ₹200–400'],
      ),
      Attraction(
        name: 'Konark Sun Temple', nameHindi: 'कोणार्क सूर्य मंदिर',
        description: 'UNESCO World Heritage 13th-century Sun Temple built in the form of a 100-ft chariot with 24 elaborately carved stone wheels pulled by 7 horses. The finest example of Kalinga architecture. A marvel of medieval engineering.',
        emoji: '☀️', type: 'UNESCO Temple', entryFee: '₹40 (Indian), ₹600 (Foreign)', timings: '6:00 AM – 8:00 PM',
        latitude: 19.8876, longitude: 86.0945,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Konark_Sun_Temple.jpg/1280px-Konark_Sun_Temple.jpg',
        activities: ['Heritage Tour', 'Photography', 'Dance Festival (Dec)', 'Architecture Study'],
        famousFoods: ['Chenna Poda', 'Khaja', 'Pakhala Bhata'],
        vehicleRentals: ['Taxi from Puri: ₹600 return', 'Bus: ₹40'],
      ),
    ],
  ),
];
