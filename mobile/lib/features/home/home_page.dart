import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_controller.dart';
import '../auth/login_page.dart';
import '../admin/admin_verification_page.dart';
import 'catalog_page.dart';
import 'my_orders_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final isAdmin = state.userRole == 'ADMIN';
    final tabs = [
      const Tab(icon: Icon(Icons.home), text: 'Beranda'),
      const Tab(icon: Icon(Icons.receipt_long), text: 'Pesanan'),
      if (isAdmin) const Tab(icon: Icon(Icons.verified_user), text: 'Admin'),
      const Tab(icon: Icon(Icons.account_circle), text: 'Akun'),
    ];
    final pages = [
      const CatalogPage(),
      const MyOrdersPage(),
      if (isAdmin) const AdminVerificationPage(),
      _buildAccountTab(context, state),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text('TukangDekat'),
          bottom: TabBar(tabs: tabs),
          actions: [
            IconButton(
              tooltip: 'Logout',
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).logout();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: TabBarView(
          children: pages,
        ),
      ),
    );
  }

  Widget _buildAccountTab(BuildContext context, dynamic state) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Profil Akun',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: colorScheme.primary),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.userEmail ?? 'N/A',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoBadge(
                      label: 'Role',
                      value: state.userRole ?? 'N/A',
                      color: colorScheme.secondary,
                    ),
                    const SizedBox(width: 10),
                    _buildInfoBadge(
                      label: 'ID',
                      value: state.userId?.toString() ?? 'N/A',
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}