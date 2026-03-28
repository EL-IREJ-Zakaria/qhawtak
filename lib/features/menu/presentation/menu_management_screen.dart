import 'package:flutter/material.dart';
import 'package:qhawtak/features/menu/presentation/edit_coffee_screen.dart';
import 'package:qhawtak/shared/models/coffee.dart';
import 'package:qhawtak/shared/widgets/coffee_hero_banner.dart';
import 'package:qhawtak/shared/widgets/coffee_tile.dart';
import 'package:qhawtak/shared/widgets/empty_state.dart';
import 'package:qhawtak/shared/widgets/staggered_fade_slide.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({
    super.key,
    required this.coffees,
    required this.onSaveCoffee,
    required this.onDeleteCoffee,
    required this.onToggleAvailability,
  });

  final List<CoffeeItem> coffees;
  final ValueChanged<CoffeeItem> onSaveCoffee;
  final ValueChanged<String> onDeleteCoffee;
  final ValueChanged<String> onToggleAvailability;

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final List<CoffeeItem> filtered = widget.coffees.where((CoffeeItem coffee) {
      final String q = _query.toLowerCase().trim();
      if (q.isEmpty) return true;
      return coffee.name.toLowerCase().contains(q) || coffee.category.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: CoffeeHeroBanner(
              imageUrl:
                  'https://images.unsplash.com/photo-1453614512568-c4024d13c247?auto=format&fit=crop&w=1200&q=80',
              title: 'Menu Curation',
              subtitle: 'Keep the waiter app and website menu perfectly aligned',
              height: 126,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (String value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'Search menu item...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    title: 'No menu item found',
                    message: 'Try changing your search or add a new item.',
                    icon: Icons.local_cafe_outlined,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext context, int index) {
                      final CoffeeItem coffee = filtered[index];
                      return StaggeredFadeSlide(
                        index: index,
                        child: CoffeeTile(
                          coffee: coffee,
                          onEdit: () => _openEditor(coffee),
                          onDelete: () => widget.onDeleteCoffee(coffee.id),
                          onToggleAvailability: () => widget.onToggleAvailability(coffee.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  Future<void> _openEditor([CoffeeItem? initial]) async {
    final CoffeeItem? result = await Navigator.of(context).push<CoffeeItem>(
      MaterialPageRoute<CoffeeItem>(
        builder: (_) => EditCoffeeScreen(initial: initial),
      ),
    );
    if (result != null) widget.onSaveCoffee(result);
  }
}
