// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tkd_app/menuPage.dart';
import 'package:tkd_app/model/student.dart';
import 'package:tkd_app/studentsAdd.dart';
import 'package:tkd_app/studentsEdit.dart';
import 'package:http/http.dart' as http;

class StudentsPage extends StatefulWidget {
  final int idUser;
  StudentsPage(int this.idUser, {Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
//idbigger
  int idBig = 0;

//GET Students
  Future<http.Response> getStudents() async {
    var url =
        "https://frlvw4s5bh.execute-api.us-east-1.amazonaws.com/studentFase/student";

    var response = await http.get(Uri.parse(url));

    return response;
  }

  late List<Student> listStudents = [];
  late Student element;

  _listaStudents() async {
    final response = await getStudents();

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      for (var item in jsonDecode(body)) {
        element = Student(
            item["id"],
            item["fullName"],
            item["grade"],
            item["emergencyPhone"],
            item["dateBirth"],
            item["dateEnrolment"],
            item["isActive"],
            item["idUser"]);

        setState(() {
          if (int.parse(element.id) > idBig) {
            idBig = int.parse(element.id);
          }
          if (widget.idUser.toString() == element.idUser) {
            listStudents.add(element);
          }
        });
      }
    } else {
      throw Exception(
          "Falló la conexion - Error al listar/consultar bdStudents");
    }
  }

  @override
  void initState() {
    super.initState();
    _listaStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(228, 219, 217, 1),
        resizeToAvoidBottomInset: false, // set it to false
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Estudiantes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(15, 42, 59, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MenuPage(widget.idUser)));
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StudentsAddPage(idBig, widget.idUser)));
                },
                icon: const Icon(Icons.person_add),
                alignment: Alignment.centerRight),
            Container(
              padding: const EdgeInsets.all(17.0),
              child: const Image(image: AssetImage("assets/two.png")),
            )
          ],
        ),
        body: card());
  }

  Widget card() {
    if (listStudents.isEmpty) {
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/empty.png',
          height: MediaQuery.of(context).size.height * (.25),
          width: MediaQuery.of(context).size.width * (.50),),
          const Text(
            "NO CUENTA CON ALUMNOS REGISTRADOS",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ));
    } else {
      return ListView.builder(
        // Deja que ListView sepa cuántos elementos necesita para construir
        itemCount: listStudents.length,
        // Proporciona una función de constructor. ¡Aquí es donde sucede la magia! Vamos a
        // convertir cada elemento en un Widget basado en el tipo de elemento que es.
        itemBuilder: (context, index) {
          final _student = listStudents[index];

          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentsEditPage(_student)));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * (.13),
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Row(
                  children: [
                    Container(
                      color: Colors.amber,
                      width: 18,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                  text: 'Nombre: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              TextSpan(
                                  text: '${_student.fullName}  \n ',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18)),
                              const TextSpan(
                                  text: 'Grado/Cinta: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              TextSpan(
                                  text: '${_student.grade}  \n ',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18)),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        },
      );
    }
  }
}
