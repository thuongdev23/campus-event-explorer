import 'package:flutter/material.dart';

import '../../models/event.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.available,
    required this.favorite,
    required this.joined,
    required this.onFavorite,
    required this.onOpen,
  });
  final CampusEvent event;
  final int available;
  final bool favorite, joined;
  final VoidCallback onFavorite, onOpen;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 20),
    elevation: 0,
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: const BorderSide(color: Color(0xFFEAE4F5)),
    ),
    child: InkWell(
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: 'event-image-${event.id}',
                child: Image.asset(
                  event.image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  semanticLabel: '${event.category} event illustration',
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Chip(
                  label: Text(event.category),
                  side: BorderSide.none,
                  backgroundColor: const Color(0xFFF8F6FF),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton.filledTonal(
                  tooltip: favorite
                      ? 'Remove ${event.title} from favorites'
                      : 'Favorite ${event.title}',
                  onPressed: onFavorite,
                  icon: AnimatedSwitcher(
                    duration: Duration(
                      milliseconds: MediaQuery.of(context).disableAnimations
                          ? 0
                          : 220,
                    ),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      favorite ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(favorite),
                      color: favorite ? const Color(0xFFE34479) : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  event.dateLabel,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Text(
                  event.venue,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      joined
                          ? Icons.check_circle_outline
                          : Icons.people_outline,
                      size: 18,
                      color: available == 0 && !joined
                          ? Colors.red.shade700
                          : const Color(0xFF6844D9),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        joined
                            ? 'Joined · $available places left'
                            : available == 0
                            ? 'Full'
                            : '$available ${available == 1 ? 'place' : 'places'} left',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Text('Details'),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
