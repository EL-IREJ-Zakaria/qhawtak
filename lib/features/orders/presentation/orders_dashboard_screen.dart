import 'package:flutter/material.dart';
import 'package:qhawtak/shared/models/order.dart';
import 'package:qhawtak/shared/widgets/coffee_hero_banner.dart';
import 'package:qhawtak/shared/widgets/empty_state.dart';
import 'package:qhawtak/shared/widgets/order_card.dart';
import 'package:qhawtak/shared/widgets/staggered_fade_slide.dart';

class OrdersDashboardScreen extends StatelessWidget {
  const OrdersDashboardScreen({
    super.key,
    required this.orders,
    required this.onAdvanceStatus,
  });

  final List<CoffeeOrder> orders;
  final ValueChanged<CoffeeOrder> onAdvanceStatus;

  @override
  Widget build(BuildContext context) {
    final List<_OrderTabConfig> tabs = <_OrderTabConfig>[
      _OrderTabConfig(
        label: 'New',
        statuses: <OrderStatus>[OrderStatus.newOrder],
      ),
      _OrderTabConfig(
        label: 'Preparing',
        statuses: <OrderStatus>[OrderStatus.accepted, OrderStatus.preparing],
      ),
      _OrderTabConfig(
        label: 'Ready',
        statuses: <OrderStatus>[OrderStatus.ready],
      ),
      _OrderTabConfig(
        label: 'Completed',
        statuses: <OrderStatus>[OrderStatus.completed],
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: CoffeeHeroBanner(
              imageUrl:
                  'https://images.unsplash.com/photo-1442512595331-e89e73853f31?auto=format&fit=crop&w=1200&q=80',
              title: 'Incoming Orders',
              subtitle: 'Track, accept, and serve in real time',
              height: 132,
            ),
          ),
          TabBar(
            isScrollable: true,
            tabs: tabs.map((e) => Tab(text: e.label)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: tabs.map((tab) {
                final List<CoffeeOrder> sectionOrders = orders
                    .where((CoffeeOrder o) => tab.statuses.contains(o.status))
                    .toList()
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                if (sectionOrders.isEmpty) {
                  return EmptyState(
                    title: 'No ${tab.label.toLowerCase()} orders',
                    message: 'New orders will appear here in real time.',
                    icon: Icons.coffee_outlined,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sectionOrders.length,
                    itemBuilder: (BuildContext context, int index) {
                      final CoffeeOrder order = sectionOrders[index];
                      return StaggeredFadeSlide(
                        index: index,
                        child: OrderCard(
                          order: order,
                          onAdvanceStatus: () => onAdvanceStatus(order),
                        ),
                      );
                    },
                  );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTabConfig {
  const _OrderTabConfig({required this.label, required this.statuses});

  final String label;
  final List<OrderStatus> statuses;
}
