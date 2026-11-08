class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
  });

  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
}