class ReservationData {
  final DateTime? startTime;
  final DateTime? endTime;
  final int? capacity;

  ReservationData({
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
  final String locationId;
  final String zoneName;

  ZoneData({
    required this.locationId,
    required this.zoneName,
  });
}

class LocationData {
  final String imgUrl;
  final String locationName;

  LocationData({
    required this.imgUrl,
    required this.locationName,
  });
}

class DisableData {
  final DateTime startDateTime;
  final String disableReason;

  DisableData({
    required this.startDateTime,
    required this.disableReason,
  });
}
