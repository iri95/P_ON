class TtossNotification {
  final String type;
  final String description;
  final DateTime time;
  bool isRead;

  TtossNotification(
    this.type,
    this.description,
    this.time, {
    this.isRead = false,
  });
}

class MyNotification {
  final String type;
  final String description;
  final DateTime time;
  bool isRead;

  MyNotification(
    this.type,
    this.description,
    this.time, {
    this.isRead = false,
  });
}