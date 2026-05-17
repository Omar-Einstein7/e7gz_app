import 'package:e7gz/src/features/matchmaking/domain/entities/match.dart';
import 'package:e7gz/src/features/pitches/domain/entities/pitch.dart';

class MockData {
  static final List<Pitch> pitches = [
    const Pitch(
      id: '1',
      name: 'Anfield Arena',
      description:
          'Featuring high-grade FIFA certified artificial turf, Anfield Arena offers a premium playing surface...',
      ownerId: 'owner_1',
      sportType: 'Football',
      location: PitchLocation(
        address: 'Street 9',
        city: 'New Cairo',
        country: 'Egypt',
        latitude: 30.0444,
        longitude: 31.2357,
      ),
      pricePerHour: 450,
      amenities: ['Showers', 'Parking', 'Free WiFi', 'Cafeteria'],
      images: [
        'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
      ],
      rating: 4.8,
      reviewsCount: 120,
      isAvailable: true,
      openingTime: '08:00',
      closingTime: '00:00',
      slotDurationMinutes: 60,
    ),
    const Pitch(
      id: '2',
      name: 'Camp Nou Cairo',
      description:
          'One of the best pitches in Maadi with professional lighting for night matches.',
      ownerId: 'owner_2',
      sportType: 'Football',
      location: PitchLocation(
        address: 'Maadi Degla',
        city: 'Maadi',
        country: 'Egypt',
        latitude: 29.9602,
        longitude: 31.2569,
      ),
      pricePerHour: 500,
      amenities: ['Showers', 'Parking', 'Lockers'],
      images: [
        'https://images.unsplash.com/photo-1556056504-5c7696c4c28d?auto=format&fit=crop&q=80',
      ],
      rating: 4.9,
      reviewsCount: 85,
      isAvailable: true,
      openingTime: '09:00',
      closingTime: '02:00',
      slotDurationMinutes: 60,
    ),
    const Pitch(
      id: '3',
      name: 'The Arena Futsal',
      description: 'Perfect for 5-a-side matches with a vibrant atmosphere.',
      ownerId: 'owner_3',
      sportType: 'Futsal',
      location: PitchLocation(
        address: 'Dokki Square',
        city: 'Dokki',
        country: 'Egypt',
        latitude: 30.0396,
        longitude: 31.2144,
      ),
      pricePerHour: 350,
      amenities: ['Parking', 'Cafeteria'],
      images: [
        'https://images.unsplash.com/photo-1518605336397-90db31631e84?auto=format&fit=crop&q=80',
      ],
      rating: 4.7,
      reviewsCount: 200,
      isAvailable: true,
      openingTime: '07:00',
      closingTime: '23:00',
      slotDurationMinutes: 60,
    ),
  ];

  static final List<MatchmakingMatch> matches = [
    MatchmakingMatch(
      id: 'm1',
      title: 'Monday Night Football',
      pitchId: '2',
      creatorId: 'u0',
      date: '2023-10-23',
      startTime: '21:00',
      endTime: '22:00',
      maxPlayers: 10,
      participantIds: List.generate(8, (i) => 'u$i'),
      pricePerPlayer: 150,
      skillLevel: 'Intermediate',
      status: 'open',
      pitchName: 'Maadi Arena',
      pitchImage:
          'https://images.unsplash.com/photo-1556056504-5c7696c4c28d?auto=format&fit=crop&q=80',
      sportType: '',
    ),
    MatchmakingMatch(
      id: 'm2',
      title: 'Champions League Final',
      pitchId: '1',
      creatorId: 'u1',
      date: '2023-10-24',
      startTime: '20:00',
      endTime: '21:00',
      maxPlayers: 14,
      participantIds: List.generate(10, (i) => 'u$i'),
      pricePerPlayer: 200,
      skillLevel: 'Advanced',
      status: 'open',
      pitchName: 'Anfield Arena',
      pitchImage:
          'https://images.unsplash.com/photo-1518605336397-90db31631e84?auto=format&fit=crop&q=80',
      sportType: '',
    ),
  ];
}
