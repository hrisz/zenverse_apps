import 'package:flutter/material.dart';

class MyLoginpage extends StatefulWidget {
  const MyLoginpage({super.key});

  @override
  State<MyLoginpage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/icon/blue-logo.png',
          height: 30,
        ),
        backgroundColor: const Color.fromARGB(255, 54, 57, 62),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/loginwp.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 114, 137, 218),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Welcome back there!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Warna teks tetap kontras
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;
                    // tes static data dulu, sebelum login pake API
                    print('Email: $email');
                    print('Password: $password');
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
