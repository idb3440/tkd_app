// ignore_for_file: file_names, empty_catches
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/model/student.dart';

import 'package:tkd_app/studentsPage.dart';

class StudentsEditPage extends StatefulWidget {
  final Student currentStudent;
  StudentsEditPage(Student this.currentStudent, {Key? key}) : super(key: key);

  @override
  State<StudentsEditPage> createState() => _StudentsEditPageState();
}

class _StudentsEditPageState extends State<StudentsEditPage> {
  final fullNameController = TextEditingController();
  final gradeController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final dateBirthController = TextEditingController();
  final dateEnrolmentController = TextEditingController();

  //Editar STUDENT - PUT
  Future<http.Response> editStudent() async {
    var url =
        "https://frlvw4s5bh.execute-api.us-east-1.amazonaws.com/studentFase/student";

    var response = await http.put(Uri.parse(url),
        body: jsonEncode({
          "id": widget.currentStudent.id,
          "fullName": fullNameController.text.toString(),
          "grade": gradeController.text.toString(),
          "emergencyPhone": emergencyPhoneController.text.toString(),
          "dateBirth": dateBirthController.text.toString()
        }));

    return response;
  }

  editInfoStudent() async {
    final response = await editStudent();

    if (response.statusCode == 200) {
      setState(() {
        const snackBar = SnackBar(
          content: Text("Cambio realizado satisfactoriamente"),
          duration: Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    StudentsPage(int.parse(widget.currentStudent.idUser))));
      });
    } else {
      throw Exception("Falló la conexion");
    }
  }

  bool verificador() {
    bool flag = false;

    if (fullNameController.text.isNotEmpty &&
        gradeController.text.isNotEmpty &&
        dateBirthController.text.isNotEmpty &&
        emergencyPhoneController.text.isNotEmpty) {
      flag = true;
    }

    return flag;
  }

  bool readOnlyFlag = true;
  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.currentStudent.fullName;
    gradeController.text = widget.currentStudent.grade;
    dateBirthController.text = widget.currentStudent.dateBirth;
    emergencyPhoneController.text = widget.currentStudent.emergencyPhone;
    dateEnrolmentController.text = widget.currentStudent.dateEnrolment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(228, 219, 217, 1),
        resizeToAvoidBottomInset: false, // set it to false
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            readOnlyFlag ? 'Información personal' : 'Cambiar Información',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(15, 42, 59, 1),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    readOnlyFlag = !readOnlyFlag;
                  });
                },
                icon: const Icon(Icons.edit),
                alignment: Alignment.centerRight),
          ],
        ),
        body: SingleChildScrollView(child: formulario()));
  }

  Widget formulario() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              TextFormField(
                readOnly: readOnlyFlag,
                controller: fullNameController,
                keyboardType: TextInputType.name,
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color.fromRGBO(6, 70, 98, 1),
                  ),
                  labelText: 'Nombre:',
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(6, 70, 98, 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: readOnlyFlag,
                controller: gradeController,
                keyboardType: TextInputType.name,
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.account_tree,
                    color: Color.fromRGBO(6, 70, 98, 1),
                  ),
                  labelText: 'Grado:',
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(6, 70, 98, 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                  readOnly: readOnlyFlag,
                  controller: dateBirthController,
                  keyboardType: TextInputType.datetime,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.cake_rounded,
                      color: Color.fromRGBO(6, 70, 98, 1),
                    ),
                    labelText: 'Fecha de nacimiento:',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(6, 70, 98, 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  )),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: readOnlyFlag,
                controller: emergencyPhoneController,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Color.fromRGBO(6, 70, 98, 1),
                  ),
                  labelText: 'Contacto de emergencia:',
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(6, 70, 98, 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                controller: dateEnrolmentController,
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Color.fromRGBO(6, 70, 98, 1),
                  ),
                  labelText: 'Fecha de inscripción:',
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(6, 70, 98, 1),
                  ),
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
                    if (readOnlyFlag) {
                      Navigator.pop(context);
                    } else {
                      if (verificador()) {
                        editInfoStudent();
                      } else {
                        setState(() {
                          const snackBar = SnackBar(
                            content: Text("Datos incompletos"),
                            duration: Duration(seconds: 3),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      }
                    }
                  },
                  child: Text(readOnlyFlag ? 'Regresar' : 'Guardar cambios',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20))),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
