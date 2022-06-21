// ignore_for_file: file_names, empty_catches
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tkd_app/studentsPage.dart';

class StudentsAddPage extends StatefulWidget {
  final int currentId;
  final int idUser;
  StudentsAddPage(int this.currentId, int this.idUser, {Key? key})
      : super(key: key);

  @override
  State<StudentsAddPage> createState() => _StudentsAddPageState();
}

class _StudentsAddPageState extends State<StudentsAddPage> {
  final fullNameController = TextEditingController();
  final gradeController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final dateBirthController = TextEditingController();
  final ValueNotifier<DateTime?> dateSub = ValueNotifier(null);
  
  //AÑADIR STUDENT - POST
  Future<http.Response> registerStudent() async {
    String id = (widget.currentId + 1).toString();

    String dateToday =
        DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
  
    var url =
        "https://frlvw4s5bh.execute-api.us-east-1.amazonaws.com/studentFase/student";

    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "id": id,
          "fullName": fullNameController.text.toString(),
          "grade": gradeController.text.toString(),
          "emergencyPhone": emergencyPhoneController.text.toString(),
          "dateBirth": dateBirthController.text.toString(),
          "dateEnrolment": dateToday,
          "isActive": true,
          "idUser": widget.idUser.toString()
        }));

    return response;
  }

  addStudent() async {
    final response = await registerStudent();

    if (response.statusCode == 200) {
      setState(() {
        const snackBar = SnackBar(
          content: Text("Alumno Registrado exitosamente"),
          duration: Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StudentsPage(widget.idUser)));
      });
    } else {
      throw Exception("Falló la conexion");
    }
  }

  verificarCamposCompletos() {
    if (fullNameController.text.isNotEmpty &&
        gradeController.text.isNotEmpty &&
        emergencyPhoneController.text.isNotEmpty &&
        dateBirthController.text.isNotEmpty) {
          addStudent();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(228, 219, 217, 1),
        resizeToAvoidBottomInset: false, // set it to false
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Nuevo Estudiante',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(15, 42, 59, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentsPage(widget.idUser)));
            },
          ),
          actions: [
            Container(
              padding: const EdgeInsets.all(17.0),
              child: const Image(image: AssetImage("assets/two.png")),
            )
          ],
        ),
        body: SingleChildScrollView(child: formulario()));
  }

  Widget formulario() {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          autovalidateMode: AutovalidateMode.disabled,
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
                    Icons.person,
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
                'Grado:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16.0),
              ),
              TextFormField(
                controller: gradeController,
                keyboardType: TextInputType.name,
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.account_tree,
                    color: Color.fromRGBO(6, 70, 98, 1),
                  ),
                  hintText: 'Color de cinta',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contacto de emergencia:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16.0),
              ),
              TextFormField(
                controller: emergencyPhoneController,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Color.fromRGBO(6, 70, 98, 1),
                  ),
                  hintText: 'Número telefónico',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              const Text(
                'Fecha de nacimiento:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16.0),
              ),
              ValueListenableBuilder<DateTime?>(
                  valueListenable: dateSub,
                  builder: (context, dateVal, child) {
                    int limitYear =
                        int.parse(DateTime.now().year.toString()) - 6;
                    return InkWell(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime(limitYear),
                              firstDate: DateTime(1975),
                              lastDate: DateTime(limitYear),
                              currentDate: DateTime(limitYear),
                              initialEntryMode: DatePickerEntryMode.calendar,
                              initialDatePickerMode: DatePickerMode.day,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                          primary:
                                              Color.fromRGBO(6, 70, 98, .75),
                                          onSurface:
                                              Color.fromRGBO(6, 70, 98, 1))),
                                  child: child!,
                                );
                              });
                          dateSub.value = date;
                        },
                        child: buildDateTimePicker(
                            dateVal != null ? convertDate(dateVal) : ''));
                  }),
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
                  child: const Text('Guardar',
                      style: TextStyle(
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

  String convertDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  Widget buildDateTimePicker(String data) {
    dateBirthController.text = data;
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Color.fromRGBO(6, 70, 98, 1)),
      ),
      title: Text(data),
      leading: const Icon(
        Icons.calendar_today,
        color: Color.fromRGBO(6, 70, 98, 1),
      ),
    );
  }
}
