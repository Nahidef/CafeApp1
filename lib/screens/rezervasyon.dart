import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';


class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  int _personCount = 2;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  List<TimeOfDay> _generateTimeSlots() {
    List<TimeOfDay> slots = [];
    for (int hour = 10; hour <= 22; hour++) {
      slots.add(TimeOfDay(hour: hour, minute: 0));
    }
    return slots;
  }
  Future<void> titreSim() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500); // 1 saniye titreşim
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCCF),
      appBar: AppBar(
        title: const Text('Rezervasyon', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF8B4513),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kişi Sayısı',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_personCount > 1) _personCount--;
                      });
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    _personCount.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _personCount++;
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Tarih Seç',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    DateTime date = DateTime.now().add(Duration(days: index));
                    bool isSelected = date.day == _selectedDate.day &&
                        date.month == _selectedDate.month &&
                        date.year == _selectedDate.year;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.brown : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz']
                              [date.weekday - 1],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text('Saat Seç',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _generateTimeSlots()
                    .map((time) => _buildTimeChip(time))
                    .toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async{
                    if(_selectedTime == null){
                      await titreSim();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Lütfen bir saat seçin")),
                      );

                      return;
                    }
                    final user=FirebaseAuth.instance.currentUser;
                    if(user == null){
                      await titreSim();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Lütfen giriş yapınız")),

                      );

                      return;
                    }

                    try{
                      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('reservation')
                          .add({
                        'personcount':_personCount,
                        'date':DateTime(_selectedDate.year,_selectedDate.month,_selectedDate.day,).toIso8601String(),
                        'time':_selectedTime!.format(context),'createdAt':FieldValue.serverTimestamp(),

                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${_selectedDate.day}/${_selectedDate.month} tarihinde saat ${_selectedTime!.format(context)} için rezervasyon kaydedildi!'),
                        ),
                      );
                    }catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hata oluştu: $e')),
                      );
                    }



                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Rezervasyonu Onayla',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(TimeOfDay time) {
    bool isSelected = _selectedTime == time;
    return ChoiceChip(
      label: Text(
        time.format(context),
        style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500),
      ),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedTime = time;
        });
      },
      selectedColor: Colors.brown,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
