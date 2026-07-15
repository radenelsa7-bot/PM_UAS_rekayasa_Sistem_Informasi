<<<<<<< HEAD
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import '../../app/theme/app_theme.dart';
import '../../core/models/provider_model.dart';
import '../../core/services/api_service.dart';
import '../../shared/widgets/app_text_field.dart';
import 'catalog_providers.dart';
import '../maps/location_picker_screen.dart'
    show LocationPickerScreen, LocationResult;

final providerServicesControllerProvider =
    StateNotifierProvider<ProviderServicesController, ProviderServicesState>((ref) {
  return ProviderServicesController(ref);
});
=======
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/models/category_model.dart';
import '../../core/models/provider_model.dart';
import '../../core/services/api_service.dart';
import 'catalog_providers.dart';

final providerServicesControllerProvider = StateNotifierProvider<ProviderServicesController, ProviderServicesState>(
  (ref) => ProviderServicesController(ref),
);
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034

final providerProfileProvider = FutureProvider<ProviderProfile>((ref) async {
  final api = ref.read(apiServiceProvider);
  final data = await api.getProviderProfile();
  if (data['profile'] is Map<String, dynamic>) {
    return ProviderProfile.fromJson(Map<String, dynamic>.from(data['profile']));
  }
  throw Exception('Failed to load provider profile');
});

class ProviderServicesState {
  final bool isLoading;
  final String? errorMessage;

  ProviderServicesState({this.isLoading = false, this.errorMessage});

