import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import package dart:convert agar dapat menggunakan json.decode, untuk membantu dalam membaca data JSON API
import 'dart:convert';

// Class ProfileScreen menggunakan StatelessWidget dikarenakan tidak ada widget yang berubah saat berinteraksi dengan user.
class ProfileScreen extends StatelessWidget {
  // Alamat dari API yang digunakan, dari reqres.in
  final String apiUrl = "https://reqres.in/api/users?per_page=15";
  // Coding di bawah ini digunakan untuk memanggil API dari string API URL menggunakan http.get
  // selanjunya menggunakan fitur Future, await, dan async untuk  menunggu proses seblumnya, agar saat login berhasil kemudian baru mengambil data
  Future<List<dynamic>> _fecthDataUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    // berikut adalah json.decode yang digunakan untuk membantu membaca data string JSON dari API URL. Kemudian disimpan pada var 'data'
    return json.decode(result.body)['data'];
  }

  // Coding di bawah ini digunakan untuk dekorasi tampilan atau UI aplikasi
  @override
  Widget build(BuildContext context) {
    // Menggunakan Scaffold
    return Scaffold(
      // Dekorasidari AppBar berupa tulisan Profile Screen berwarna biru
      appBar: AppBar(
        backgroundColor: const Color(0xFF0069FE),
        title: const Text('Profile Screen'),
      ),
      // Merupakan body dari halaman Profile, menggunakan containter dan List<dynamic> karena tidak dilakukan output dari hasil fetch API
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: _fecthDataUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // Tampilkan Data API berupa profile beberapa orang berbentuk list dan berupa photo profile, nama, dan email.
              // Coding di bawah ini mengatur tampilan Profile Screen
              return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Dekorasi avatar atau photo profile agar berbentuk circle
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            // Membaca 'data' dari decode json API
                            NetworkImage(snapshot.data[index]['avatar']),
                      ),
                      // Membaca 'data' dari decode json API
                      title: Text(snapshot.data[index]['first_name'] +
                          " " +
                          snapshot.data[index]['last_name']),
                      subtitle: Text(snapshot.data[index]['email']),
                    );
                  });
            } else {
              // Jika data API belum ada, tampilkan animasi loading
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
