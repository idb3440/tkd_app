// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tkd_app/formInfoPage.dart';
import 'package:tkd_app/model/form.dart';
import 'package:http/http.dart' as http;

class GradosPage extends StatefulWidget {
  GradosPage({Key? key}) : super(key: key);

  @override
  State<GradosPage> createState() => _GradosPageState();
}

class _GradosPageState extends State<GradosPage> {
  List<String> listGrades = [
    "Blanca",
    "BlancaAvanzada",
    "Amarilla",
    "AmarillaAvanzada",
    "Verde",
    "VerdeAvanzada",
    "Azul",
    "AzulAvanzada",
    "Roja",
    "Negra",
  ];

//GET Forma
  Future<http.Response> getForms() async {
    var url =
        "https://frlvw4s5bh.execute-api.us-east-1.amazonaws.com/studentFase/forms";

    var response = await http.get(Uri.parse(url));

    return response;
  }

  late List<Forma> listFormas = [];
  late Forma element;

  _listForms() async {
    final response = await getForms();

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      for (var item in jsonDecode(body)) {
        element = Forma(item["id"], item["grade"], item["type"],
            item["namePoomsae"], item["urlVideo"]);

        setState(() {
          listFormas.add(element);
        });
      }
    } else {
      throw Exception(
          "Falló la conexion - Error al listar/consultar bdStudents");
    }
  }

  late List<Forma> _listToEachButton = [];
  Future<void> formsToEachButton(BuildContext context, String grade) async {
    _listToEachButton = [];

    for (var forma in listFormas) {
      String gradeThis = forma.grade;
      gradeThis = gradeThis.replaceAll(" ", "");

      if (gradeThis == grade) {
        _listToEachButton.add(forma);
      }
    }
    _bottomSheet(context, grade);
  }

  _bottomSheet(BuildContext context, String grade) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(30, 84, 118, 1),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              grade,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                  Container(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 270.0,
                            minHeight: 100.0,
                          ),
                          child: ListView.builder(
                            controller: ScrollController(),
                            shrinkWrap: true,
                            itemCount: _listToEachButton.length,
                            itemBuilder: (context, int index) {
                              Forma _form = _listToEachButton[index];
                              return ListTile(
                                title: Text(_form.namePoomsae),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FormInfoPage(_form)));
                                },
                              );
                            },
                          )))
                ],
              ))
            ],
          );
        });
  }

//BARRA BÚSCADORA
  final TextEditingController _controllerTextSearch = TextEditingController();
  late bool _isSearching;
  bool _isVisible = false;
  List searchResult = [];

  _GradosPageState() {
    _controllerTextSearch.addListener(() {
      if (_controllerTextSearch.text.isEmpty) {
        setState(() {
          _isSearching = false;
        });
      } else {
        setState(() {
          _isSearching = true;
        });
      }
    });
  }

  showSearchy() {
    setState(() {
      _isVisible = !_isVisible;
      searchResult.clear();
      _controllerTextSearch.clear();
    });
  }

  void searchOperation(String searchText) {
    searchResult.clear();

    if (_isSearching) {
      for (int i = 0; i < _listToSearchBar.length; i++) {
        Forma data = _listToSearchBar[i];

        if (searchText == "") {
          break;
        } else if (data.namePoomsae.toLowerCase().contains(searchText.toLowerCase())) {
          searchResult.add(data);
        }
      }
    }
  }

  //Listado para el buscador
  late List<Forma> _listToSearchBar = [];
  Future<void> servicesToSearchBar() async {
    var response = await getForms();

    _listToSearchBar = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      for (var item in jsonDecode(body)) {
        element = Forma(item["id"], item["grade"], item["type"],
            item["namePoomsae"], item["urlVideo"]);

        setState(() {
          _listToSearchBar.add(element);
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
    _listForms();
    _isSearching = false;
    servicesToSearchBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(228, 219, 217, 1),
        resizeToAvoidBottomInset: false, // set it to false
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Cintas - Grados',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(30, 84, 118, 1),
          actions: [
            IconButton(
                onPressed: () {
                  showSearchy();
                },
                icon: const Icon(Icons.search),
                alignment: Alignment.centerRight),
            Container(
              padding: const EdgeInsets.all(17.0),
              child: const Image(image: AssetImage("assets/two.png")),
            )
          ],
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _searchBar(),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2, children: [..._listButtons()]))
            ]));
  }

  Widget _searchBar() {
    return Container(
        child: Column(
      children: [
        Visibility(
            visible: _isVisible,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 1.0, left: 25.0, right: 25.0),
                  child: TextFormField(
                    controller: _controllerTextSearch,
                    onChanged: searchOperation,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Forma a Buscar...",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 1.0, left: 25.0, right: 25.0),
                  child: searchResult.isNotEmpty ||
                          _controllerTextSearch.text.isNotEmpty
                      ? ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 300.0,
                            minHeight: 100.0,
                          ),
                          child: ListView.builder(
                            controller: ScrollController(),
                            shrinkWrap: true,
                            itemCount: searchResult.length,
                            itemBuilder: (BuildContext context, int index) {
                              Forma _form = searchResult[index];
                              return ListTile(
                                title: Text(_form.namePoomsae.toString()),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FormInfoPage(_form)));
                                },
                              );
                            },
                          ))
                      : const Text(' '),
                )
              ],
            ))
      ],
    ));
  }

  List<Widget> _listButtons() {
    List<Widget> buttons = [];

    for (var index = 0; index < listGrades.length; index++) {
      buttons.add(Container(
          height: MediaQuery.of(context).size.height * (10),
          width: MediaQuery.of(context).size.width * (10),
          child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(15, 42, 59, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: const BorderSide(
                            color: Color.fromRGBO(6, 70, 98, 1)))),
                onPressed: () {
                  String grade = listGrades[index];
                  formsToEachButton(context, grade);
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5.0),
                    topLeft: Radius.circular(5.0),
                  ),
                  child: Image.asset(
                    "assets/${listGrades[index]}.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ))));
    }
    return buttons;
  }
}
