import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cafeapp/screens/homepage.dart';
import 'package:cafeapp/main.dart';
import 'package:cafeapp/screens/signup_screen.dart';
import 'package:cafeapp/screens/adminpanel.dart';

class CafeRestaurantLogin extends StatefulWidget {
  const CafeRestaurantLogin({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<CafeRestaurantLogin> {
  final TextEditingController mailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login(BuildContext ctx) async {
    if (mailcontroller.text.trim().isEmpty || passwordcontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text("Lütfen e-posta ve şifre giriniz.")),
      );
      return;
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: mailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );

      if (mailcontroller.text.trim().toLowerCase() == "admin@gmail.com" &&
          passwordcontroller.text.trim() == "123456789") {
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (ctx) => const AdminPage()),
        );
      } else {
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (ctx) => const MyHomePage(title: 'Flutter Demo Ana Sayfa')),
        );
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException code: ${e.code}");
      print("FirebaseAuthException message: ${e.message}");
      print("FirebaseAuthException: ${e.toString()}");

      String errorMessage = "Bir hata oluştu.";

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "Hata: Bu e-posta ile kayıtlı kullanıcı bulunamadı.";
          break;
        case 'wrong-password':
          errorMessage = "Hata: Yanlış şifre girdiniz.";
          break;
        case 'invalid-email':
          errorMessage = "Hata: Geçersiz e-posta formatı.";
          break;
        case 'invalid-credential':
          errorMessage = "Hata: Geçersiz kimlik bilgisi (yanlış mail veya şifre).";
          break;
        case 'user-disabled':
          errorMessage = "Hata: Bu kullanıcı devre dışı bırakılmış.";
          break;
        case 'too-many-requests':
          errorMessage = "Hata: Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin.";
          break;
        default:
          errorMessage = "Hata (belirlenemeyen): ${e.message}";
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(errorMessage)));

    } catch (e) {
      // Firebase dışı hata yakalama
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text("Bilinmeyen hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'resimler/cafe_restaurant_bg.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          SingleChildScrollView(
            padding:
            const EdgeInsets.symmetric(horizontal: 32.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'CAFE · RESTAURANT',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 80),
                _InputField(
                  icon: Icons.person_outline,
                  hint: 'Kullanıcı Adı',
                  obscure: false,
                  controller: mailcontroller,
                ),
                const SizedBox(height: 24),
                _InputField(
                  icon: Icons.lock_outline,
                  hint: 'Parola',
                  obscure: true,
                  controller: passwordcontroller,
                ),
                const SizedBox(height: 40),
                _PrimaryButton(
                  label: 'Giriş',
                  onPressed: () {
                    login(context);
                  },
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context)=> const CafeRestaurantSignUp(),),
                    );
                  },
                  child: const Text(
                    'Kayıt Ol',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context)=> const MyHomePage(title: 'Flutter Demo Ana Sayfa'),),
                    );
                  },
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Giriş yapmadan devam et',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final TextEditingController controller;

  const _InputField({
    required this.icon,
    required this.hint,
    required this.obscure,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.brown[700]),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7B4A32),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(label,
            style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
