class CampusEvent {
  CampusEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.dateTime,
    required this.venue,
    required this.description,
    required this.image,
    required this.capacity,
    required this.initialAvailable,
  }) : assert(capacity > 0),
       assert(initialAvailable >= 0 && initialAvailable <= capacity);
  final String id, title, category, venue, description, image;
  final DateTime dateTime;
  final int capacity, initialAvailable;
  String get dateLabel {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year} · ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
