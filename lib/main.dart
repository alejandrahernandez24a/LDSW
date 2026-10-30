
import 'package:flutter/material.dart';

void main() {
  runApp(const HevaApp());
}

class HevaApp extends StatelessWidget {
  const HevaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HEVA Compliance',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

        
          Image.asset(
            'assets/images/fondo_heva.jpg',
            fit: BoxFit.cover,
          ),

         
          Container(
            color: Colors.black.withValues(alpha: 0.45),
          ),

          
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                
                  Image.asset(
                    'assets/images/icono.png',
                    width: 120,
                    height: 120,
                  ),

                  const SizedBox(height: 25),

                  // Logotipo
                  Image.asset(
                    'assets/images/logotipo_heva.png',
                    width: 550,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    '¡Bienvenido!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Soluciones jurídicas, mediación y '
                      'cumplimiento normativo a tu alcance.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
