import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/site_footer.dart';
import '../../core/models/order_model.dart';
import '../../core/models/provider_model.dart';
import '../../core/services/api_service.dart';
import '../auth/auth_controller.dart';
import 'my_orders_page.dart';
import 'order_providers.dart';

class CreateOrderPage extends ConsumerStatefulWidget {
  final int providerId;
  final int categoryId;
  final List<ProviderService> services;

  const CreateOrderPage({
    super.key,
    required this.providerId,
    required this.categoryId,
    required this.services,
  });

  @override
  ConsumerState<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends ConsumerState<CreateOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _attachmentUrlsCtrl = TextEditingController();
  final _imagePicker = ImagePicker();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  ProviderService? _selectedService;
  List<Map<String, dynamic>> _kotaList = [];
  List<Map<String, dynamic>> _kecamatanList = [];
  int? _selectedKotaId;
  int? _selectedKecamatanId;
  bool _isLoadingWilayah = false;
  List<XFile> _damagePhotos = [];

  @override
  void initState() {
    super.initState();
    // Set default ke service pertama jika ada
    if (widget.services.isNotEmpty) {
      _selectedService = widget.services.first;
    }
    Future.microtask(_loadKota);
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    _attachmentUrlsCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _pickDamagePhotos() async {
    final photos = await _imagePicker.pickMultiImage(imageQuality: 82);
    if (photos.isEmpty || !mounted) return;
    setState(() {
      _damagePhotos = photos.take(5).toList();
    });
  }

  Future<void> _loadKota() async {
    setState(() => _isLoadingWilayah = true);
    try {
      final api = ref.read(apiServiceProvider);
      final kota = await api.getKota();
      if (!mounted) return;
      setState(() {
        _kotaList = kota;
        _selectedKotaId = kota.isNotEmpty
            ? (kota.first['id'] as num).toInt()
            : null;
      });
      if (_selectedKotaId != null) {
        await _loadKecamatan(_selectedKotaId!);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memuat daftar wilayah'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoadingWilayah = false);
    }
  }

  Future<void> _loadKecamatan(int kotaId) async {
    final api = ref.read(apiServiceProvider);
    final kecamatan = await api.getKecamatan(kotaId);
    if (!mounted) return;
    setState(() {
      _kecamatanList = kecamatan;
      _selectedKecamatanId = kecamatan.isNotEmpty
          ? (kecamatan.first['id'] as num).toInt()
          : null;
    });
  }

  Future<void> _createOrder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih tanggal'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jam'), backgroundColor: Colors.red),
      );
      return;
    }
    if (_selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih layanan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedKotaId == null || _selectedKecamatanId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kota dan kecamatan layanan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = CreateOrderRequest(
      providerId: widget.providerId,
      categoryId: widget.categoryId,
      providerServiceId: _selectedService?.id,
      kotaId: _selectedKotaId!,
      kecamatanId: _selectedKecamatanId!,
      scheduleAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        ),
      ),
      address: _addressCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      estimatedPrice: _selectedService?.basePrice,
      attachmentUrls: _attachmentUrlsCtrl.text.trim().isEmpty
          ? null
          : _attachmentUrlsCtrl.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      attachmentPaths: _damagePhotos.map((photo) => photo.path).toList(),
    );

    final success = await ref
        .read(createOrderControllerProvider.notifier)
        .createOrder(request);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order berhasil dibuat!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MyOrdersPage()),
      );
    } else {
      final errorMsg =
          ref.read(createOrderControllerProvider).errorMessage ?? 'Order gagal';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createOrderControllerProvider);
    final authState = ref.watch(authControllerProvider);

    if (authState.userRole != 'CUSTOMER') {
      return Scaffold(
        appBar: AppBar(title: const Text('Buat Order')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.block, size: 72, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Hanya pelanggan (CUSTOMER) dapat membuat order.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Order')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detail Order',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              // Pilih Layanan
              Text(
                'Pilih Layanan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (widget.services.isNotEmpty)
                DropdownButton<ProviderService>(
                  isExpanded: true,
                  value: _selectedService,
                  items: widget.services.map((service) {
                    return DropdownMenuItem(
                      value: service,
                      child: Text(
                        '${service.name} - Rp${service.basePrice}/${service.priceUnit}',
                      ),
                    );
                  }).toList(),
                  onChanged: (ProviderService? newService) {
                    setState(() => _selectedService = newService);
                  },
                )
              else
                const Text('Tidak ada layanan tersedia'),
              const SizedBox(height: 24),

              Text(
                'Wilayah Layanan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (_isLoadingWilayah)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(),
                )
              else ...[
                DropdownButtonFormField<int>(
                  value: _selectedKotaId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Kota',
                    prefixIcon: const Icon(Icons.location_city),
                    errorText: state.fieldErrors['kota_id'],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _kotaList.map((item) {
                    final id = (item['id'] as num).toInt();
                    return DropdownMenuItem<int>(
                      value: id,
                      child: Text(item['name']?.toString() ?? '-'),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    if (value == null) return;
                    setState(() {
                      _selectedKotaId = value;
                      _selectedKecamatanId = null;
                      _kecamatanList = [];
                    });
                    await _loadKecamatan(value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _selectedKecamatanId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Kecamatan',
                    prefixIcon: const Icon(Icons.map_outlined),
                    errorText: state.fieldErrors['kecamatan_id'],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _kecamatanList.map((item) {
                    final id = (item['id'] as num).toInt();
                    return DropdownMenuItem<int>(
                      value: id,
                      child: Text(item['name']?.toString() ?? '-'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedKecamatanId = value);
                  },
                ),
              ],
              const SizedBox(height: 16),

              // Alamat
              AppTextField(
                controller: _addressCtrl,
                label: 'Alamat Lokasi',
                maxLines: 3,
                prefixIcon: const Icon(Icons.location_on),
                errorText: state.fieldErrors['address'],
                validator: (v) {
                  if ((v ?? '').trim().isEmpty) return 'Alamat wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Catatan
              AppTextField(
                controller: _notesCtrl,
                label: 'Catatan Tambahan (opsional)',
                maxLines: 3,
                prefixIcon: const Icon(Icons.note),
                errorText: state.fieldErrors['notes'],
              ),
              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: _pickDamagePhotos,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(
                  _damagePhotos.isEmpty
                      ? 'Upload Foto Kerusakan'
                      : '${_damagePhotos.length} foto dipilih',
                ),
              ),
              if (state.fieldErrors['damage_photos.0'] != null) ...[
                const SizedBox(height: 6),
                Text(
                  state.fieldErrors['damage_photos.0']!,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                ),
              ],
              const SizedBox(height: 8),
              AppTextField(
                controller: _attachmentUrlsCtrl,
                label: 'URL Foto Tambahan (opsional, 1 URL per baris)',
                maxLines: 2,
                prefixIcon: const Icon(Icons.link),
                errorText: state.fieldErrors['attachment_urls.0'],
              ),
              const SizedBox(height: 16),

              // Tanggal
              Text('Tanggal Pekerjaan'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate != null
                            ? DateFormat('dd MMM yyyy').format(_selectedDate!)
                            : 'Pilih tanggal',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Jam
              Text('Jam Pekerjaan'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 12),
                      Text(
                        _selectedTime != null
                            ? _selectedTime!.format(context)
                            : 'Pilih jam',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Pembayaran',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Akan ada 2 tahap pembayaran'),
                    const Text('• DP 50% saat order diterima'),
                    const Text('• Sisa 50% saat pekerjaan selesai'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // CTA
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Buat Order',
                  isLoading: state.isLoading,
                  onPressed: _createOrder,
                ),
              ),

              if (state.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const TukangDekatFooter(),
    );
  }
}
