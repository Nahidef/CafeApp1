import 'dart:async';

import 'package:flutter/material.dart';

class OffersPage extends StatefulWidget {
  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final List<Map<String, dynamic>> offers = [
    {
      'image': 'resimler/new1.jpg',
      'title': 'Doğum günü partilerinde net %25 indirim',
      'endDate': DateTime(2025, 6, 25), // 25 Haziran 2025
    },
    {
      'image': 'resimler/new2.jpg',
      'title': 'En iyi selfie yarışmasını kazan, kahve ve tatlı hediye!',
      'endDate': DateTime(2025, 6, 10), // 10 Haziran 2025
    },
    {
      'image': 'resimler/new3.jpg',
      'title': 'Bir kahve alana bir kahve hediye',
      'endDate': DateTime(2025, 6, 10), // 10 Haziran 2025
    },
    {
      'image': 'resimler/new4.jpg',
      'title': 'Babalar gününe özel %50 indirim',
      'endDate': DateTime(2025, 6, 15), // 15 Haziran 2025
    },
    {
      'image': 'resimler/new5.jpg',
      'title': 'Öğrencilere sınav haftalarında geçerli sınırsız kahve',
      'endDate': DateTime(2025, 7, 10), // 10 Temmuz 2025
    },
    {
      'image': 'resimler/new6.jpg',
      'title': 'Pazartesi sendromunu at, kahveni %25 indirimli al!',
      'endDate': DateTime(2025, 7, 28), // 28 Temmuz 2025
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B3423),
        title: const Text(
          'Kampanyalar',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: offers.map((offer) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    offer['image']!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          CountdownTimer(endDate: offer['endDate']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime endDate;

  const CountdownTimer({Key? key, required this.endDate}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.endDate.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = widget.endDate.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String timerText;
    if (_remainingTime.isNegative) {
      timerText = "Kampanya sona erdi!";
    } else {
      timerText =
      "Kalan süre: ${_remainingTime.inDays}g ${_remainingTime.inHours.remainder(24)}s ${_remainingTime.inMinutes.remainder(60)}dk";
    }

    return Text(
      timerText,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
      ),
    );
  }
}