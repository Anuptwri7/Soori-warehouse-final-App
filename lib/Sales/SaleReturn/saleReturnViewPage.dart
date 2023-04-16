import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/Model/chalanReturnModel.dart';
import 'package:soori_warehouse/Sales/model/saleReturnViewModel.dart';
import 'package:soori_warehouse/Sales/services/saleReturnService.dart';

class SaleViewDetails extends StatefulWidget {
  final String id;


  const SaleViewDetails({Key? key, required this.id})
      : super(key: key);

  @override
  _SaleViewDetailsState createState() => _SaleViewDetailsState();
}

class _SaleViewDetailsState extends State<SaleViewDetails> {

  SaleServices saleServices = SaleServices();



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
                      "Sales Return Detials",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: saleServices
                    .fetchSaleReturnView(widget.id.toString()),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    try {
                      final snapshotData = json.decode(snapshot.data);

                      SaleReturnView saleReturnView =
                      SaleReturnView.fromJson(snapshotData);

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
                          saleReturnView.results!.length,
                              (index) => DataRow(
                            // selected: true,
                            cells: [
                              DataCell(
                                Text(saleReturnView.results![index].itemName
                                    .toString()),
                              ),
                              DataCell(
                                Text(saleReturnView.results![index].itemCategoryName
                                    .toString()),
                              ),
                              DataCell(
                                Text(saleReturnView.results![index].cost
                                    .toString()),
                              ),
                              DataCell(
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:Text(saleReturnView.results![index].grossAmount
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