  ProviderServicesState copyWith({bool? isLoading, String? errorMessage}) {
    return ProviderServicesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ProviderServicesController extends StateNotifier<ProviderServicesState> {
  ProviderServicesController(this._ref) : super(ProviderServicesState());

  final Ref _ref;
<<<<<<< HEAD
  DateTime _lastRefreshTime = DateTime(0);
  static const _minRefreshInterval = Duration(seconds: 2);

  /// Refresh profile with debouncing to prevent API spam (429 error)
  Future<bool> refreshProfile({bool force = false}) async {
    final now = DateTime.now();
    if (!force && now.difference(_lastRefreshTime) < _minRefreshInterval) {
      // Rate limited - skip this refresh call
      state = state.copyWith(isLoading: false);
      return false;
    }
    _lastRefreshTime = now;

=======

  Future<bool> refreshProfile() async {
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final _ = await _ref.refresh(providerProfileProvider.future);
      state = state.copyWith(isLoading: false);
      return true;
<<<<<<< HEAD
    } on DioException catch (e) {
      // Handle 429 Too Many Requests specifically
      if (e.response?.statusCode == 429) {
        _lastRefreshTime = DateTime.now().add(const Duration(seconds: 5)); // Back off longer
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Terlalu banyak request. Silakan tunggu sebentar dan coba lagi.',
        );
      } else {
        state = state.copyWith(isLoading: false, errorMessage: e.message);
      }
      return false;
=======
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> createService({
    required int categoryId,
    required String name,
    String? description,
    required int basePrice,
    String? priceUnit,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final api = _ref.read(apiServiceProvider);
      await api.createProviderService(
        categoryId: categoryId,
        name: name,
        description: description,
        basePrice: basePrice,
        priceUnit: priceUnit,
      );
<<<<<<< HEAD
      await refreshProfile(force: true);
=======
      await refreshProfile();
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateService({
    required int serviceId,
    String? description,
    int? categoryId,
    String? name,
    int? basePrice,
    String? priceUnit,
    bool? isActive,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final api = _ref.read(apiServiceProvider);
      await api.updateProviderService(
        serviceId: serviceId,
        categoryId: categoryId,
        name: name,
        description: description,
        basePrice: basePrice,
        priceUnit: priceUnit,
        isActive: isActive,
      );
<<<<<<< HEAD
      await refreshProfile(force: true);
=======
      await refreshProfile();
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateProfile({
    String? businessName,
    String? description,
    String? area,
    String? address,
<<<<<<< HEAD
    double? latitude,
    double? longitude,
=======
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final api = _ref.read(apiServiceProvider);
      await api.updateProviderProfile(
        businessName: businessName,
        description: description,
        area: area,
        address: address,
<<<<<<< HEAD
        latitude: latitude,
        longitude: longitude,
      );
      await refreshProfile(force: true);
=======
      );
      await refreshProfile();
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
<<<<<<< HEAD

  Future<bool> updateCoverage({
    required int kotaId,
    required List<int> kecamatanIds,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final api = _ref.read(apiServiceProvider);
      await api.updateProviderCoverage(
        kotaId: kotaId,
        kecamatanIds: kecamatanIds,
      );
      await refreshProfile(force: true);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteService(int serviceId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _ref.read(apiServiceProvider).deleteProviderService(serviceId);
      await refreshProfile(force: true);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.response?.data is Map
            ? e.response?.data['message']?.toString()
            : e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void clearError() {
    state = ProviderServicesState();
  }
}

class ProviderServicesPage extends ConsumerStatefulWidget {
  const ProviderServicesPage({super.key});

  @override
  ConsumerState<ProviderServicesPage> createState() => _ProviderServicesPageState();
}

class _ProviderServicesPageState extends ConsumerState<ProviderServicesPage> {
  bool _showFooter = false;
  final _businessNameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  int? _loadedProfileId;

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _populateProfileFields(ProviderProfile profile) {
    if (_loadedProfileId == profile.id) return;
    _loadedProfileId = profile.id;
    _businessNameCtrl.text = profile.businessName;
    _descriptionCtrl.text = profile.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(providerServicesControllerProvider.notifier);
    final state = ref.watch(providerServicesControllerProvider);
    final profileAsync = ref.watch(providerProfileProvider);
    // Preload categories so the add-service form can always offer a category.
    ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Layanan Saya'),
        backgroundColor: AppTheme.navy,
        foregroundColor: Colors.white,
      ),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.orange),
        ),
        error: (err, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppTheme.danger),
                const SizedBox(height: 16),
                Text(
                  'Gagal memuat layanan: $err',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.invalidate(providerProfileProvider),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
        data: (profile) {
          _populateProfileFields(profile);
          // Handle error notification
          if (state.errorMessage != null && state.errorMessage!.contains('429')) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: AppTheme.warning,
                  ),
                );
                controller.clearError();
              }
            });
          }

          return NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.extentAfter < 50 && !_showFooter) {
                setState(() => _showFooter = true);
              } else if (notification.metrics.extentAfter > 100 && _showFooter) {
                setState(() => _showFooter = false);
              }
              return false;
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Card
=======
}

class ProviderServicesPage extends ConsumerWidget {
  const ProviderServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(providerProfileProvider);
    final controllerState = ref.watch(providerServicesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Layanan Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controllerState.isLoading
                ? null
                : () => ref.read(providerServicesControllerProvider.notifier).refreshProfile(),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Gagal memuat profil provider: $err')),
        data: (profile) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil Provider',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
<<<<<<< HEAD
                        Text(
                          'Profil Provider',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _businessNameCtrl,
                          label: 'Nama Usaha',
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _descriptionCtrl,
                          label: 'Deskripsi',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () async {
                                  final name = _businessNameCtrl.text.trim();
                                  if (name.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Nama usaha wajib diisi')),
                                    );
                                    return;
                                  }
                                  final ok = await controller.updateProfile(
                                    businessName: name,
                                    description: _descriptionCtrl.text.trim(),
                                    area: profile.area,
                                    address: profile.address,
                                  );
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(ok ? 'Profil berhasil disimpan' : 'Gagal menyimpan profil'),
                                      backgroundColor: ok ? Colors.green : AppTheme.danger,
                                    ),
                                  );
                                },
                          child: const Text('Simpan Profil'),
                        ),
                                                const Divider(height: 24),
                        Text(
                          'Lokasi Provider',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lokasi ini dipakai untuk menampilkan posisi Anda ke '
                          'customer pada peta pelacakan pesanan.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              (profile.latitude != null &&
                                      profile.longitude != null)
                                  ? Icons.my_location
                                  : Icons.location_off,
                              size: 18,
                              color: (profile.latitude != null &&
                                      profile.longitude != null)
                                  ? AppTheme.orange
                                  : AppTheme.danger,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                (profile.latitude != null &&
                                        profile.longitude != null)
                                    ? (profile.address?.isNotEmpty == true
                                          ? profile.address!
                                          : '${profile.latitude}, ${profile.longitude}')
                                    : 'Lokasi belum diatur',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () => _setProviderLocation(profile),
                          icon: const Icon(Icons.map_rounded, size: 18),
                          label: Text(
                            (profile.latitude != null &&
                                    profile.longitude != null)
                                ? 'Perbarui Lokasi (GPS/Peta)'
                                : 'Atur Lokasi (GPS/Peta)',
                          ),
                        ),
=======
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                profile.businessName,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Edit Profil',
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final result = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => ProviderProfileDialog(profile: profile),
                                );
                                if (result == true) {
                                  // refresh profile
                                  await ref.read(providerServicesControllerProvider.notifier).refreshProfile();
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Profil provider berhasil diperbarui')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (profile.description != null && profile.description!.isNotEmpty)
                          _buildInfoRow('Deskripsi', profile.description!),
                        _buildInfoRow('Area', profile.area ?? '-'),
                        _buildInfoRow('Alamat', profile.address ?? '-'),
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
                      ],
                    ),
                  ),
                ),
