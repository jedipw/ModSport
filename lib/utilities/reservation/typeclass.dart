class ReservationData {
  final DateTime startTime;
  final DateTime endTime;
  final int capacity;

  ReservationData({
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
