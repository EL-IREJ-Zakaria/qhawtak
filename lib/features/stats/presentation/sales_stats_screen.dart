import 'package:flutter/material.dart';
import 'package:qhawtak/core/theme/app_colors.dart';
import 'package:qhawtak/shared/models/order.dart';
import 'package:qhawtak/shared/widgets/coffee_hero_banner.dart';
import 'package:qhawtak/shared/widgets/stat_card.dart';

class SalesStatsScreen extends StatefulWidget {
  const SalesStatsScreen({super.key, required this.orders});

  final List<CoffeeOrder> orders;

  @override
  State<SalesStatsScreen> createState() => _SalesStatsScreenState();
}

class _SalesStatsScreenState extends State<SalesStatsScreen> {
  String _filter = 'Today';

  @override
  Widget build(BuildContext context) {
    final List<CoffeeOrder> source = widget.orders
        .where((CoffeeOrder o) => o.status == OrderStatus.completed || o.status == OrderStatus.ready)
        .toList();
    final double totalSales = source.fold(0, (sum, order) => sum + order.total);
    final int orderCount = source.length;
    final double avg = orderCount == 0 ? 0 : totalSales / orderCount;
    final Map<String, int> topCoffee = <String, int>{};
    for (final CoffeeOrder order in source) {
      for (final OrderLineItem item in order.items) {
        topCoffee[item.coffeeName] = (topCoffee[item.coffeeName] ?? 0) + item.quantity;
      }
    }
    final List<MapEntry<String, int>> top = topCoffee.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const CoffeeHeroBanner(
            imageUrl:
                'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=1200&q=80',
            title: 'Sales Pulse',
            subtitle: 'Performance insights for your coffee bar',
            height: 146,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: <String>['Today', 'This Week', 'This Month'].map((String label) {
            final bool selected = _filter == label;
            return ChoiceChip(
              label: Text(label),
              selected: selected,
              onSelected: (_) => setState(() => _filter = label),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        StatCard(
          title: 'Total Sales',
          value: '${totalSales.toStringAsFixed(2)} MAD',
          icon: Icons.payments_outlined,
        ),
        StatCard(
          title: 'Orders',
          value: '$orderCount',
          icon: Icons.receipt_long_outlined,
        ),
        StatCard(
          title: 'Average Order',
          value: '${avg.toStringAsFixed(2)} MAD',
          icon: Icons.stacked_line_chart_outlined,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text('Hourly Sales', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 10),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Center(
                        child: Text(
                          'Chart placeholder',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Top Coffees', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if (top.isEmpty)
                  const Text('No sales data yet.')
                else
                  ...top.take(5).map((MapEntry<String, int> e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('${e.key}: ${e.value} sold'),
                      )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
