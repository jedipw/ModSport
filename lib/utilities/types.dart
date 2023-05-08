class ReservationData {
  final String reservationId;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? capacity;

  ReservationData({
    required this.reservationId,
    required this.startTime,
    required this.endTime,
    required this.capacity,
  });
}

class UserReservationData {
  final DateTime startDateTime;
  final String userId;

  UserReservationData({
    required this.startDateTime,
    required this.userId,
  });
}

class ZoneData {
  final String zoneId;
  final String locationId;
  final String zoneName;
  final String imgUrl;

  ZoneData({
    required this.zoneId,
    required this.locationId,
    required this.zoneName,
    required this.imgUrl,
  });
}

class DisableData {
  final String disableId;
  final DateTime startDateTime;
  final String disableReason;

  DisableData({
    required this.disableId,
    required this.startDateTime,
    required this.disableReason,
  });
}

class Booking {
  final String zoneId;
  final String zoneName;
  final String date;
  final String time;
  final DateTime dateTime;
  final String endTime;
  final bool isSuccessful;

  Booking({
    required this.zoneId,
    required this.zoneName,
    required this.date,
    required this.time,
    required this.dateTime,
    required this.endTime,
    required this.isSuccessful,
  });
}
