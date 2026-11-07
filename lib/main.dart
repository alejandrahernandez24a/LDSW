
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// Modelo para almacenar los datos del Pokemon
class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String image;
  final List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.image,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      image: json['sprites']['front_default'] ?? '',
      types: (json['types'] as List)
          .map((type) => type['type']['name'].toString())
          .toList(),
    );
  }
}

// Funcion para consultar la API
Future<Pokemon> fetchPokemon(String name) async {
  final response = await http.get(
    Uri.parse(
      'https://pokeapi.co/api/v2/pokemon/${name.toLowerCase().trim()}',
    ),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return Pokemon.fromJson(data);
  } else {
    throw Exception('No se encontro el Pokemon');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
        useMaterial3: true,
      ),
      home: const PokemonPage(),
    );
  }
}

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final TextEditingController controller =
      TextEditingController(text: 'pikachu');

  late Future<Pokemon> pokemon;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    pokemon = fetchPokemon('pikachu');
  }

  void searchPokemon() {
    final name = controller.text.trim();

    if (name.isNotEmpty) {
      setState(() {
        pokemon = fetchPokemon(name);
      });
    }
  }

  // Funcion para guardar Pokemon en Firebase
  Future<void> savePokemon(Pokemon p) async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('pokemones')
          .doc(p.id.toString())
          .set({
        'id': p.id,
        'name': p.name,
        'height': p.height,
        'weight': p.weight,
        'image': p.image,
        'types': p.types,
        'fechaRegistro': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${p.name.toUpperCase()} guardado en Firebase'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar en Firebase: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'POKEDEX FLUTTER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Nombre o numero del Pokemon',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: searchPokemon,
                ),
              ),
              onSubmitted: (_) => searchPokemon(),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<Pokemon>(
                future: pokemon,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Pokemon no encontrado. Intenta nuevamente.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    final p = snapshot.data!;

                    return Card(
                      elevation: 5,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                '#${p.id}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Image.network(
                                p.image,
                                height: 180,
                                width: 180,
                                errorBuilder: (context, error, stack) {
                                  return const Icon(
                                    Icons.catching_pokemon,
                                    size: 150,
                                  );
                                },
                              ),
                              Text(
                                p.name.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'Tipo: ${p.types.join(', ')}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Altura: ${p.height / 10} m',
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Peso: ${p.weight / 10} kg',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 20),

                              // Boton para guardar en Firebase
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: isSaving
                                      ? null
                                      : () => savePokemon(p),
                                  icon: isSaving
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.cloud_upload),
                                  label: Text(
                                    isSaving
                                        ? 'Guardando...'
                                        : 'Guardar en Firebase',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
