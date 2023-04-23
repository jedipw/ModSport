import 'package:modsport/utilities/types.dart';

int countNumOfReservation(
    DateTime? startTime, List<UserReservationData> userReservation) {
  int num = 0;
  for (int i = 0; i < userReservation.length; i++) {
    if (startTime!.year == userReservation[i].startDateTime.year &&
        startTime.month == userReservation[i].startDateTime.month &&
        startTime.day == userReservation[i].startDateTime.day &&
        startTime.hour == userReservation[i].startDateTime.hour &&
        startTime.minute == userReservation[i].startDateTime.minute &&
        startTime.second == userReservation[i].startDateTime.second) {
      num++;
    }
  }
  return num;
}

bool isDisable(DateTime? startTime, List<DisableData> disabledReservation) {
  for (int i = 0; i < disabledReservation.length; i++) {
    if (disabledReservation[i].startDateTime.year == startTime!.year &&
        disabledReservation[i].startDateTime.month == startTime.month &&
        disabledReservation[i].startDateTime.day == startTime.day &&
        disabledReservation[i].startDateTime.hour == startTime.hour &&
        disabledReservation[i].startDateTime.minute == startTime.minute &&
        disabledReservation[i].startDateTime.second == startTime.second) {
      return true;
    }
  }
  return false;
}
