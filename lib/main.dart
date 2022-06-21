import 'package:flutter/material.dart';

import 'package:tkd_app/menuPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tkd_app/model/user.dart';
import 'package:tkd_app/userAdd.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TKD - APP',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //GET user
  Future<http.Response> getUsers() async {
    var url =
        "https://frlvw4s5bh.execute-api.us-east-1.amazonaws.com/studentFase/users";

    var response = await http.get(Uri.parse(url));

    return response;
  }

  late bool flagCorrect;
  late int idUser;

  _verifyUser1() async {
    final response = await getUsers();

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      for (var item in jsonDecode(body)) {
        User element = User(
            item["id"], item["userName"], item["password"], item["fullName"]);

        setState(() {
          idUser = int.parse(element.id);
          flagCorrect = verifyUser2(element);
        });

        if (flagCorrect) {
          break;
        }
      }

      if (flagCorrect) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MenuPage(idUser)));
      } else {
        setState(() {
          const snackBar = SnackBar(
            content: Text("Usuario o Contraseña Incorrectos"),
            duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    } else {
      throw Exception("Falló la conexion");
    }
  }

  bool verifyUser2(User element) {
    bool flag = false;

    if (element.userName == userNameController.text.toString() &&
        element.password == passwordController.text.toString()) {
      flag = true;
    }

    return flag;
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  bool seePassword = true;
  Icon keyOn = Icon(Icons.lock_outline);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(228, 219, 217, 1),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    child: Image.asset('assets/splash.png'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 50),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    child: TextFormField(
                      
                      controller: userNameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: Color.fromRGBO(6, 70, 98, 1),
                        ),
                        hintText: "Usuario",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    child: TextFormField(
                      
                      obscureText: seePassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Color.fromRGBO(6, 70, 98, 1),
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                seePassword = !seePassword;
                                if (seePassword) {
                                  keyOn = Icon(Icons.lock_outlined);
                                } else {
                                  keyOn = Icon(Icons.lock_open_outlined);
                                }
                              });
                            },
                            icon: keyOn,
                            alignment: Alignment.centerRight),
                        hintText: "Contraseña",
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(30, 40),
                          primary: const Color.fromRGBO(6, 70, 98, 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: const BorderSide(
                                  color: Color.fromRGBO(6, 70, 98, 1)))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _verifyUser1();
                        } else {
                          setState(() {
                            const snackBar = SnackBar(
                              content: Text("Datos incompletos"),
                              duration: Duration(seconds: 3),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      },
                      child: const Text('Continuar',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20))),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserAddPage()));
                    },
                    child: const Text(
                      '¡Registrate aquí!',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
