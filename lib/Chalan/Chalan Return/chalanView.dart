import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/Model/chalanReturnModel.dart';

import 'Model/chalanReturnView.dart';
import 'Services/chalanReturnAPI.dart';

class ViewDetails extends StatefulWidget {
  final String id;
  final String chalanNo;

  const ViewDetails({Key? key, required this.id,required this.chalanNo})
      : super(key: key);

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  ChalanServices chalanServices=ChalanServices();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeff3ff),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.0, -0.94),
                    end: Alignment(0.968, 1.0),
                    colors: [Color(0xff2c51a4), Color(0xff6b88e8)],
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                  //   color: Color(0xff2557D2)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      widget.chalanNo,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: chalanServices
                    .fetchChalanReturnView(widget.id.toString()),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    try {
                      final snapshotData = json.decode(snapshot.data);

                      ChalanReturnView chalanReturnView =
                      ChalanReturnView.fromJson(snapshotData);

                      return DataTable(
                        columnSpacing: 10,
                        horizontalMargin: 0,
                        // columnSpacing: 10,
                        columns: const [
                          DataColumn(
                            label: SizedBox(
                              width: 70,
                              child: Text('Item Name'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 80,
                              child: Text('Quantity'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 80,
                              child: Center(child: Text('Gross')),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 60,
                              child: Text('Net'),
                            ),
                          ),
                        ],
                        rows: List.generate(
                          chalanReturnView.results!.length,
                              (index) => DataRow(
                            // selected: true,
                            cells: [
                              DataCell(
                                Text(chalanReturnView
                                    .results![index].itemName
                                    .toString()),
                              ),
                              DataCell(
                                Text(chalanReturnView
                                    .results![index].qty
                                    .toString()),
                              ),
                              DataCell(
                                Text(chalanReturnView
                                    .results![index].grossAmount
                                    .toString()),
                              ),
                              DataCell(
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:Text(chalanReturnView
                                      .results![index].netAmount
                                      .toString()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } catch (e) {
                      throw Exception(e);
                    }
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
