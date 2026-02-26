import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';

// 1. إعداد الاتصال بـ Supabase
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://avhiiflllxanphearpbv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF2aGlpZmxsbHhhbnBoZWFycGJ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIwNTcwNDAsImV4cCI6MjA4NzYzMzA0MH0.1p6eWt8u9mHfzMQxL1GuWLpfzyENORFvjfCj6TSR2bg',
  );

  runApp(const AgriSmartProApp());
}

class AgriSmartProApp extends StatelessWidget {
  const AgriSmartProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriSmart Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        textTheme: GoogleFonts.montserratTextTheme(),
        useMaterial3: true,
      ),
      home: const ProductSelectionScreen(),
    );
  }
}

// --- 1. Product Selection Screen ---
class ProductSelectionScreen extends StatefulWidget {
  const ProductSelectionScreen({super.key});
  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  int? selectedIndex;
  final List<Map<String, String>> products = const [
    {'name': 'Framboise & Myrtille', 'img': 'https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/Framboise%20&%20Myrtille.jpeg'},
    {'name': 'Fraise', 'img': 'https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/Fraise.jpg'},
    {'name': 'Orange', 'img': 'https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/Orange.jpg'},
    {'name': 'Clémentine', 'img': 'https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/clementines.jpg'},
    {'name': 'Tomate', 'img': 'https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/Tomate.jpeg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(opacity: 0.45),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Center(child: Image.network('https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/Logo_AgriSmart_pro.png', height: 95)),
                const SizedBox(height: 25),
                Text('Bienvenue sur AgriSmart Pro 🌱', 
                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('Choisissez votre culture.', 
                  style: GoogleFonts.montserrat(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                const SizedBox(height: 25),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Wrap(
                      spacing: 15, runSpacing: 25, alignment: WrapAlignment.center,
                      children: List.generate(products.length, (index) => _buildProductCard(index)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: _buildMainButton('CONFIRMER', () {
                    if (selectedIndex == null) {
                      _showMsg("Veuillez choisir une culture 🌱", Colors.orangeAccent);
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RoleSelectionScreen()));
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating));
  }

  Widget _buildProductCard(int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: MediaQuery.of(context).size.width * 0.43, height: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: isSelected ? 20 : 10, offset: const Offset(5, 5))],
          border: isSelected ? Border.all(color: const Color(0xFF81C784), width: 3) : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(child: Image.network(products[index]['img']!, fit: BoxFit.cover)),
              Align(alignment: Alignment.bottomCenter, child: Container(width: double.infinity, padding: const EdgeInsets.all(8), color: Colors.black54, child: Text(products[index]['name']!.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)))),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 2. Role Selection Screen ---
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _showAdminDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1B3022).withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("ACCÈS ADMIN", style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Entrez le code secret pour continuer.", style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Code Secret",
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER", style: TextStyle(color: Colors.white38))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF81C784)),
              onPressed: () {
                if (controller.text == "ADMIN2026") {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen(role: "Admin")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Code Incorrect!"), backgroundColor: Colors.redAccent));
                }
              },
              child: const Text("VALIDER", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(opacity: 0.55),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.network('https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/Logo_AgriSmart_pro.png', height: 70),
                const SizedBox(height: 20),
                Text('IDENTIFIEZ-VOUS 🌱', style: GoogleFonts.montserrat(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 35),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    children: [
                      _RoleCard(
                        title: 'Agent de suivi (Cabrane)', 
                        icon: Icons.edit_document, 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen(role: "Agent de Suivi"))),
                      ),
                      _RoleCard(
                        title: 'Agent de pointage', 
                        icon: Icons.fingerprint_rounded, 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen(role: "Agent de Pointage"))),
                      ),
                      _RoleCard(
                        title: 'Chef de ferme', 
                        icon: Icons.agriculture_rounded, 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen(role: "Chef de Ferme"))),
                      ),
                      _RoleCard(
                        title: 'Administration', 
                        icon: Icons.admin_panel_settings_rounded, 
                        onTap: () => _showAdminDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(top: 40, left: 10, child: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context))),
        ],
      ),
    );
  }
}

