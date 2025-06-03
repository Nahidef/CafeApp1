import 'package:flutter/material.dart';
import 'package:cafeapp/Product.dart';

class ProductListScreen extends StatelessWidget {
  final String category;
   ProductListScreen({super.key, required this.category});


   final List<Product> allProducts = [
      Product(name: "Americano",
         description: "Espresso üzerine sıcak su eklenerek hazırlanan, sade ve hafif içimli bir kahve.",
         image: "resimler/Americano.png",
         category: "Espresso Bazlı Kahveler",
         price: 70.0),

      Product(name: "Cappuccino",
         description: "Yoğun süt köpüğü ve espresso karışımı, klasik ve dengeli bir tat.",
         image: "resimler/Cappuccino.png",
         category: "Espresso Bazlı Kahveler",
         price: 80.0),

      Product(name: "Dalgona Coffee",
         description: "Çırpılmış kahve kreması ve sütle yapılan, görselliğiyle öne çıkan modern bir içecek.",
         image: "resimler/Cappuccino.png",
         category: "Espresso Bazlı Kahveler",
         price: 90.0),

      Product(name: "Latte",
         description: "Bol sütlü ve yumuşak içimli bir espresso bazlı kahve.",
         image: "resimler/Latte.png",
         category: "Espresso Bazlı Kahveler",
         price: 85.0),

      Product(name: "Macchiato",
         description: "Espresso üzerine bir miktar süt köpüğü eklenerek yapılan yoğun aromalı kahve.",
         image: "resimler/Macchiato.png",
         category: "Espresso Bazlı Kahveler",
         price: 80.0),

      Product(name: "Mocha",
         description: "Çikolata ve espresso karışımının sütle birleştiği tatlı ve yoğun bir kahve.",
         image: "resimler/Mocha.png",
         category: "Espresso Bazlı Kahveler",
         price: 95.0),
     new Product(name: "Classic Drip",
         description: "Makine ile hazırlanan klasik filtre kahve. Temiz ve yumuşak bir içim sunar.",
         image: "resimler/ClassicDrip.png",
         category: "Filtre Kahveler",
         price: 65.0),

     new Product(name: "Chemex",
         description: "Cam haznesi ve özel filtresiyle aromaları ön plana çıkaran şık bir demleme yöntemi.",
         image: "resimler/Chemex.png",
         category: "Filtre Kahveler",
         price: 75.0),

     new Product(name: "Cold Brew",
         description: "Soğuk suyla uzun sürede demlenen düşük asiditeli, ferahlatıcı kahve.",
         image: "resimler/ColdBrew.png",
         category: "Filtre Kahveler",
         price: 80.0),

     new Product(name: "French Press",
         description: "Kalın öğütülmüş kahveyle yapılan, gövdeli ve yoğun aromalı klasik filtre yöntemi.",
         image: "resimler/FrenchPress.png",
         category: "Filtre Kahveler",
         price: 70.0),

     new Product(name: "Pour Over",
         description: "Elle dökülen sıcak suyla filtre kahvenin nazikçe demlendiği yöntem.",
         image: "resimler/PourOver.png",
         category: "Filtre Kahveler",
         price: 75.0),

     new Product(name: "AeroPress",
         description: "Basınçla kısa sürede hazırlanan, yoğun ve düşük asiditeli filtre kahve.",
         image: "resimler/AeroPress.png",
         category: "Filtre Kahveler",
         price: 78.0),
     new Product(name: "Ethiopian Coffee",
         description: "Afrika'nın en eski kahvelerinden biri. Meyvemsi ve çiçeksi aromalarıyla ünlü.",
         image: "resimler/Ethipoin.png",
         category: "Geleneksel Kahveler",
         price: 90.0),

     new Product(name: "Vietnamese Egg Coffee",
         description: "Yoğun kahvenin üstünde tatlı ve kremsi yumurta köpüğüyle geleneksel Vietnam kahvesi.",
         image: "resimler/VietnameseEggCoffee.png",
         category: "Geleneksel Kahveler",
         price: 95.0),

     new Product(name: "Arap Kahvesi",
         description: "Kakule ile harmanlanan ve cezvede pişirilen baharatlı ve aromatik bir kahve.",
         image: "resimler/ArapKahvesi.png",
         category: "Geleneksel Kahveler",
         price: 85.0),

     new Product(name: "Bosna Kahvesi",
         description: "Türk kahvesine benzeyen ancak farklı sunum ve demleme yöntemiyle öne çıkan Balkan kahvesi.",
         image: "resimler/BosnaKahvesi.png",
         category: "Geleneksel Kahveler",
         price: 88.0),

     new Product(name: "Greek Coffee",
         description: "Yoğun kıvamlı, fincanda pişen ve telvesiyle servis edilen geleneksel Yunan kahvesi.",
         image: "resimler/GreekCoffee.png",
         category: "Geleneksel Kahveler",
         price: 87.0),

     new Product(name: "Türk Kahvesi",
         description: "Köpüklü, telveli ve kültürel öneme sahip geleneksel Türk kahvesi.",
         image: "resimler/TürkKahvesi.png",
         category: "Geleneksel Kahveler",
         price: 85.0),
     new Product(name: "Espresso Con Panna",
         description: "Espresso'nun üzerine krema eklenerek yapılan zengin ve tatlı bir kahve deneyimi.",
         image: "resimler/EspressoConPanna.png",
         category: "Özel Kahveler",
         price: 92.0),

     new Product(name: "Nitro Cold Brew",
         description: "Soğuk demleme kahvenin nitrojenle zenginleştirilmiş hali. Köpüklü ve ipeksi bir doku sunar.",
         image: "resimler/NitroColdBrew.png",
         category: "Özel Kahveler",
         price: 100.0),

     new Product(name: "Flat White",
         description: "İnce buharlanmış süt ve güçlü espresso ile dengeli ve kremamsı bir kahve.",
         image: "resimler/FlatWhite.png",
         category: "Özel Kahveler",
         price: 88.0),

     new Product(name: "Ristretto",
         description: "Kısa sürede elde edilen yoğun ve aromatik bir espresso türü.",
         image: "resimler/Ristretto.png",
         category: "Özel Kahveler",
         price: 87.0),

     new Product(name: "Cortado",
         description: "Eşit oranlarda espresso ve sıcak sütle yapılan dengeli ve yumuşak içimli kahve.",
         image: "resimler/Cortado.png",
         category: "Özel Kahveler",
         price: 89.0),

     new Product(name: "Dalgona Coffee",
         description: "Çırpılmış kahve köpüğü ile süslenen sütlü ve görsel olarak cezbedici bir içecek.",
         image: "resimler/DalgonaCoffeee.png",
         category: "Özel Kahveler",
         price: 93.0),
     new Product(
         name: "Nitro Cold Brew",
         description: "Azotla zenginleştirilmiş, ipeksi dokulu ve serinletici bir soğuk kahve deneyimi.",
         image: "resimler/NitroColdBrew2.png",
         category: "Soğuk Kahveler",
         price: 98.0
     ),

     new Product(
         name: "Frappe",
         description: "Buzla harmanlanmış, köpüklü ve tatlı kahve lezzetiyle ferahlatıcı bir içecek.",
         image: "resimler/Frappe.png",
         category: "Soğuk Kahveler",
         price: 87.0
     ),

     new Product(
         name: "Affogato",
         description: "Soğuk dondurmanın üzerine dökülen sıcak espresso ile tatlı ve yoğun bir kahve keyfi.",
         image: "resimler/Affogato.png",
         category: "Soğuk Kahveler",
         price: 102.0
     ),

     new Product(
         name: "Cold Brew",
         description: "Uzun sürede soğuk demleme yöntemiyle hazırlanan, düşük asiditeli serin bir kahve.",
         image: "resimler/ColdBrew2.png",
         category: "Soğuk Kahveler",
         price: 92.0
     ),

     new Product(
         name: "Iced Americano",
         description: "Buzla servis edilen espresso bazlı sade ve güçlü kahve tadı.",
         image: "resimler/IcedAmericano.png",
         category: "Soğuk Kahveler",
         price: 85.0
     ),

     new Product(
         name: "Iced Mocha",
         description: "Çikolata aroması ile zenginleştirilmiş buzlu sütlü kahve, tatlı ve ferahlatıcı.",
         image: "resimler/IcedMocha.png",
         category: "Soğuk Kahveler",
         price: 95.0
     ),
     new Product(
         name: "Cheesecake",
         description: "Krem peynir dolgulu, tabanı bisküvili ve meyve sosuyla taçlandırılmış nefis bir tatlı.",
         image: "resimler/Cheesecake.png",
         category: "Tatlılar",
         price: 75.0
     ),

     new Product(
         name: "Tiramisu",
         description: "Kahveli ve kremalı katmanlarıyla İtalyan mutfağının efsanevi tatlısı.",
         image: "resimler/Tiramisu.png",
         category: "Tatlılar",
         price: 80.0
     ),

     new Product(
         name: "Macaron",
         description: "Renkli ve çıtır dış kabuğu ile içi yumuşak, aromalı Fransız tatlısı.",
         image: "resimler/Macaron.png",
         category: "Tatlılar",
         price: 65.0
     ),

     new Product(
         name: "Çikolatalı Fondant",
         description: "İçi akışkan çikolata dolgulu, dışı yumuşacık kek kıvamında sıcak bir lezzet.",
         image: "resimler/ÇikolatalıFondant.png",
         category: "Tatlılar",
         price: 85.0
     ),

     new Product(
         name: "Profiterol",
         description: "İnce hamurun içine saklanmış krema ve üzerini kaplayan çikolata sosuyla klasik bir tatlı.",
         image: "resimler/Profiterol.png",
         category: "Tatlılar",
         price: 78.0
     ),






   ];


  @override
  Widget build(BuildContext context) {
    final filtered = allProducts.where((p) => p.category == category).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFE8DCCF),
      appBar: AppBar(
        backgroundColor: Colors.brown[700],
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title:  Text(
            category,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.black26),
          itemBuilder: (context, index) {
            final product = filtered[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      product.image,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('₺ ${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.lightGreen, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(
                          product.description,
                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

      ),
    );
  }
}