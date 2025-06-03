import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafeapp/screens/login_screen.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<List<Map<String, dynamic>>> veriCek() async {
    final List<Map<String, dynamic>> sonuc = [];

    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    for (var userDoc in usersSnapshot.docs) {
      final userData = userDoc.data();
      final userId = userDoc.id;

      final rezervasyonSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('reservation')
          .get();

      for (var rezervasyonDoc in rezervasyonSnapshot.docs) {
        final rezervasyonData = rezervasyonDoc.data();

        final dynamic dateField = rezervasyonData['date'];
        DateTime date;

        if (dateField is Timestamp) {
          date = dateField.toDate();
        } else if (dateField is String) {
          date = DateTime.tryParse(dateField) ?? DateTime.now();
        } else {
          date = DateTime.now();
        }

        final formattedDate = "${date.day} ${_ayAdi(date.month)} ${date.year}";

        sonuc.add({
          'tarih': formattedDate,
          'saat': rezervasyonData['time'],
          'kisiSayisi': rezervasyonData['personcount'].toString(),
          'telefon': userData['phone'],
          'adSoyad': userData['name'],
        });
      }
    }

    return sonuc;
  }

  String _ayAdi(int ay) {
    const aylar = [
      '',
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    return (ay >= 1 && ay <= 12) ? aylar[ay] : 'Geçersiz';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCCF),
      appBar: AppBar(
        backgroundColor: Colors.brown[700],
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Rezervasyonlar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
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
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: veriCek(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu.'));
          }

          final veriler = snapshot.data ?? [];

          if (veriler.isEmpty) {
            return const Center(child: Text('Hiç rezervasyon yok.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: veriler.length,
            itemBuilder: (context, index) {
              final rezervasyon = veriler[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rezervasyon['tarih'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 20),
                          const SizedBox(width: 8),
                          Text('${rezervasyon['tarih']} - ${rezervasyon['saat']}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 20),
                          const SizedBox(width: 8),
                          Text('${rezervasyon['kisiSayisi']} Kişi'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 20),
                          const SizedBox(width: 8),
                          Text(rezervasyon['telefon']),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 20),
                          const SizedBox(width: 8),
                          Text(rezervasyon['adSoyad']),
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
}
