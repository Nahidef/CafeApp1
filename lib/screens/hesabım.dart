import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cafeapp/screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  String email = '';
  String adSoyad = '';
  String telefon = '';
  List<Map<String, dynamic>> reservations = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      verileriGetir();
    }
  }

  Future<void> verileriGetir() async {
    final uid = user!.uid;
    final mail = user!.email ?? 'Email yok';

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final userData = userDoc.data() ?? {};
      final adSoyadTemp = userData['name'] ?? 'Ad soyad yok';
      final telefonTemp = userData['phone'] ?? 'Telefon yok';

      final reservationSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('reservation')
          .orderBy('date', descending: true)
          .get();

      final reservationsTemp = reservationSnapshot.docs.map((doc) {
        try {
          final data = doc.data();
          final dateStr = data['date'] as String? ?? '';
          final date = DateTime.tryParse(dateStr) ?? DateTime.now();
          final time = data['time'] ?? 'Saat yok';
          final personCount = data['personcount']?.toString() ?? '0';

          return {
            'date': date,
            'formattedDate': "${date.day} ${_ayAdi(date.month)} ${date.year}",
            'time': time,
            'personCount': personCount,
          };
        } catch (e) {
          debugPrint('Rezervasyon verisi parse hatası: $e');
          return null;
        }
      }).whereType<Map<String, dynamic>>().toList();

      setState(() {
        email = mail;
        adSoyad = adSoyadTemp;
        telefon = telefonTemp;
        reservations = reservationsTemp;
      });
    } catch (e) {
      debugPrint('Veri çekme hatası: $e');
    }
  }

  String _ayAdi(int ay) {
    const aylar = [
      '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return (ay >= 1 && ay <= 12) ? aylar[ay] : 'Geçersiz';
  }

  @override
  Widget build(BuildContext context) {
    // Kullanıcı giriş yapmamışsa sadece uyarı göster
    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFE8DCCF),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.redAccent),
                const SizedBox(height: 20),
                const Text(
                  'Giriş yapmamışsınız.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CafeRestaurantLogin()),
                    );
                  },
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text('Giriş Yap', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCCF),
      appBar: AppBar(
        title: const Text('Hesabım', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF8B4513),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('resimler/avatar.jpg'),
              backgroundColor: Colors.brown.shade200,
            ),
            const SizedBox(height: 16),
            Text(
              adSoyad.isNotEmpty ? adSoyad : 'Ad Soyad Yükleniyor...',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoTile(Icons.phone, telefon.isNotEmpty ? telefon : '...'),
            const SizedBox(height: 8),
            _buildInfoTile(Icons.email, email.isNotEmpty ? email : '...'),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Rezervasyonlarım',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            reservations.isEmpty
                ? const Text('Henüz bir rezervasyon yok.')
                : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reservations.length,
              separatorBuilder: (context, index) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final r = reservations[index];
                return ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.brown),
                  title: Text(
                    "${r['formattedDate']} - ${r['time']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    "${r['personCount']} kişi",
                    style: const TextStyle(color: Colors.brown),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Çıkış Yap"),
                      content: const Text("Çıkış yapmak istediğinize emin misiniz?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text("İptal"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text("Evet"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CafeRestaurantLogin()),
                    );
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Çıkış Yap', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String info) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.brown),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              info,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
