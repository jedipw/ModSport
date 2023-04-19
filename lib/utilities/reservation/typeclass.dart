class ReservationData {
  final String zoneId;
  final DateTime startTime;
  final DateTime endTime;
  final int capacity;

  ReservationData({
    required this.zoneId,
    required this.startTime,
    required this.endTime,
    required this.capacity,
  });
}

class UserReservationData {
  final DateTime startTime;
  final String userId;

  UserReservationData({
    required this.startTime,
    required this.userId,
  });
}
