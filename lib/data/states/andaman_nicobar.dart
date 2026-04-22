import '../../models/place.dart';

const List<Place> andamanPlaces = [
  Place(
    id: 'andaman_islands',
    name: 'Andaman Islands',
    nameHindi: 'अंडमान द्वीप',
    state: 'Andaman & Nicobar Islands',
    shortDescription: 'Pristine tropical islands — coral reefs, turquoise waters & history',
    description: 'The Andaman archipelago is one of India\'s most stunning destinations. From Asia\'s best beach (Radhanagar) to the historic Cellular Jail, and from world-class scuba diving to bioluminescent plankton — the Andamans offer experiences found nowhere else in India.',
    category: PlaceCategory.beach,
    bestSeasons: [Season.winter, Season.autumn],
    latitude: 11.7401, longitude: 92.6586,
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/Radhanagar_Beach_Havelock_Andaman.jpg/1280px-Radhanagar_Beach_Havelock_Andaman.jpg',
    rating: 4.9, entryFee: 'Various', timings: 'Open all day',
    isFeatured: true,
    tags: ['Beaches', 'Scuba', 'Coral', 'Pristine', 'Island'],
    nearestCity: 'Port Blair',
    howToReach: 'Fly to Veer Savarkar Airport, Port Blair. Ferries to Havelock (2 hrs).',
    attractions: [
      Attraction(
        name: 'Radhanagar Beach (Beach No. 7)', nameHindi: 'राधानगर बीच',
        description: 'Consistently voted Asia\'s best beach — powder-white sand, turquoise water, and dense tropical forest backdrop. Turtles nest here. Sunset is extraordinary. No water sports to preserve its purity.',
        emoji: '🏖️', type: 'Beach', entryFee: 'Free', timings: '5:00 AM – 7:00 PM',
        latitude: 11.9830, longitude: 92.9400,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/Radhanagar_Beach_Havelock_Andaman.jpg/1280px-Radhanagar_Beach_Havelock_Andaman.jpg',
      ),
      Attraction(
        name: 'Cellular Jail (Kala Pani)', nameHindi: 'सेलुलर जेल',
        description: 'The British "Black Waters" prison where Indian freedom fighters including Veer Savarkar were incarcerated. Seven wings in a star pattern. The evening sound and light show is deeply moving.',
        emoji: '⛓️', type: 'Heritage Museum', entryFee: '₹30', timings: '9:00 AM – 12:30 PM, 1:30 PM – 5:00 PM',
        latitude: 11.6727, longitude: 92.7441,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Cellular_Jail_Andaman.jpg/1280px-Cellular_Jail_Andaman.jpg',
      ),
      Attraction(
        name: 'Elephant Beach Snorkeling', nameHindi: 'एलिफेंट बीच',
        description: 'Best snorkeling beach in the Andamans — accessible by boat from Havelock jetty (30 min). Shallow crystal-clear water with vibrant coral gardens and colourful fish.',
        emoji: '🐠', type: 'Water Sport', entryFee: '₹500 boat + snorkel gear', timings: '8:00 AM – 4:00 PM',
        latitude: 11.9927, longitude: 92.9599,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Elephant_Beach_Havelock_Andaman.jpg/1280px-Elephant_Beach_Havelock_Andaman.jpg',
      ),
      Attraction(
        name: 'Baratang Limestone Caves', nameHindi: 'बाराटांग गुफाएं',
        description: 'Creamy white limestone stalactite caves in dense mangrove forest on Baratang Island. The boat journey through mangroves past crocodiles and mud volcanoes are equally memorable.',
        emoji: '🦇', type: 'Cave', entryFee: '₹300 permit', timings: '6:00 AM – 2:00 PM',
        latitude: 12.2787, longitude: 92.7618,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Baratang_Limestone_Caves_Andaman.jpg/1280px-Baratang_Limestone_Caves_Andaman.jpg',
      ),
    ],
  ),
];
