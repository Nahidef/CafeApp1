import 'package:flutter/material.dart';
import 'package:cafeapp/screens/urundetay_espresso.dart';
import 'package:cafeapp/Product.dart';

class MenuScreen extends StatelessWidget {
   MenuScreen({super.key});


   final List<Map<String,String>> menuitem = const[
     {'gorsel':'resimler/menu1.jpg', 'kategori': 'Espresso Bazlı Kahveler'},
     {'gorsel':'resimler/menu2.jpg',  'kategori':  'Filtre Kahveler'},
     {'gorsel':'resimler/menu3.jpg',  'kategori':'Özel Kahveler'},
      {'gorsel':'resimler/menu4.jpg', 'kategori':'Soğuk Kahveler'},
      {'gorsel':'resimler/menu5.jpg','kategori': 'Geleneksel Kahveler'},
     {'gorsel':'resimler/menu6.jpg', 'kategori':    'Tatlılar'},
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCCF),
      appBar: AppBar(
        title: const Text('Menü',
            style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,)),
        backgroundColor: Colors.brown[700],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menuitem.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final item = menuitem[index];
          final img = item['gorsel']!;
          final title = item['kategori']!;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(category:item['kategori']!),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(img, fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.35)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
