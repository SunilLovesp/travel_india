import '../../models/place.dart';

const List<Place> telanganaPlaces = [
  Place(
    id: 'hyderabad_ts',
    name: 'Hyderabad',
    nameHindi: 'हैदराबाद',
    state: 'Telangana',
    shortDescription: 'City of Nizams — Charminar, Biryani & Pearl of the South',
    description: 'Hyderabad, the "Pearl City" and "City of Nawabs", blends Mughal history with a booming tech industry. Founded in 1591, it is famous for Charminar, the magnificent Golconda Fort, world-renowned Hyderabadi Biryani, pearl and bangle markets, and its unique Deccani culture.',
    category: PlaceCategory.city,
    bestSeasons: [Season.winter, Season.autumn],
    latitude: 17.3850, longitude: 78.4867,
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Charminar_7.jpg/1280px-Charminar_7.jpg',
    rating: 4.5, entryFee: 'Free', timings: 'Open all day',
    isFeatured: false,
    tags: ['Biryani', 'Charminar', 'Nizams', 'Pearls', 'Heritage', 'Tech City'],
    nearestCity: 'Hyderabad',
    howToReach: 'Rajiv Gandhi International Airport. Well connected by rail, road, and metro.',
    attractions: [
      Attraction(
        name: 'Charminar', nameHindi: 'चारमीनार',
        description: 'The iconic 16th-century mosque built in 1591 by Muhammad Quli Qutb Shah to commemorate the end of a plague. Four ornate minarets rise 56m. Surrounded by vibrant bazaars selling bangles, perfumes and biryani.',
        emoji: '🕌', type: 'Monument', entryFee: '₹25', timings: '9:30 AM – 5:30 PM',
        latitude: 17.3616, longitude: 78.4747,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Charminar_7.jpg/1280px-Charminar_7.jpg',
        activities: ['Sightseeing', 'Bangle Shopping', 'Street Food', 'Photography'],
        famousFoods: ['Hyderabadi Biryani', 'Haleem', 'Irani Chai', 'Osmania Biscuits'],
        vehicleRentals: ['Auto: ₹50–200', 'Metro: ₹20–40', 'Cab: ₹100–300'],
      ),
      Attraction(
        name: 'Golconda Fort', nameHindi: 'गोलकुंडा किला',
        description: 'Magnificent 16th-century fort famous for its unique acoustic system — a clap at the entrance can be heard at the top 1 km away. Once the diamond mining capital of the world (Koh-i-Noor and Hope Diamond originated here).',
        emoji: '🏯', type: 'Fort', entryFee: '₹15 (Indian), ₹200 (Foreign)', timings: '8:00 AM – 5:30 PM',
        latitude: 17.3833, longitude: 78.4011,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Golconda_fort.jpg/1280px-Golconda_fort.jpg',
        activities: ['Fort Walk', 'Acoustic Clap Test', 'Sound & Light Show', 'Panoramic Views'],
        famousFoods: ['Biryani', 'Haleem', 'Mirchi ka Salan'],
        vehicleRentals: ['Auto: ₹150–300', 'Cab from old city: ₹250–400'],
      ),
    ],
  ),
];
