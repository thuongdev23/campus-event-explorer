import 'package:flutter/material.dart';

import '../controllers/event_controller.dart';
import '../models/event.dart';
import 'details_screen.dart';
import 'widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = EventController();
  final search = TextEditingController();
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void clearFilters() => setState(() {
    search.clear();
    controller.query = '';
    controller.category = 'All';
  });
  Future<void> open(CampusEvent event) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => DetailsScreen(
          event: event,
          controller: controller,
          onChanged: () => setState(() {}),
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final events = controller.visibleEvents;
    final title = ['Explore', 'Favorites', 'My Events'][controller.tab.index];
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.blur_on, color: Color(0xFF244D3E)),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Iki Eylul Campus / Together',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${controller.joinedCount} joined',
                key: const Key('joined-count'),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: TweenAnimationBuilder<double>(
            key: ValueKey(controller.tab),
            tween: Tween(begin: 0, end: 1),
            duration: Duration(
              milliseconds: MediaQuery.of(context).disableAnimations ? 0 : 320,
            ),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 16 * (1 - value)),
                child: child,
              ),
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'JOIN THE CAMPUS COMMUNITY AND DISCOVER EVENTS',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 2,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title == 'Explore'
                              ? 'Your people.\nYour kind of plans.'
                              : title,
                          style: const TextStyle(
                            fontSize: 36,
                            height: 1.12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          [
                            'Small moments. New connections. All on campus.',
                            'Keep the experiences you love close.',
                            'Make time for something that moves you.',
                          ][controller.tab.index],
                        ),
                        const SizedBox(height: 22),
                        TextField(
                          controller: search,
                          onChanged: (value) =>
                              setState(() => controller.query = value),
                          decoration: InputDecoration(
                            hintText: 'Search event titles',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: search.text.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: 'Clear search',
                                    icon: const Icon(Icons.close),
                                    onPressed: () => setState(() {
                                      search.clear();
                                      controller.query = '';
                                    }),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: controller.categories
                                .map(
                                  (category) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(category),
                                      selected: controller.category == category,
                                      onSelected: (_) => setState(
                                        () => controller.category = category,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title == 'Explore'
                                    ? 'Coming up on campus'
                                    : 'Your collection',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '${events.length} ${events.length == 1 ? 'event' : 'events'}',
                              key: const Key('match-count'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (events.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            controller.tab == EventTab.favorites
                                ? Icons.favorite_border
                                : Icons.event_note,
                            size: 48,
                            color: const Color(0xFF244D3E),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.query.trim().isNotEmpty ||
                                    controller.category != 'All'
                                ? 'No events match your filters.'
                                : controller.tab == EventTab.favorites
                                ? 'No favorites yet. Tap a heart to save an event.'
                                : 'Your next experience is waiting. Join an event to see it here.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: clearFilters,
                            child: const Text('Clear search & filters'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    sliver: SliverList.builder(
                      itemCount: events.length,
                      itemBuilder: (_, i) {
                        final e = events[i];
                        return EventCard(
                          event: e,
                          available: controller.available(e),
                          favorite: controller.isFavorite(e),
                          joined: controller.isJoined(e),
                          onFavorite: () =>
                              setState(() => controller.toggleFavorite(e)),
                          onOpen: () => open(e),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: controller.tab.index,
        onDestinationSelected: (index) {
          if (index == controller.tab.index) return;
          setState(() => controller.tab = EventTab.values[index]);
        },
        animationDuration: const Duration(milliseconds: 350),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: _TabIcon(
              icon: Icons.explore,
              selected: controller.tab.index == 0,
            ),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: _TabIcon(
              icon: Icons.favorite,
              selected: controller.tab.index == 1,
            ),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: _TabIcon(
              icon: Icons.event,
              selected: controller.tab.index == 2,
            ),
            label: 'My Events',
          ),
        ],
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  const _TabIcon({required this.icon, required this.selected});
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.8, end: selected ? 1.15 : 1),
    duration: Duration(
      milliseconds: MediaQuery.of(context).disableAnimations ? 0 : 420,
    ),
    curve: Curves.easeOutBack,
    builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
    child: Icon(icon),
  );
}