<<<<<<< HEAD
                const SizedBox(height: 16),
                // Services Section
                const Text(
                  'Layanan Tersedia',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                if (profile.services.isEmpty)
                  const Text('Belum ada layanan. Tambahkan layanan di bawah.')
                else
                  ...profile.services.map((service) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(service.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              tooltip: 'Edit layanan',
                              onPressed: () => _showEditServiceDialog(context, service),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: AppTheme.danger,
                              ),
                              tooltip: 'Hapus layanan',
                              onPressed: state.isLoading
                                  ? null
                                  : () => _confirmDeleteService(service),
                            ),
                            Switch(
                              value: service.isActive,
                              onChanged: state.isLoading ? null : (val) => controller.updateService(
                                serviceId: service.id,
                                isActive: val,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 16),
                // Add Service Button
                ElevatedButton.icon(
                  onPressed: () => _showAddServiceDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Layanan'),
                ),
                if (_showFooter) const SizedBox(height: 16),
=======
                const SizedBox(height: 12),
                if (controllerState.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      controllerState.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: profile.services.length,
                    itemBuilder: (context, index) {
                      final service = profile.services[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(service.name),
                          subtitle: Text(
                            '${service.categoryName ?? 'Layanan'} · Rp${service.basePrice} / ${service.priceUnit}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await showDialog<bool>(
                                context: context,
                                builder: (_) => ProviderServiceDialog(service: service),
                              );
                              if (result == true) {
                                ref.read(providerServicesControllerProvider.notifier).refreshProfile();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Layanan berhasil diperbarui')),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
              ],
            ),
          );
        },
      ),
<<<<<<< HEAD
    );
  }

  Future<void> _setProviderLocation(ProviderProfile profile) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return;
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi GPS tidak aktif. Silakan aktifkan GPS.'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }
 
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (!mounted) return;
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izin lokasi belum diberikan.'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }
 
    final result = await Navigator.of(context).push<LocationResult>(
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialLat: profile.latitude,
          initialLng: profile.longitude,
          initialAddress: profile.address,
        ),
      ),
    );
    if (result == null || !mounted) return;
 
    final ok = await ref
        .read(providerServicesControllerProvider.notifier)
        .updateProfile(
          businessName: profile.businessName,
          description: profile.description,
          area: profile.area,
          address: result.address,
          latitude: result.latitude,
          longitude: result.longitude,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Lokasi provider diperbarui' : 'Gagal memperbarui lokasi',
        ),
        backgroundColor: ok ? Colors.green : AppTheme.danger,
      ),
    );
  }
 
  Future<void> _showAddServiceDialog(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final categories = ref.read(categoriesProvider).valueOrNull ?? const [];
    int? categoryId = categories.isNotEmpty ? categories.first.id : null;
    var isSaving = false;

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            // Keep the action buttons outside the scrollable content. This lets
            // the form shrink and scroll on short screens or when the keyboard
            // is open, instead of overflowing over the buttons.
            return AlertDialog(
              scrollable: true,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              title: const Text('Tambah Layanan'),
              content: SizedBox(
                width: 360,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTextField(
                        controller: nameCtrl,
                        label: 'Nama Layanan',
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Nama layanan wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: categoryId,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Kategori'),
                        hint: const Text('Pilih kategori'),
                        items: categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category.id,
                                child: Text(
                                  category.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        validator: (value) => value == null
                            ? 'Kategori wajib dipilih'
                            : null,
                        onChanged: isSaving || categories.isEmpty
                            ? null
                            : (value) => setDialogState(() => categoryId = value),
                      ),
                      if (categories.isEmpty) ...[
                        const SizedBox(height: 6),
                        const Text(
                          'Kategori belum tersedia. Tutup dialog dan coba lagi.',
                          style: TextStyle(color: AppTheme.danger),
                        ),
                      ],
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: descriptionCtrl,
                        label: 'Deskripsi (opsional)',
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: isSaving || categories.isEmpty
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;

                          setDialogState(() => isSaving = true);
                          final controller = ref.read(
                            providerServicesControllerProvider.notifier,
                          );
                          final ok = await controller.createService(
                            categoryId: categoryId!,
                            name: nameCtrl.text.trim(),
                            description: descriptionCtrl.text.trim(),
                            // Harga dikonfirmasi langsung oleh provider;
                            // kolom API tetap diisi nilai default agar layanan
                            // dapat dibuat tanpa form harga.
                            basePrice: 0,
                            priceUnit: null,
                          );
                          if (!mounted || !dialogContext.mounted) return;

                          if (ok) {
                            Navigator.pop(dialogContext);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Layanan ditambahkan')),
                            );
                            return;
                          }

                          setDialogState(() => isSaving = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                controller.state.errorMessage ??
                                    'Gagal menambahkan layanan',
                              ),
                              backgroundColor: AppTheme.danger,
                            ),
                          );
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        ),
      );
    } finally {
      nameCtrl.dispose();
      descriptionCtrl.dispose();
    }
  }

  void _showEditServiceDialog(BuildContext context, ProviderService service) {
    final nameCtrl = TextEditingController(text: service.name);
    final descriptionCtrl = TextEditingController(text: service.description ?? '');
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Layanan'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            AppTextField(controller: nameCtrl, label: 'Nama Layanan'),
            const SizedBox(height: 12),
            AppTextField(controller: descriptionCtrl, label: 'Deskripsi', maxLines: 2),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              final ok = await ref.read(providerServicesControllerProvider.notifier).updateService(
                serviceId: service.id,
                name: name,
                description: descriptionCtrl.text.trim(),
              );
              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(ok ? 'Layanan berhasil diperbarui' : 'Gagal memperbarui layanan')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteService(ProviderService service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Layanan?'),
        content: Text('Hapus layanan "${service.name}"? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final controller = ref.read(providerServicesControllerProvider.notifier);
    final ok = await controller.deleteService(service.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Layanan berhasil dihapus'
              : controller.state.errorMessage ?? 'Gagal menghapus layanan',
        ),
        backgroundColor: ok ? Colors.green : AppTheme.danger,
      ),
    );
=======
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => const ProviderServiceDialog(),
          );
          if (result == true) {
            if (!context.mounted) return;
            ref.read(providerServicesControllerProvider.notifier).refreshProfile();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Layanan baru berhasil ditambahkan')),
            );
          }
        },
        tooltip: 'Tambah Layanan',
        child: const Icon(Icons.add),
      ),

    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}

