import '../../models/place.dart';

const List<Place> punjabPlaces = [
  Place(
    id: 'amritsar_punjab',
    name: 'Amritsar',
    nameHindi: 'अमृतसर',
    state: 'Punjab',
    shortDescription: 'Golden Temple, Wagah Border & the soul of Punjab',
    description: 'Amritsar, the holiest city for Sikhs, is home to the Golden Temple (Harmandir Sahib) — the spiritual and cultural centre of Sikhism. The city also carries deep history from the Jallianwala Bagh massacre. The Wagah Border ceremony, 28 km away, is a nightly spectacle.',
    category: PlaceCategory.temple,
    bestSeasons: [Season.winter, Season.autumn],
    latitude: 31.6340, longitude: 74.8723,
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Golden_Temple_%28Harmandir_Sahib%29_in_Amritsar%2C_Punjab%2C_India.jpg/1280px-Golden_Temple_%28Harmandir_Sahib%29_in_Amritsar%2C_Punjab%2C_India.jpg',
    rating: 4.9, entryFee: 'Free', timings: 'Open 24 hours',
    isFeatured: true,
    tags: ['Sikhism', 'Golden Temple', 'Wagah Border', 'Langar', 'Punjab'],
    nearestCity: 'Amritsar',
    howToReach: 'Sri Guru Ram Dass Jee International Airport (11 km). Trains from Delhi (6 hrs).',
    attractions: [
      Attraction(
        name: 'Harmandir Sahib (Golden Temple)', nameHindi: 'स्वर्ण मंदिर',
        description: 'The holiest Gurudwara of Sikhism — gold-plated exterior reflecting in the sacred Amrit Sarovar lake. Open 24 hours; 100,000 free meals served daily in langar. Divinely peaceful at 2–4 AM.',
        emoji: '✨', type: 'Gurudwara', entryFee: 'Free', timings: 'Open 24 hours',
        latitude: 31.6200, longitude: 74.8765,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Golden_Temple_%28Harmandir_Sahib%29_in_Amritsar%2C_Punjab%2C_India.jpg/1280px-Golden_Temple_%28Harmandir_Sahib%29_in_Amritsar%2C_Punjab%2C_India.jpg',
      ),
      Attraction(
        name: 'Jallianwala Bagh', nameHindi: 'जलियाँवाला बाग',
        description: 'Historic garden where General Dyer ordered troops to fire on unarmed civilians in 1919, killing 379+. Bullet holes in the walls and the well where people jumped are preserved as memorials.',
        emoji: '🕊️', type: 'Memorial', entryFee: 'Free', timings: '6:30 AM – 9:30 PM',
        latitude: 31.6206, longitude: 74.8804,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/j/ja/Jallianwala_Bagh_Amritsar.jpg/1280px-Jallianwala_Bagh_Amritsar.jpg',
      ),
      Attraction(
        name: 'Wagah Border Ceremony', nameHindi: 'वाघा बॉर्डर',
        description: 'Nightly flag-lowering ceremony between India (BSF) and Pakistan (Rangers) with synchronized high kicks, marching and patriotic fervor draws 10,000+ spectators daily.',
        emoji: '🇮🇳', type: 'Border', entryFee: 'Free', timings: 'Daily at sunset (~5:30 PM winter)',
        latitude: 31.6041, longitude: 74.5730,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/w/wa/Wagah_Border_Ceremony_India_Pakistan.jpg/1280px-Wagah_Border_Ceremony_India_Pakistan.jpg',
      ),
      Attraction(
        name: 'Partition Museum', nameHindi: 'विभाजन संग्रहालय',
        description: 'World\'s first museum dedicated to the 1947 Partition. Harrowing first-person accounts, photographs, and artifacts document one of history\'s largest human migrations.',
        emoji: '📖', type: 'Museum', entryFee: '₹200', timings: '10:00 AM – 6:00 PM',
        latitude: 31.6227, longitude: 74.8723,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/p/p1/Partition_Museum_Amritsar.jpg/1280px-Partition_Museum_Amritsar.jpg',
      ),
    ],
  ),
];
