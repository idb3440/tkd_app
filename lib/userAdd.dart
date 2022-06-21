// ignore_for_file: file_names, empty_catches
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/main.dart';
import 'package:tkd_app/menuPage.dart';
import 'package:tkd_app/model/user.dart';

class UserAddPage extends StatefulWidget {
  UserAddPage({Key? key}) : super(key: key);

  @override
  State<UserAddPage> createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  final fullNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();

  int idUser = 0;

  //GET user
  Future<http.Response> getUsers() async {
    var url =
        "https://frlvw4s5bh.execute-api.us-east-1.amazonaws.com/studentFase/users";

    var response = await http.get(Uri.parse(url));

    return response;
  }

  late List<String> listUserName = [];

  _verifyUser() async {
    final response = await getUsers();

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      for (var item in jsonDecode(body)) {
        User element = User(
            item["id"], item["userName"], item["password"], item["fullName"]);

        setState(() {
          if (int.parse(element.id) > idUser) {
            idUser = int.parse(element.id);
          }
          listUserName.add(element.userName);
        });
      }
    } else {
      throw Exception("Falló la conexion");
    }
  }

  //AÑADIR USER
  Future<http.Response> registerUser() async {
    var url =
        "https://frlvw4s5bh.execute-api.us-east-1.amazonaws.com/studentFase/users";

    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "id": (idUser + 1).toString(),
          "fullName": fullNameController.text.toString(),
          "userName": userNameController.text.toString(),
          "password": passwordController.text.toString(),
        }));

    return response;
  }

  addUser() async {
    if (!listUserName.contains(userNameController.text.toString())) {
      if (password2Controller.text.toString() ==
          passwordController.text.toString()) {
        final response = await registerUser();
        if (response.statusCode == 200) {
          setState(() {
            const snackBar = SnackBar(
              content: Text("Registrado exitosamente"),
              duration: Duration(seconds: 5),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuPage((idUser + 1))));
          });
        } else {
          setState(() {
            const snackBar = SnackBar(
              content: Text("Lo sentimos! Hubo un error al registrarse"),
              duration: Duration(seconds: 5),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          });
          throw Exception("Falló la conexion");
        }
      } else {
        setState(() {
          const snackBar = SnackBar(
            content: Text("La contraseña no coincide"),
            duration: Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    } else {
      setState(() {
        const snackBar = SnackBar(
          content: Text("Por favor, elija otro nombre de usuario"),
          duration: Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  verificarCamposCompletos() {
    if (fullNameController.text.isNotEmpty &&
        userNameController.text.isNotEmpty &&
        password2Controller.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      addUser();
    } else {
      setState(() {
        const snackBar = SnackBar(
          content: Text("Por favor, completa los campos"),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _verifyUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(228, 219, 217, 1),
        resizeToAvoidBottomInset: false, // set it to false
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Registro',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(15, 42, 59, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyApp()));
            },
          ),
          actions: [
            Container(
              padding: const EdgeInsets.all(17.0),
              child: const Image(image: AssetImage("assets/two.png")),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            formulario(),
          ],
        ))));
  }

  Widget formulario() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Nombre:',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16.0),
            ),
            TextFormField(
              controller: fullNameController,
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.account_box_sharp,
                  color: Color.fromRGBO(6, 70, 98, 1),
                ),
                hintText: 'Nombre(s) y apellido(s)',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nombre de Usuario:',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16.0),
            ),
            TextFormField(
              controller: userNameController,
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: Color.fromRGBO(6, 70, 98, 1),
                ),
                hintText: 'Usuario',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Contraseña:',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16.0),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.password,
                  color: Color.fromRGBO(6, 70, 98, 1),
                ),
                hintText: 'Contraseña',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Confirmar contraseña:',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16.0),
            ),
            TextFormField(
              controller: password2Controller,
              keyboardType: TextInputType.name,
              obscureText: true,
              maxLines: 1,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.password,
                  color: Color.fromRGBO(6, 70, 98, 1),
                ),
                hintText: 'Contraseña',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            const SizedBox(height: 50),
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
                  verificarCamposCompletos();
                },
                child: const Text('Registrarse',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20))),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
