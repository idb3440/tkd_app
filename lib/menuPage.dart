// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tkd_app/gradePage.dart';
import 'package:tkd_app/main.dart';
import 'package:tkd_app/studentsPage.dart';

class MenuPage extends StatefulWidget {
  final int idUser;
  MenuPage(int this.idUser, {Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
        automaticallyImplyLeading: false, //quita el backbutton
        centerTitle: true,
        title: const Text(
          'Menú',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(15, 42, 59, 1),
        actions: [
          Container(
            padding: const EdgeInsets.all(17.0),
            child: const Image(image: AssetImage("assets/two.png")),
          )
        ],
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Container(
                alignment: Alignment.center,
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * (.25),
                        width: MediaQuery.of(context).size.width * (.50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(6, 70, 98, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: const BorderSide(
                                    color: Color.fromRGBO(30, 84, 118, 1),
                                  ))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GradosPage()));
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        (.17),
                                    width: MediaQuery.of(context).size.width *
                                        (.40),
                                    child:
                                        Image.asset('assets/grados.png'),
                                  ),
                                  const Text('Grados',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              )),
                        ),
                      )),
                )),
            Container(
                alignment: Alignment.center,
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * (.25),
                        width: MediaQuery.of(context).size.width * (.50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(6, 70, 98, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: const BorderSide(
                                    color: Color.fromRGBO(30, 84, 118, 1),
                                  ))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StudentsPage(widget.idUser)));
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        (.17),
                                    width: MediaQuery.of(context).size.width *
                                        (.40),
                                    child:
                                        Image.asset('assets/estudiantes.png'),
                                  ),
                                  const Text('Estudiantes',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              )),
                        ),
                      )),
                )),
          ])),
      bottomNavigationBar: exitButton(),
    );
  }

  Widget exitButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * (.11),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(20, 30),
                primary: const Color.fromRGBO(15, 42, 59, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: const BorderSide(
                        color: Color.fromRGBO(30, 84, 118, 1)))),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
            child: const Text('Salir',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20))),
      ),
    );
  }
}
