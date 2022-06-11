import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

// Class ProfileScreen digunakan untuk menampilkan halaman setelah user berhasil login
// untuk saat ini halaman tersebut hanya bertuliskan "Welcome"
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// Class ProfileScreen menggunakan Stateful Widget
class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // Menggunakan scaffold, dan body untuk menampilkan child di tengah layar
    return Scaffold(
      body: Center(
        // Menggunakan Widget child: Text untuk menampilkan tulisan "Welcome"
        child: Text("Welcome"),
      ),
    );
  }
}
