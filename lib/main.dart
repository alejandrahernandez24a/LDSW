
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello World',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mi primera app Flutter'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. TEXT
                  const Text(
                    'Hello World',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text('Uno'),
                      Text('Dos'),
                      Text('Tres'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 3. CONTAINER
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: const Text(
                      'Soy un Container',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. STACK
                  Center(
                    child: SizedBox(
                      width: 250,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 250,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade200,
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                          ),
                          const Text(
                            'Texto sobrepuesto',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 5. COLUMN
                  const Column(
                    children: [
                      Text('Primera línea'),
                      Text('Segunda línea'),
                      Text('Tercera línea'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