class ProviderProfileDialog extends ConsumerStatefulWidget {
  final ProviderProfile profile;

  const ProviderProfileDialog({super.key, required this.profile});

  @override
  ConsumerState<ProviderProfileDialog> createState() => _ProviderProfileDialogState();
}

class _ProviderProfileDialogState extends ConsumerState<ProviderProfileDialog> {
  late final TextEditingController _businessNameCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _areaCtrl;
  late final TextEditingController _addressCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _businessNameCtrl = TextEditingController(text: widget.profile.businessName);
    _descriptionCtrl = TextEditingController(text: widget.profile.description ?? '');
    _areaCtrl = TextEditingController(text: widget.profile.area ?? '');
    _addressCtrl = TextEditingController(text: widget.profile.address ?? '');
  }

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _descriptionCtrl.dispose();
    _areaCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    final controller = ref.read(providerServicesControllerProvider.notifier);
    final success = await controller.updateProfile(
      businessName: _businessNameCtrl.text.trim(),
      description: _descriptionCtrl.text.trim().isEmpty ? null : _descriptionCtrl.text.trim(),
      area: _areaCtrl.text.trim().isEmpty ? null : _areaCtrl.text.trim(),
      address: _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
    );
    setState(() => _isSaving = false);
    if (success && mounted) {
      // Invalidate provider detail cache so other pages reflect the update
      try {
        ref.invalidate(providerDetailProvider(widget.profile.id));
      } catch (_) {}
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profil Provider'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _businessNameCtrl,
            decoration: InputDecoration(
              labelText: 'Nama Usaha',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionCtrl,
            decoration: InputDecoration(
              labelText: 'Deskripsi',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _areaCtrl,
            decoration: InputDecoration(
              labelText: 'Area',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _addressCtrl,
            decoration: InputDecoration(
              labelText: 'Alamat',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveProfile,
          child: _isSaving ? const CircularProgressIndicator() : const Text('Simpan'),
        ),
      ],
    );
  }
}

