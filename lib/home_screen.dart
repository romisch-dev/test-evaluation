import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:itti_test/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  void _logout(BuildContext context) {
    // Aquí puedes agregar la lógica para cerrar sesión
    // y redireccionar al login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
    //Navigator.pushReplacementNamed(context, '/login');
  }

  int _currentPage = 1;

  Future<List<dynamic>> _fetchUsers(int page) async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Error al obtener la lista de usuarios');
    }
  }

  void _showScreen(BuildContext context, int index) {
    final randomNumber = Random().nextInt(100) + 1;
    if (randomNumber < 20) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActiveClientScreen(randomNumber: randomNumber),
        ),
      );
    } else if (randomNumber % 20 == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              InactiveClientScreen(randomNumber: randomNumber),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlockedClientScreen(randomNumber: randomNumber),
        ),
      );
    }
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchUsers(_currentPage),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error al cargar la lista de usuarios'),
                  );
                } else {
                  final userList = snapshot.data;
                  if (userList != null) {
                    return ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        final user = userList[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user['avatar']),
                          ),
                          title: Text(
                            '${user['first_name']} ${user['last_name']}',
                          ),
                          subtitle: TextButton(
                            onPressed: () {
                              _showScreen(context, index);
                            },
                            style: ButtonStyle(
                              alignment: Alignment.centerLeft,
                              overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['email'],
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No se encontraron usuarios'),
                    );
                  }
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _changePage(1);
                },
                child: const Text('Página 1'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  _changePage(2);
                },
                child: const Text('Página 2'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActiveClientScreen extends StatelessWidget {
  final int randomNumber;

  const ActiveClientScreen({Key? key, required this.randomNumber})
      : super(key: key);

  Widget _buildEmoji() {
    return const Text('😄', style: TextStyle(fontSize: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cliente Activo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Cliente Activo',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            _buildEmoji(),
            const SizedBox(height: 16),
            Text(
              'Número aleatorio: $randomNumber',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class InactiveClientScreen extends StatelessWidget {
  final int randomNumber;

  const InactiveClientScreen({Key? key, required this.randomNumber})
      : super(key: key);

  Widget _buildEmoji() {
    return const Text('😢', style: TextStyle(fontSize: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cliente Inactivo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Cliente Inactivo',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            _buildEmoji(),
            const SizedBox(height: 16),
            Text(
              'Número aleatorio: $randomNumber',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class BlockedClientScreen extends StatelessWidget {
  final int randomNumber;

  const BlockedClientScreen({Key? key, required this.randomNumber})
      : super(key: key);

  Widget _buildEmoji() {
    return const Text('😮', style: TextStyle(fontSize: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cliente Bloqueado'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Cliente Bloqueado',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            _buildEmoji(),
            const SizedBox(height: 16),
            Text(
              'Número aleatorio: $randomNumber',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