// --- 3. Fiche de Suivi (Page Placeholder) ---
class FicheSuiviScreen extends StatelessWidget {
  const FicheSuiviScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(opacity: 0.8),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.assignment_add, size: 80, color: Color(0xFF81C784)),
                const SizedBox(height: 20),
                Text("Interface Suivi Activée", style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: _buildMainButton("DÉMARRER RÉCOLTE", () {
                    // هنا سنضع جدول الجني لاحقاً
                  }),
                ),
              ],
            ),
          ),
          Positioned(top: 40, left: 10, child: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context))),
        ],
      ),
    );
  }
}

// --- Role Card Component ---
class _RoleCard extends StatelessWidget {
  final String title; final IconData icon; final VoidCallback onTap;
  const _RoleCard({required this.title, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1), 
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: Colors.white.withValues(alpha: 0.12))
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF81C784)),
            const SizedBox(width: 20),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white30),
          ],
        ),
      ),
    );
  }
}

// --- Login Screen الحقيقي ---
class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  Future<void> _signIn() async {
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _pass.text.trim(),
      );
      // إذا نجح الدخول، نمر لصفحة تتبع الجني (مثال)
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FicheSuiviScreen()));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: ${e.toString()}"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(opacity: 0.65),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Image.network('https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/Logo_AgriSmart_pro.png', height: 80),
                  const SizedBox(height: 20),
                  Text('CONNEXION', style: GoogleFonts.montserrat(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                  Text(widget.role.toUpperCase(), style: const TextStyle(color: Color(0xFF81C784), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  _buildGlassInput(controller: _email, hint: 'Email', icon: Icons.email_outlined),
                  const SizedBox(height: 20),
                  _buildGlassInput(controller: _pass, hint: 'Mot de passe', icon: Icons.lock_outline, isPass: true),
                  const SizedBox(height: 30),
                  _loading 
                    ? const CircularProgressIndicator(color: Color(0xFF81C784))
                    : _buildMainButton('SE CONNECTER', _signIn),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Nouveau ici ?", style: TextStyle(color: Colors.white70)),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen(role: widget.role))),
                        child: const Text("Créer un compte", style: TextStyle(color: Color(0xFF81C784), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 10, child: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context))),
        ],
      ),
    );
  }
}

// --- SignUp Screen الحقيقي ---
class SignUpScreen extends StatefulWidget {
  final String role;
  const SignUpScreen({super.key, required this.role});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  Future<void> _signUp() async {
    setState(() => _loading = true);
    try {
      // 1. إنشاء الحساب في Auth
      final res = await Supabase.instance.client.auth.signUp(
        email: _email.text.trim(),
        password: _pass.text.trim(),
        data: {'full_name': _name.text, 'role': widget.role},
      );
      
      // 2. تحديث جدول الـ Profiles
      if (res.user != null) {
        await Supabase.instance.client.from('profiles').upsert({
          'id': res.user!.id,
          'full_name': _name.text,
          'role': widget.role,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Compte créé! Vérifiez votre email."), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: ${e.toString()}"), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(opacity: 0.65),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text('INSCRIPTION', style: GoogleFonts.montserrat(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                  Text(widget.role.toUpperCase(), style: const TextStyle(color: Color(0xFF81C784), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  _buildGlassInput(controller: _name, hint: 'Nom complet', icon: Icons.person_outline),
                  const SizedBox(height: 20),
                  _buildGlassInput(controller: _email, hint: 'Email', icon: Icons.email_outlined),
                  const SizedBox(height: 20),
                  _buildGlassInput(controller: _pass, hint: 'Mot de passe', icon: Icons.lock_outline, isPass: true),
                  const SizedBox(height: 30),
                  _loading 
                    ? const CircularProgressIndicator(color: Color(0xFF81C784))
                    : _buildMainButton("S'INSCRIRE", _signUp),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 10, child: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context))),
        ],
      ),
    );
  }
}

// --- Clean Helpers ---
Widget _buildBackground({double opacity = 0.45}) {
  return Stack(
    children: [
      Positioned.fill(child: Image.network('https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/background.jpg', fit: BoxFit.cover)),
      Positioned.fill(child: Container(color: Colors.black.withValues(alpha: opacity))),
    ],
  );
}

Widget _buildGlassInput({required TextEditingController controller, required String hint, required IconData icon, bool isPass = false}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint, hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: const Color(0xFF81C784)),
          filled: true, fillColor: Colors.white.withValues(alpha: 0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        ),
      ),
    ),
  );
}

Widget _buildMainButton(String text, VoidCallback? onPressed) {
  return SizedBox(
    width: double.infinity, height: 60,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF81C784), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), elevation: 0),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    ),
  );
}
