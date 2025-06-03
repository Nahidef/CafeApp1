import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cafeapp/screens/login_screen.dart';


class CafeRestaurantSignUp extends StatefulWidget {
  const CafeRestaurantSignUp({super.key});

  @override
  State<CafeRestaurantSignUp> createState() => _CafeRestaurantSignUpState();
}

class _CafeRestaurantSignUpState extends State<CafeRestaurantSignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signUp() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String name = nameController.text.trim();
    final String phone = phoneController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun.")),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await addUserData(userCredential.user, name, phone);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CafeRestaurantLogin()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Bir hata oluştu. Lütfen tekrar deneyin.";

      switch (e.code) {
        case 'weak-password':
          errorMessage = "Şifre çok zayıf.";
          break;
        case 'email-already-in-use':
          errorMessage = "Bu e-posta zaten kullanımda.";
          break;
        case 'invalid-email':
          errorMessage = "Geçersiz e-posta formatı.";
          break;
        case 'operation-not-allowed':
          errorMessage = "E-posta/şifre ile giriş devre dışı bırakılmış.";
          break;
        case 'too-many-requests':
          errorMessage = "Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin.";
          break;
        default:
          errorMessage = "Hata: ${e.message}";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // FirebaseAuthException dışında bir hata olursa
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Beklenmeyen hata: $e")),
      );
    }
  }

  Future<void> addUserData(User? user, String name, String phone) async {
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(user.uid).set({
        'name': name,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt başarılı!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B3423),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CafeRestaurantLogin()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Text(
              'KAYIT OL',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            _InputField(
              icon: Icons.person_outline,
              hint: 'Ad Soyad',
              obscure: false,
              controller: nameController,
            ),
            const SizedBox(height: 24),

            _InputField(
              icon: Icons.phone_outlined,
              hint: 'Telefon Numarası',
              obscure: false,
              keyboard: TextInputType.phone,
              controller: phoneController,
            ),
            const SizedBox(height: 24),

            _InputField(
              icon: Icons.email_outlined,
              hint: 'E‑posta',
              obscure: false,
              keyboard: TextInputType.emailAddress,
              controller: emailController,
            ),
            const SizedBox(height: 24),

            _InputField(
              icon: Icons.lock_outline,
              hint: 'Parola',
              obscure: true,
              controller: passwordController,
            ),
            const SizedBox(height: 40),

            _PrimaryButton(
              label: 'Kayıt Ol',
              onPressed: _signUp,
            ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final TextInputType? keyboard;
  final TextEditingController controller;

  const _InputField({
    required this.icon,
    required this.hint,
    required this.obscure,
    this.keyboard,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        style: const TextStyle(fontSize: 16, color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white60),
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
          backgroundColor: const Color(0xFFB28355),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
