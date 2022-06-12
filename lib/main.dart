import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nurikhwan_195411077_projectakhir/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

// Class MyApp sebagai Class utama dan mengextend StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // BuildContext adalah locator yang digunakan untuk melacak setiap widget di tree dan menemukan mereka dan posisinya di tree.
  Widget build(BuildContext context) {
    // Menggunakan MaterialApp untuk menggunakan berbagai tool widget UI
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

// Class HomePage menggunakan StatefulWidget dikarenakan akan ada widget yang berubah saat berinteraksi dengan user(TextField)
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// CODE DI BAWAH INI DIGUNAKAN UNTUK MENG-INISIALISASI KE FIREBASE APP
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

// FutureBuilder digunakan untuk menjalankan fungsi async (email dan pass),
// dan berdasarkan fungsi tersebut akan mengupdate halaman UI
  @override
  // BuildContext adalah locator yang digunakan untuk melacak setiap widget di tree dan menemukan mereka dan posisinya di tree.
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const LoginScreen();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}

// Class LoginScreen menggunakan StatefulWIdget
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Class _LoginScreenState mengekstends class di atasnya, yang digunakan untuk autentikasi ke Firebase
class _LoginScreenState extends State<LoginScreen> {
  //Login function, memerlukan input string email dan password untuk melanjutkan proses autentikasi
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    // Mencoba autentikasi email dan password yang sudah diinput ke firebase
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      // jika user tidak ditemukan, maka akan print "No User found for that email" pada IDE
      if (e.code == "user-not-found") {
        print("No User found for that email");
      }
    }
    return user;
  }

  // CODE DI BAWAH INI DIGUNAKAN UNTUK MENGATUR TAMPILAN / DEKORASI UI DARI APLIKASI
  @override
  // BuildContext adalah locator yang digunakan untuk melacak setiap widget di tree dan menemukan mereka dan posisinya di tree.
  Widget build(BuildContext context) {
    // Membuat textfield controller untuk masing-masing textfield email dan pass
    TextEditingController _emailcontroller = TextEditingController();
    TextEditingController _passwordcontroller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),

      // Fitur Layout Column diset ke Portrait
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        // Children berikut digunakan untuk menata letak Text, TextField, dan Btn.
        children: [
          // Widget Text yang menampilkan dari nama aplikasi flutter
          const Text(
            "Ikhwan Login",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Widget Text yang menampilkan keterangan aplikasi flutter
          const Text(
            "Login using Firebase Flutter",
            style: TextStyle(
                color: Colors.black,
                fontSize: 44.0,
                fontWeight: FontWeight.bold),
          ),
          // Widget SizedBox yang digunakan untuk memberi jarak antara Text dan TextField
          const SizedBox(
            height: 44.0,
          ),
          // Widget TextField yang digunakan untuk input email dan berisi dekorasi TextField email
          TextField(
            controller: _emailcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "User Email",
              prefixIcon: Icon(Icons.mail, color: Colors.black),
            ),
          ),
          // Widget SizedBox yang digunakan untuk memberi jarak antara TextField email dan TextField password
          const SizedBox(
            height: 26.0,
          ),
          // Widget TextField yang digunakan untuk input email dan berisi dekorasi TextField password
          TextField(
            controller: _passwordcontroller,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "User Password",
              prefixIcon: Icon(Icons.lock, color: Colors.black),
            ),
          ),
          // Widget SizedBox yang digunakan untuk memberi jarak antara Textfield Password dan Text
          const SizedBox(
            height: 12.0,
          ),
          // Widget Text berikut merupakan dekorasi saja
          const Text(
            "Forget Password?",
            style: TextStyle(color: Colors.blue),
          ),
          // Widget SizedBox yang digunakan untuk memberi jarak antara Text dam Button Login
          const SizedBox(
            height: 88.0,
          ),
          // Widget Containter yang berfungsi sebagai Button login dan berisi dekorasi dan juga function login atau autentikasi
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Color(0xFF0069FE),
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              // Funtion async yang menunggu input email dan password, yang kemudian jika berhasil mengautentikasi ke firebase
              // maka akan meneruskannya ke halaman ProfileScreen
              onPressed: () async {
                User? user = await loginUsingEmailPassword(
                    email: _emailcontroller.text,
                    password: _passwordcontroller.text,
                    context: context);
                print(user);
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                }
              },
              // Text dari Button Login dan dekorasinya
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
