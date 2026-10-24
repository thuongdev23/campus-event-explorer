import 'package:flutter/material.dart';

import '../controllers/event_controller.dart';
import '../models/event.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.event,
    required this.controller,
    required this.onChanged,
  });
  final CampusEvent event;
  final EventController controller;
  final VoidCallback onChanged;
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Future<void> confirmParticipation() async {
    final e = widget.event;
    final c = widget.controller;
    final cancel = c.isJoined(e);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(cancel ? 'Cancel participation?' : 'Join this event?'),
        content: Text(
          '${e.title}\n\n${e.dateLabel}\n${e.venue}\n\n${cancel ? 'Your place will be made available again.' : 'Reserve one of the available places.'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final changed = cancel ? c.cancel(e) : c.join(e);
    if (!changed) return;
    setState(() {});
    widget.onChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          cancel
              ? 'Participation canceled. Your place has been restored.'
              : 'You joined ${e.title}. See you there!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final c = widget.controller;
    final joined = c.isJoined(e);
    final available = c.available(e);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event details'),
        actions: [
          IconButton(
            tooltip: c.isFavorite(e) ? 'Remove favorite' : 'Add favorite',
            onPressed: () {
              setState(() => c.toggleFavorite(e));
              widget.onChanged();
            },
            icon: Icon(
              c.isFavorite(e) ? Icons.favorite : Icons.favorite_border,
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Semantics(
                label: 'Event image. Double tap to enlarge.',
                button: true,
                child: GestureDetector(
                  onDoubleTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => ImageViewer(event: e),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Hero(
                      tag: 'event-image-${e.id}',
                      child: Image.asset(
                        e.image,
                        height: 230,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => ImageViewer(event: e),
                  ),
                ),
                icon: const Icon(Icons.zoom_in, size: 18),
                label: const Text('Double-tap image to enlarge'),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(label: Text(e.category)),
              ),
              Text(
                e.title,
                style: const TextStyle(
                  fontSize: 34,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 22),
              _Info(
                icon: Icons.calendar_today_outlined,
                title: 'Date & time · Türkiye (UTC+3)',
                value: e.dateLabel,
              ),
              _Info(
                icon: Icons.location_on_outlined,
                title: 'Meet us here',
                value: e.venue,
              ),
              _Info(
                icon: Icons.people_outline,
                title: 'Availability',
                value:
                    '${available == 0 ? 'Full · ' : ''}$available ${available == 1 ? 'place' : 'places'} remaining / ${e.capacity} total capacity',
              ),
              const Divider(height: 32),
              const Text(
                'About this experience',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                e.description,
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 24),
              Text(
                'Event ID: ${e.id} · Initially available: ${e.initialAvailable}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: FilledButton.icon(
            onPressed: joined || available > 0 ? confirmParticipation : null,
            icon: Icon(joined ? Icons.event_busy : Icons.add),
            label: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                joined
                    ? 'Cancel participation'
                    : available == 0
                    ? 'Full'
                    : 'Join event',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6844D9)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, required this.event});
  final CampusEvent event;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF101D18),
    appBar: AppBar(
      title: Text(event.title),
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF101D18),
    ),
    body: Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5,
        child: Image.asset(
          event.image,
          fit: BoxFit.contain,
          semanticLabel: event.title,
        ),
      ),
    ),
  );
}
