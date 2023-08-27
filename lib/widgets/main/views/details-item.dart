import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pedidos/widgets/main/customs/animated_button.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  DetailsScreen({required this.item});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late List<int> cantCremas;
  late List<List<int>> cantAddons = [];
  List<dynamic> addons = [];
  List<dynamic> addonsItems = [];
  List<dynamic> dataAddons = [];
  List<dynamic> subDataAddons = [];

  Future<void> getAddons() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://622f-38-250-132-102.ngrok-free.app/api/pedidos/get-addons'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': 'asd',
          'body': 'asd',
        }),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> newData =
            jsonResponse['data']; // Almacena los items en la lista "data"

        setState(() {
          dataAddons =
              newData; // Actualiza la lista "data" con los nuevos datos
          addonsItems = List<List<dynamic>>.generate(
            dataAddons.length,
            (index) => dataAddons[index]['items'],
          );

          cantAddons = List.generate(dataAddons.length, (i) {
            return List<int>.generate(addonsItems[i].length, (j) => 0);
          });
        });
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print(e);
    }
    addons = dataAddons;
  }

  @override
  void initState() {
    getAddons();
    // List<String> cremas = widget.item['cremas'].cast<String>();
    // cantCremas = List<int>.generate(cremas.length, (index) => 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // plato
    String title = widget.item['title'];
    String body = widget.item['body'];

    // // details
    String image = widget.item['image'];
    int price = widget.item['price'];
    // cremas
    List<String> addonsList = addons.cast<String>();
    return FractionallySizedBox(
      heightFactor: 0.50,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SanFranciscoBold'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1, bottom: 10),
                  child: Text(
                    'S/${price}',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontFamily: 'SanFrancisco',
                        fontSize: 20),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10.0), // Define el radio de las esquinas redondeadas
                  child: Image(
                    image: NetworkImage(image),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Descripcion',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(body),
// ADICIONALES SECTION
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: addons.length,
                  itemBuilder: (context, i) {
                    if (addons.isNotEmpty) {
                      return Container(
                        child: Column(
                          // padding: EdgeInsets.only(top: 20, bottom: 15),
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 15),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  addons[i]['viewText'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: addonsItems[i].length,
                                    itemBuilder: (context, j) {
                                      if (addonsItems.isNotEmpty) {
                                        return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Row(children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      // addonsItems[j]['title'],
                                                      addonsItems[i][j]
                                                          ['title'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      "c/u: ${addonsItems[i][j]['price']}",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[700]),
                                                    ),
                                                    Text(
                                                      "Total: ${(double.parse(addonsItems[i][j]['price']) * cantAddons[i][j]).toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[700]),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          OutlinedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                cantAddons[i]
                                                                    [j]++;
                                                              });
                                                            },
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  CircleBorder(),
                                                              side: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                            child: Icon(
                                                                Icons.add,
                                                                size: 15,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                          Text(cantAddons[i][j]
                                                              .toString()),
                                                          OutlinedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                if (cantAddons[
                                                                        i][j] >
                                                                    0) {
                                                                  cantAddons[i]
                                                                      [j]--;
                                                                }
                                                              });
                                                            },
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  CircleBorder(),
                                                              side: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                            child: Icon(
                                                                Icons.remove,
                                                                size: 15,
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            ]));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        AnimatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => CameraScreen(cameras)),
                            // );
                          },
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