class ProviderServiceDialog extends ConsumerStatefulWidget {
  final ProviderService? service;

  const ProviderServiceDialog({super.key, this.service});

  @override
  ConsumerState<ProviderServiceDialog> createState() => _ProviderServiceDialogState();
}

class _ProviderServiceDialogState extends ConsumerState<ProviderServiceDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _unitCtrl;
  bool _isSaving = false;

  late Future<List<ServiceCategory>> _categoriesFuture;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.service?.name ?? '');
    _priceCtrl = TextEditingController(text: widget.service?.basePrice.toString() ?? '');
    _unitCtrl = TextEditingController(text: widget.service?.priceUnit ?? '');
    if (widget.service == null) {
      _categoriesFuture = _loadCategories();
    } else {
      _selectedCategoryId = widget.service?.categoryId;
      _categoriesFuture = Future.value([]);
    }
  }

  Future<List<ServiceCategory>> _loadCategories() async {
    final api = ref.read(apiServiceProvider);
    final response = await api.getCategories();
    final categories = response.data;
    if (categories.isNotEmpty) {
      _selectedCategoryId = categories.first.id;
    }
    return categories;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _unitCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final controller = ref.read(providerServicesControllerProvider.notifier);
    final name = _nameCtrl.text.trim();
    final price = int.tryParse(_priceCtrl.text.trim()) ?? 0;
    final unit = _unitCtrl.text.trim();

    if (name.isEmpty || price <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama layanan dan harga harus diisi dengan benar')),
      );
      setState(() => _isSaving = false);
      return;
    }

    final selectedCategoryId = widget.service?.categoryId ?? _selectedCategoryId;
    if (selectedCategoryId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori layanan harus dipilih')),
      );
      setState(() => _isSaving = false);
      return;
    }

    final success = widget.service == null
        ? await controller.createService(
            categoryId: selectedCategoryId,
            name: name,
            basePrice: price,
            priceUnit: unit.isEmpty ? 'per_job' : unit,
          )
        : await controller.updateService(
            serviceId: widget.service!.id,
            name: name,
            basePrice: price,
            priceUnit: unit.isEmpty ? 'per_job' : unit,
          );

    setState(() => _isSaving = false);
    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.service == null ? 'Tambah Layanan' : 'Edit Layanan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.service == null)
            FutureBuilder<List<ServiceCategory>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('Gagal memuat kategori: ${snapshot.error}'),
                  );
                }

                final categories = snapshot.data ?? [];
                return DropdownButtonFormField<int>(
                  initialValue: _selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: categories
                      .map(
                        (category) => DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  },
                );
              },
            ),
          if (widget.service != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Text(
                    'Kategori: ${widget.service?.categoryName ?? 'Tidak tersedia'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: 'Nama Layanan',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceCtrl,
            decoration: InputDecoration(
              labelText: 'Harga Dasar',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _unitCtrl,
            decoration: InputDecoration(
              labelText: 'Satuan Harga (contoh: per kunjungan)',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving ? const CircularProgressIndicator() : const Text('Simpan'),
        ),
      ],
    );
>>>>>>> d11988a502d317c7882c6ee4cfdd1998a9b97034
  }
}
