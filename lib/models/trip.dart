class TripDay {
  final int dayNumber;
  final String date;
  final List<String> placeIds;
  final List<String> activityIds;
  final String notes;

  const TripDay({
    required this.dayNumber,
    this.date = '',
    this.placeIds = const [],
    this.activityIds = const [],
    this.notes = '',
  });

  TripDay copyWith({
    int? dayNumber,
    String? date,
    List<String>? placeIds,
    List<String>? activityIds,
    String? notes,
  }) {
    return TripDay(
      dayNumber: dayNumber ?? this.dayNumber,
      date: date ?? this.date,
      placeIds: placeIds ?? this.placeIds,
      activityIds: activityIds ?? this.activityIds,
      notes: notes ?? this.notes,
    );
  }
}

class Trip {
  final String id;
  final String title;
  final String destination;
  final int totalDays;
  final List<TripDay> days;
  final DateTime createdAt;

  const Trip({
    required this.id,
    required this.title,
    required this.destination,
    required this.totalDays,
    required this.days,
    required this.createdAt,
  });
}
