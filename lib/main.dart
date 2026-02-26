import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AgriSmartApp());
}

class AgriSmartApp extends StatelessWidget {
  const AgriSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriSmart Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // اعتماد خط Montserrat المطلوب
        textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
      ),
      home: const ProductSelectionScreen(),
    );
  }
}

class ProductSelectionScreen extends StatelessWidget {
  const ProductSelectionScreen({super.key});

  // قائمة المنتجات بروابط Supabase الخاصة بك
  final List<Map<String, String>> products = const [
    {
      'name': 'Framboise & Myrtille', 
      'img': 'https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/Framboise%20&%20Myrtille.jpeg'
    },
    {
      'name': 'Fraise', 
      'img': 'https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/Fraise.jpg'
    },
    {
      'name': 'Orange', 
      'img': 'https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/Orange.jpg'
    },
    {
      'name': 'Clémentine', 
      'img': 'https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/clementines.jpg'
    },
    {
      'name': 'Tomate', 
      'img': 'https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/Tomate.jpeg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A0B), // خلفية خضراء داكنة جداً
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header مع اللوغو الخاص بك
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Image.network(
                'https://avhiiflllxanphearpbv.supabase.co/storage/v1/object/public/farm_assets/AgriSmart_Logo.png',
                height: 60,
                fit: BoxFit.contain,
                // في حالة فشل تحميل اللوغو تظهر أيقونة بديلة
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.eco, color: Colors.green, size: 40),
              ),
            ),
            
            // ترحيب
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BIENVENUE !',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFFFA000), 
                      fontSize: 32, 
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Veuillez choisir votre domaine de suivi.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // شبكة المنتجات (Cards)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.85,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                      image: DecorationImage(
                        image: NetworkImage(products[index]['img']!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4), 
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          products[index]['name']!.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 14,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // زر التأكيد
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: ElevatedButton(
                onPressed: () {
                  // غانبرمجو الانتقال للصفحة الجاية من بعد
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 65),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                ),
                child: const Text(
                  'CONFIRMER', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
