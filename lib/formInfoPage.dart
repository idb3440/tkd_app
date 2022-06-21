// ignore_for_file: file_names

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tkd_app/model/form.dart';
import 'package:url_launcher/url_launcher.dart';

class FormInfoPage extends StatefulWidget {
  final Forma forma;
  FormInfoPage(Forma this.forma, {Key? key}) : super(key: key);

  @override
  State<FormInfoPage> createState() => _FormInfoPageState();
}

class _FormInfoPageState extends State<FormInfoPage> {
  String img = "assets/default.png";
  
  late String namePoomsae = widget.forma.namePoomsae.replaceAll(" ", "");
  late String urlImagen = "assets/$namePoomsae.jpg";
  
  late String urlVideo = widget.forma.urlVideo;

  @override
  void initState() {
    super.initState();
    
    ByteData bytes;
    Future.delayed(Duration.zero, () async {
      try {
        bytes = await rootBundle.load(urlImagen);
        setState(() {
          img = urlImagen;
        });
      } catch (e) {
        print("NO EXISTE IMAGEN DE ESA FORMA");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(228,219,217,1),
        resizeToAvoidBottomInset: false, // set it to false
        appBar: AppBar(
          centerTitle: true,
          title:  Text(
            'Poomsae - ${widget.forma.namePoomsae}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(30, 84, 118, 1) ,
          actions: [
            Container(
              padding: const EdgeInsets.all(17.0),
              child: const Image(image: AssetImage("assets/two.png")),
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(15, 42, 59, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                              color: Color.fromRGBO(15, 42, 59, 1)))),
                  onPressed: () {
                    launchUrl(Uri.parse(urlVideo));
                  },
                  child: const Text('Ver video',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * (.75),
                  child: Image.asset(img),
                ),
                
              ]),
        ));
  }
}
