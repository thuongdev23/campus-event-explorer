import '../data/events.dart';
import '../models/event.dart';

enum EventTab { explore, favorites, myEvents }

/// Session-only model operations. Views call these inside setState callbacks.
class EventController {
  EventController({List<CampusEvent>? events})
    : events = List.unmodifiable(events ?? createEvents());
  final List<CampusEvent> events;
  final Set<String> _favorites = {}, _joined = {};
  String query = '';
  String category = 'All';
  EventTab tab = EventTab.explore;
  List<String> get categories => [
    'All',
    ...events.map((e) => e.category).toSet(),
  ];
  int get joinedCount => _joined.length;
  bool isFavorite(CampusEvent e) => _favorites.contains(e.id);
  bool isJoined(CampusEvent e) => _joined.contains(e.id);
  int available(CampusEvent e) => e.initialAvailable - (isJoined(e) ? 1 : 0);
  void toggleFavorite(CampusEvent e) {
    if (!_favorites.add(e.id)) _favorites.remove(e.id);
  }

  bool join(CampusEvent e) {
    if (isJoined(e) || available(e) <= 0) return false;
    return _joined.add(e.id);
  }

  bool cancel(CampusEvent e) => _joined.remove(e.id);
  List<CampusEvent> get visibleEvents => events
      .where(
        (e) =>
            (tab == EventTab.explore ||
                (tab == EventTab.favorites ? isFavorite(e) : isJoined(e))) &&
            (category == 'All' || category == e.category) &&
            e.title.toLowerCase().contains(query.trim().toLowerCase()),
      )
      .toList();
}
