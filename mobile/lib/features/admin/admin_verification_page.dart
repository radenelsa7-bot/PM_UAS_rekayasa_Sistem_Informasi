import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_providers.dart';

class AdminVerificationPage extends ConsumerWidget {
  const AdminVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providersAsync = ref.watch(pendingProvidersProvider);
    final actionState = ref.watch(adminVerificationControllerProvider);

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Provider'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              // ignore: unused_result
              ref.refresh(pendingProvidersProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: providersAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
        error: (err, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Error: $err',
              style: TextStyle(color: colorScheme.onBackground),
            ),
          ),
        ),
        data: (providers) {
          if (providers.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Tidak ada provider yang menunggu verifikasi.',
                  style: TextStyle(color: colorScheme.onBackground),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              final isProcessing = actionState.processingProviderId == provider.id;

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: colorScheme.secondary,
                            child: Text(
                              (provider.businessName.isNotEmpty
                                      ? provider.businessName[0]
                                      : 'P')
                                  .toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.businessName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: colorScheme.primary),
                                ),
                                const SizedBox(height: 6),
                                Text(provider.ownerName ?? 'Pemilik tidak diketahui'),
                                const SizedBox(height: 6),
                                Text('Area: ${provider.area ?? '-'}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildStatusChip(
                            label: provider.isVerified ? 'Terverifikasi' : 'Belum diverifikasi',
                            backgroundColor: provider.isVerified
                                ? colorScheme.primary.withOpacity(0.12)
                                : colorScheme.secondary.withOpacity(0.18),
                            textColor: provider.isVerified ? colorScheme.primary : colorScheme.secondary,
                          ),
                          _buildStatusChip(
                            label: 'Rating ${provider.avgRating.toString()}',
                            backgroundColor: colorScheme.primary.withOpacity(0.08),
                            textColor: colorScheme.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isProcessing
                                  ? null
                                  : () async {
                                      final success = await ref
                                          .read(adminVerificationControllerProvider.notifier)
                                          .setVerification(
                                            providerId: provider.id,
                                            isVerified: true,
                                          );
                                      if (success && context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: colorScheme.primary,
                                            content: const Text('Provider berhasil diverifikasi'),
                                          ),
                                        );
                                      }
                                    },
                              icon: isProcessing
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colorScheme.onSecondary,
                                      ),
                                    )
                                  : const Icon(Icons.verified),
                              label: const Text('Verifikasi'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Chip(
      backgroundColor: backgroundColor,
      label: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
  }
}
