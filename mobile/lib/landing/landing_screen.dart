import 'package:flutter/material.dart';
import '../features/auth/login_page.dart';

// Brand tokens: navy, orange, cream, white
const Color _navy = Color(0xFF0D2B55);
const Color _navyDeep = Color(0xFF081B38);
const Color _navyTint = Color(0xFFE7EBF3);
const Color _orange = Color(0xFFF97316);
const Color _orangeTint = Color(0xFFFFF1E6);
const Color _cream = Color(0xFFF5EFE6);
const Color _white = Colors.white;

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scroll = ScrollController();

  void _goLogin() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scroll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopBar(onLogin: _goLogin),
              _HeroSection(onGetStarted: _goLogin, isDesktop: isDesktop),
              const SizedBox(height: 28),
              _ServicesSection(),
              const SizedBox(height: 28),
              _StatsSection(),
              const SizedBox(height: 28),
              _HowItWorksSection(),
              const SizedBox(height: 28),
              _FinalCta(onTap: _goLogin),
              const SizedBox(height: 16),
              const _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onLogin;
  const _TopBar({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _white,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.handyman, color: _white),
              ),
              const SizedBox(width: 12),
              const Text(
                'TukangDekat',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Layanan',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Cara Kerja',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Masuk / Daftar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final VoidCallback onGetStarted;
  final bool isDesktop;
  const _HeroSection({required this.onGetStarted, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _navy,
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 60 : 36,
        horizontal: 28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: isDesktop
              ? Row(
                  children: [
                    Expanded(child: _HeroText(onGetStarted: onGetStarted)),
                    const SizedBox(width: 24),
                    const Expanded(child: _HeroVisual()),
                  ],
                )
              : Column(
                  children: [
                    _HeroText(onGetStarted: onGetStarted),
                    const SizedBox(height: 20),
                    const SizedBox(height: 260, child: _HeroVisual()),
                  ],
                ),
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final VoidCallback onGetStarted;
  const _HeroText({required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Butuh Tukang Terpercaya di Sekitarmu?',
          style: TextStyle(color: _orangeTint, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Text(
          'Layanan Rumah dan Perbaikan Cepat',
          style: TextStyle(
            color: _white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Pesan tukang profesional: listrik, AC, plumbing, renovasi, dan lebih banyak lagi. Harga transparan, teknisi terverifikasi, dan garansi pekerjaan.',
          style: TextStyle(
            color: _white.withAlpha((0.9 * 255).round()),
            fontSize: 16,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            ElevatedButton(
              onPressed: onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Mulai Sekarang'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: _white,
                side: BorderSide(color: _white.withAlpha((0.18 * 255).round())),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Pelajari Lebih Lanjut'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: const [
            _StatChip(icon: Icons.star, label: '4.9 Rating'),
            SizedBox(width: 12),
            _StatChip(icon: Icons.groups, label: '50k+ Pengguna'),
            SizedBox(width: 12),
            _StatChip(icon: Icons.work, label: '30k+ Job selesai'),
          ],
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: _navyDeep,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: _orangeTint,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.local_shipping,
                              size: 56,
                              color: _navy,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: _white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.house_siding,
                              size: 56,
                              color: _navy,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: _white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MiniInfo(icon: Icons.check, label: 'Terverifikasi'),
                      _MiniInfo(icon: Icons.lock, label: 'Aman & Terpercaya'),
                      _MiniInfo(
                        icon: Icons.support_agent,
                        label: 'Dukungan 24/7',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MiniInfo({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _navy, size: 22),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _white.withAlpha((0.06 * 255).round()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: _orange, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: _white)),
        ],
      ),
    );
  }
}

class _ServicesSection extends StatelessWidget {
  final List<Map<String, dynamic>> _services = const [
    {'icon': Icons.bolt, 'title': 'Listrik'},
    {'icon': Icons.ac_unit, 'title': 'AC'},
    {'icon': Icons.plumbing, 'title': 'Plumbing'},
    {'icon': Icons.home_repair_service, 'title': 'Renovasi'},
    {'icon': Icons.tv, 'title': 'Elektronik'},
    {'icon': Icons.handyman, 'title': 'Teknisi'},
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final columns = width > 1000 ? 3 : (width > 700 ? 2 : 1);

    return Container(
      color: _cream,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Layanan Kami',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisExtent: 110,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _services.length,
                itemBuilder: (context, idx) {
                  final s = _services[idx];
                  return _ServiceCard(icon: s['icon'], title: s['title']);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  const _ServiceCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _navyDeep,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _NumberStat(number: '50k+', label: 'Pengguna'),
              _NumberStat(number: '30k+', label: 'Tugas Selesai'),
              _NumberStat(number: '4.9', label: 'Rating Rata-rata'),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberStat extends StatelessWidget {
  final String number;
  final String label;
  const _NumberStat({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: _white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: _white)),
      ],
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _white,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cara Kerja',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _StepTile(
                    number: '1',
                    title: 'Pilih Layanan',
                    desc: 'Pilih tukang dan lihat estimasi harga.',
                  ),
                  _StepTile(
                    number: '2',
                    title: 'Terima Konfirmasi',
                    desc: 'Teknisi terverifikasi akan dihubungi.',
                  ),
                  _StepTile(
                    number: '3',
                    title: 'Kerja Selesai',
                    desc: 'Bayar setelah pekerjaan selesai.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final String number;
  final String title;
  final String desc;
  const _StepTile({
    required this.number,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _navyTint,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _orange,
              child: Text(number, style: const TextStyle(color: _white)),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(desc, style: const TextStyle(color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

class _FinalCta extends StatelessWidget {
  final VoidCallback onTap;
  const _FinalCta({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _navy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Siap Memperbaiki Sekarang?',
                        style: TextStyle(
                          color: _white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Pesan tukang terpercaya dalam hitungan menit.',
                        style: TextStyle(color: _white),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Mulai Sekarang'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _navyDeep,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'TukangDekat',
                    style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hubungi kami: support@tukangdekat.id',
                    style: TextStyle(color: _white),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text('© 2026 TukangDekat', style: TextStyle(color: _white)),
                  SizedBox(height: 6),
                  Text('Syarat & Ketentuan', style: TextStyle(color: _white)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
