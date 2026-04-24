import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';

class MockData {
  static final List<Pitch> pitches = [
    const Pitch(
      id: '1',
      name: 'Anfield Arena',
      location: 'New Cairo, Cairo',
      rating: 4.8,
      reviewsCount: 120,
      imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
      pricePerHour: 450,
      amenities: ['Showers', 'Parking', 'Free WiFi', 'Cafeteria'],
      description: 'Featuring high-grade FIFA certified artificial turf, Anfield Arena offers a premium playing surface...',
      ownerId: 'owner_1',
    ),
    const Pitch(
      id: '2',
      name: 'Camp Nou Cairo',
      location: 'Maadi, Cairo',
      rating: 4.9,
      reviewsCount: 85,
      imageUrl: 'https://images.unsplash.com/photo-1556056504-5c7696c4c28d?auto=format&fit=crop&q=80',
      pricePerHour: 500,
      amenities: ['Showers', 'Parking', 'Lockers'],
      description: 'One of the best pitches in Maadi with professional lighting for night matches.',
      ownerId: 'owner_2',
    ),
    const Pitch(
      id: '3',
      name: 'The Arena Futsal',
      location: 'Dokki, Cairo',
      rating: 4.7,
      reviewsCount: 200,
      imageUrl: 'https://images.unsplash.com/photo-1518605336397-90db31631e84?auto=format&fit=crop&q=80',
      pricePerHour: 350,
      amenities: ['Parking', 'Cafeteria'],
      description: 'Perfect for 5-a-side matches with a vibrant atmosphere.',
      ownerId: 'owner_3',
    ),
  ];

  static final List<MatchmakingMatch> matches = [
    MatchmakingMatch(
      id: 'm1',
      title: 'Monday Night Football',
      location: 'Maadi, Cairo',
      pricePerPlayer: 150,
      totalSlots: 10,
      availableSlots: 2,
      kickoffTime: DateTime.now().add(const Duration(hours: 5)),
      imageUrl: 'https://images.unsplash.com/photo-1556056504-5c7696c4c28d?auto=format&fit=crop&q=80',
      participantIds: List.generate(8, (i) => 'u$i'),
      pitchId: '2',
    ),
    MatchmakingMatch(
      id: 'm2',
      title: 'Champions League Final',
      location: 'New Cairo',
      pricePerPlayer: 200,
      totalSlots: 14,
      availableSlots: 4,
      kickoffTime: DateTime.now().add(const Duration(hours: 10)),
      imageUrl: 'https://images.unsplash.com/photo-1518605336397-90db31631e84?auto=format&fit=crop&q=80',
      participantIds: List.generate(10, (i) => 'u$i'),
      pitchId: '1',
    ),
  ];
}
