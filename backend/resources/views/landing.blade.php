@extends('layouts.customer')

@section('title', 'TukangDekat - Platform Jasa Lokal Terpercaya')

@section('content')
<div style="background-color: #f5efe6; min-height: 100vh;">
    <!-- Hero Section -->
    <section style="background-color: #0d2b55; color: white; padding: 3rem 1.5rem;">
        <div class="container">
            <div class="row align-items-center justify-content-center">
                <div class="col-12 text-center">
                    <!-- Badge -->
                    <div style="display: inline-block; padding: 0.5rem 1rem; background-color: rgba(249, 115, 22, 0.15); border: 1px solid rgba(249, 115, 22, 0.35); border-radius: 20px; margin-bottom: 1.5rem;">
                        <span style="color: #f97316; font-size: 0.75rem; font-weight: 600; letter-spacing: 0.3px;">⚡ Platform Jasa Lokal Terpercaya</span>
                    </div>

                    <!-- Logo -->
                    <div style="margin-bottom: 1rem;">
                        <div style="width: 88px; height: 88px; background-color: #f97316; border-radius: 20px; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
                            <span style="font-size: 2rem;">🔧</span>
                        </div>
                    </div>

                    <!-- Headline -->
                    <h1 style="font-size: 2rem; font-weight: 800; margin-bottom: 1rem; line-height: 1.25;">
                        Solusi Rumah Anda<br>Ada di <span style="color: #f97316;">TukangDekat</span>
                    </h1>

                    <!-- Subtext -->
                    <p style="color: rgba(255, 255, 255, 0.7); font-size: 0.95rem; margin-bottom: 2rem; line-height: 1.6; max-width: 500px; margin-left: auto; margin-right: auto;">
                        Hubungkan kebutuhan perbaikan rumah Anda dengan teknisi profesional di Kecamatan Bojongloa Kaler secara cepat dan transparan.
                    </p>

                    <!-- Stats -->
                    <div style="border-top: 1px solid rgba(255, 255, 255, 0.08); padding-top: 1.5rem; margin-bottom: 2rem;">
                        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; max-width: 400px; margin: 0 auto;">
                            <div>
                                <div style="color: #f97316; font-size: 1.25rem; font-weight: 700;">500+</div>
                                <div style="color: rgba(255, 255, 255, 0.6); font-size: 0.75rem;">Mitra Teknisi</div>
                            </div>
                            <div>
                                <div style="color: #f97316; font-size: 1.25rem; font-weight: 700;">2.4rb</div>
                                <div style="color: rgba(255, 255, 255, 0.6); font-size: 0.75rem;">Pesanan Selesai</div>
                            </div>
                            <div>
                                <div style="color: #f97316; font-size: 1.25rem; font-weight: 700;">4.9 ★</div>
                                <div style="color: rgba(255, 255, 255, 0.6); font-size: 0.75rem;">Rating Rata-rata</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section style="padding: 3rem 1.5rem;">
        <div class="container">
            <div style="margin-bottom: 2rem;">
                <p style="color: #f97316; font-size: 0.75rem; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 0.5rem;">LAYANAN KAMI</p>
                <h2 style="color: #0d2b55; font-size: 1.5rem; font-weight: 800; margin-bottom: 0.5rem;">Semua Kebutuhan Rumah</h2>
                <p style="color: #9ca3af; font-size: 0.85rem;">5 kategori layanan profesional siap membantu Anda</p>
            </div>

            <!-- Grid Services -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1rem; margin-bottom: 1.5rem;">
                <!-- Service Card 1 -->
                <div style="background: white; padding: 1rem; border-radius: 1rem; border: 1px solid #e8e0d5;">
                    <div style="width: 44px; height: 44px; background-color: #fff3ec; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 0.75rem;">⚡</div>
                    <h5 style="color: #0d2b55; font-size: 0.85rem; font-weight: 600; margin-bottom: 0.25rem;">Instalasi Listrik</h5>
                    <p style="color: #9ca3af; font-size: 0.75rem; line-height: 1.4; margin-bottom: 0.5rem; flex-grow: 1;">Pemasangan, perbaikan & pengecekan instalasi listrik rumah</p>
                    <span style="display: inline-block; padding: 0.25rem 0.5rem; background-color: #fff3ec; border-radius: 6px; color: #f97316; font-size: 0.75rem; font-weight: 600;">Tersedia 24/7</span>
                </div>

                <!-- Service Card 2 -->
                <div style="background: white; padding: 1rem; border-radius: 1rem; border: 1px solid #e8e0d5;">
                    <div style="width: 44px; height: 44px; background-color: #eef3fa; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 0.75rem;">🔧</div>
                    <h5 style="color: #0d2b55; font-size: 0.85rem; font-weight: 600; margin-bottom: 0.25rem;">Plumbing & Pipa</h5>
                    <p style="color: #9ca3af; font-size: 0.75rem; line-height: 1.4; margin-bottom: 0.5rem; flex-grow: 1;">Saluran air, kebocoran pipa, dan instalasi wastafel</p>
                    <span style="display: inline-block; padding: 0.25rem 0.5rem; background-color: #fff3ec; border-radius: 6px; color: #f97316; font-size: 0.75rem; font-weight: 600;">Respon Cepat</span>
                </div>

                <!-- Service Card 3 -->
                <div style="background: white; padding: 1rem; border-radius: 1rem; border: 1px solid #e8e0d5;">
                    <div style="width: 44px; height: 44px; background-color: #fff3ec; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 0.75rem;">❄️</div>
                    <h5 style="color: #0d2b55; font-size: 0.85rem; font-weight: 600; margin-bottom: 0.25rem;">Service AC</h5>
                    <p style="color: #9ca3af; font-size: 0.75rem; line-height: 1.4; margin-bottom: 0.5rem; flex-grow: 1;">Cuci, isi freon, perbaikan & instalasi AC baru</p>
                    <span style="display: inline-block; padding: 0.25rem 0.5rem; background-color: #fff3ec; border-radius: 6px; color: #f97316; font-size: 0.75rem; font-weight: 600;">Bergaransi</span>
                </div>

                <!-- Service Card 4 -->
                <div style="background: white; padding: 1rem; border-radius: 1rem; border: 1px solid #e8e0d5;">
                    <div style="width: 44px; height: 44px; background-color: #eef3fa; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 0.75rem;">🏗️</div>
                    <h5 style="color: #0d2b55; font-size: 0.85rem; font-weight: 600; margin-bottom: 0.25rem;">Bangunan Ringan</h5>
                    <p style="color: #9ca3af; font-size: 0.75rem; line-height: 1.4; margin-bottom: 0.5rem; flex-grow: 1;">Renovasi, pengecatan, keramik & atap bocor</p>
                    <span style="display: inline-block; padding: 0.25rem 0.5rem; background-color: #fff3ec; border-radius: 6px; color: #f97316; font-size: 0.75rem; font-weight: 600;">Berpengalaman</span>
                </div>

                <!-- Service Card 5 (Full Width) -->
                <div style="background: white; padding: 1rem; border-radius: 1rem; border: 1px solid #e8e0d5; grid-column: span 1;">
                    <div style="display: flex; align-items: flex-start; gap: 1rem;">
                        <div style="width: 52px; height: 52px; background-color: #fff3ec; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 1.75rem; flex-shrink: 0;">📺</div>
                        <div style="flex: 1;">
                            <h5 style="color: #0d2b55; font-size: 0.9rem; font-weight: 600; margin-bottom: 0.25rem;">Service Elektronik</h5>
                            <p style="color: #9ca3af; font-size: 0.75rem; line-height: 1.4; margin-bottom: 0.5rem;">TV, mesin cuci, kulkas, pompa air & perangkat rumah tangga lainnya</p>
                            <span style="display: inline-block; padding: 0.25rem 0.5rem; background-color: #fff3ec; border-radius: 6px; color: #f97316; font-size: 0.75rem; font-weight: 600;">Teknisi Tersertifikasi</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section style="background-color: white; padding: 3rem 1.5rem; margin-top: 1.5rem;">
        <div class="container">
            <div style="margin-bottom: 2rem;">
                <p style="color: #f97316; font-size: 0.75rem; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 0.5rem;">CARA KERJA</p>
                <h2 style="color: #0d2b55; font-size: 1.5rem; font-weight: 800; margin-bottom: 0.5rem;">Mudah dalam 3 Langkah</h2>
                <p style="color: #9ca3af; font-size: 0.85rem;">Pesan layanan tanpa ribet, langsung dari HP Anda</p>
            </div>

            <div style="max-width: 600px;">
                <!-- Step 1 -->
                <div style="padding: 1rem 0; border-bottom: 1px solid #e8e0d5; display: flex; gap: 1rem;">
                    <div style="width: 36px; height: 36px; background-color: #0d2b55; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; flex-shrink: 0;">1</div>
                    <div style="flex: 1;">
                        <h5 style="color: #0d2b55; font-size: 0.9rem; font-weight: 600; margin-bottom: 0.25rem;">Pilih Layanan</h5>
                        <p style="color: #9ca3af; font-size: 0.85rem; line-height: 1.5;">Tentukan kategori jasa yang Anda butuhkan dan isi detail kerusakan</p>
                    </div>
                </div>

                <!-- Step 2 -->
                <div style="padding: 1rem 0; border-bottom: 1px solid #e8e0d5; display: flex; gap: 1rem;">
                    <div style="width: 36px; height: 36px; background-color: #0d2b55; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; flex-shrink: 0;">2</div>
                    <div style="flex: 1;">
                        <h5 style="color: #0d2b55; font-size: 0.9rem; font-weight: 600; margin-bottom: 0.25rem;">Pilih Teknisi</h5>
                        <p style="color: #9ca3af; font-size: 0.85rem; line-height: 1.5;">Bandingkan profil, rating, dan harga dari teknisi terdekat di sekitar Anda</p>
                    </div>
                </div>

                <!-- Step 3 -->
                <div style="padding: 1rem 0; display: flex; gap: 1rem;">
                    <div style="width: 36px; height: 36px; background-color: #0d2b55; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; flex-shrink: 0;">3</div>
                    <div style="flex: 1;">
                        <h5 style="color: #0d2b55; font-size: 0.9rem; font-weight: 600; margin-bottom: 0.25rem;">Selesai & Bayar</h5>
                        <p style="color: #9ca3af; font-size: 0.85rem; line-height: 1.5;">Teknisi datang, kerjakan, selesai. Bayar setelah pekerjaan tuntas</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section style="padding: 2rem 1.5rem; margin: 1.5rem;">
        <div class="container">
            <div style="background-color: #0d2b55; color: white; padding: 2rem; border-radius: 20px; text-align: center;">
                <h3 style="font-size: 1.2rem; font-weight: 800; margin-bottom: 0.75rem;">Siap Pesan Jasa Sekarang?</h3>
                <p style="color: rgba(255, 255, 255, 0.6); font-size: 0.85rem; margin-bottom: 1.5rem; line-height: 1.5;">Daftar gratis dan temukan teknisi terbaik di sekitar Anda dalam hitungan menit</p>
                <div style="display: flex; gap: 1rem; flex-direction: column;">
                    <button style="background-color: #f97316; color: white; border: none; padding: 1rem; border-radius: 12px; font-weight: 700; font-size: 0.95rem; cursor: pointer;">Mulai Sekarang</button>
                    <button style="background-color: transparent; color: white; border: 1px solid rgba(255, 255, 255, 0.24); padding: 1rem; border-radius: 12px; font-weight: 600; font-size: 0.9rem; cursor: pointer;">Daftar sebagai Mitra Teknisi</button>
                </div>
            </div>
        </div>
    </section>

    <!-- Trust Bar Section -->
    <section style="padding: 1.5rem 1.5rem 2rem;">
        <div class="container">
            <div style="background: white; padding: 1.5rem 1rem; border-radius: 20px; display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; text-align: center;">
                <div>
                    <div style="width: 42px; height: 42px; background-color: #fff3ec; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; margin: 0 auto 0.5rem;">🛡️</div>
                    <p style="color: #0d2b55; font-size: 0.85rem; font-weight: 600;">Terpercaya</p>
                </div>
                <div>
                    <div style="width: 42px; height: 42px; background-color: #fff3ec; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; margin: 0 auto 0.5rem;">⚡</div>
                    <p style="color: #0d2b55; font-size: 0.85rem; font-weight: 600;">Respon Cepat</p>
                </div>
                <div>
                    <div style="width: 42px; height: 42px; background-color: #fff3ec; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; margin: 0 auto 0.5rem;">💰</div>
                    <p style="color: #0d2b55; font-size: 0.85rem; font-weight: 600;">Transparan</p>
                </div>
            </div>
        </div>
    </section>
</div>
@endsection
