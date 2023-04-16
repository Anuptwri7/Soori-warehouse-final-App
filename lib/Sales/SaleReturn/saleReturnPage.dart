import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/Model/chalanReturnModel.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/chalanView.dart';
import 'package:soori_warehouse/Sales/SaleReturn/saleReturnViewPage.dart';
import 'package:soori_warehouse/Sales/model/saleReturn.dart';
import 'package:soori_warehouse/Sales/services/saleReturnService.dart';


class SaleReturnPage extends StatefulWidget {
  const SaleReturnPage({Key? key}) : super(key: key);

  @override
  State<SaleReturnPage> createState() =>
      _SaleReturnPageState();
}

class _SaleReturnPageState extends State<SaleReturnPage> {
  // String get $i => null;

  final TextEditingController _searchController = TextEditingController();
  static String _searchItem = '';
  SaleServices saleServices=SaleServices();
  Future searchHandling() async {
    // await Future.delayed(const Duration(seconds: 3));
    log(" SEARCH ${_searchController.text}");
    if (_searchItem == "") {
      return await saleServices.fetchSaleReturn('');
    } else {
      return await saleServices.fetchSaleReturn(_searchItem);
    }
  }

  @override
  void initState() {

    // searchHandling();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: const Color(0xffeff3ff),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.0, -0.94),
                    end: Alignment(0.968, 1.0),
                    colors: [Color(0xff2557D2), Color(0xff6b88e8)],
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
                child: const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Sale Return',
                      style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffeff3ff),
                        offset: Offset(5, 8),
                        spreadRadius: 5,
                        blurRadius: 12,
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, right: 5, left: 5, bottom: 50),
                    child: Column(
                      children: [
                        // TextFormField(
                        //   controller: _searchController,
                        //   keyboardType: TextInputType.text,
                        //   decoration: InputDecoration(
                        //     hintText: "Search",
                        //     hintStyle:
                        //     Theme.of(context).textTheme.subtitle1!.copyWith(
                        //       fontSize: 18,
                        //       color: Colors.grey,
                        //     ),
                        //     // filled: true,
                        //     // fillColor: Theme.of(context).backgroundColor,
                        //     prefixIcon: const Icon(Icons.search),
                        //     border: InputBorder.none,
                        //     errorBorder: InputBorder.none,
                        //     errorMaxLines: 4,
                        //   ),
                        //   // validator: validator,
                        //   autovalidateMode: AutovalidateMode.onUserInteraction,
                        //   onChanged: (query) {
                        //     setState(() {
                        //       _searchItem = query;
                        //     });
                        //   },
                        //   textCapitalization: TextCapitalization.sentences,
                        // ),
                        FutureBuilder(

                          // future: customerServices
                          //     .fetchOrderListFromUrl(_searchItem),
                          future: searchHandling(),

                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              try {
                                final snapshotData = json.decode(snapshot.data);
                                SaleReturn saleReturn =
                                SaleReturn .fromJson(snapshotData);

                                // log(customerOrderList.count.toString());

                                return DataTable(
                                    sortColumnIndex: 0,
                                    sortAscending: true,
                                    columnSpacing: 0,
                                    horizontalMargin: 0,

                                    // columnSpacing: 10,

                                    columns: [
                                      DataColumn(
                                        label: SizedBox(
                                          width: width * .175,
                                          child: const Text(
                                            'Sale No.',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: width * .15,
                                          child: const Text(
                                            'Type',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: width * .2,
                                          child: const Text(
                                            'Customer',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: width * .25,
                                          child: const Center(
                                              child: Text(
                                                'Grand',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(
                                        saleReturn.results!.length,
                                            (index) => DataRow(
                                          // selected: true,
                                          cells: [
                                            DataCell(
                                              Container(


                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Text(
                                                    saleReturn
                                                        .results![index].saleNo
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                                Container(

                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top:8.0),
                                                    child: Text(
                                                      saleReturn
                                                          .results![index]
                                                          .payTypeDisplay
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                )),
                                            DataCell(
                                                Container(

                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top:8.0),
                                                    child: Text(
                                                      saleReturn
                                                          .results![index]
                                                          .customerFirstName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                )),

                                            DataCell(
                                              GestureDetector(
                                                onTap: (){
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewDetails(
                                                  //     id:chalanReturn.results![index].id.toString(),
                                                  //     chalanNo: chalanReturn.results![index].chalanNo.toString())));
                                                },
                                                child: Row(
                                                  children: [

                                                    Container(

                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top:8.0),
                                                        child: Text(
                                                          saleReturn
                                                              .results![index]
                                                              .grandTotal
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SaleViewDetails(id: saleReturn.results![index].id.toString(),)));

                                },
                                                      child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .indigo[900],
                                                            borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5))),
                                                        child: const Center(
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .eye,
                                                            size: 15,
                                                            color:
                                                            Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ),
                                            )
                                          ],
                                        )));
                              } catch (e) {
                                throw Exception(e);
                              }
                            } else {
                              return Container(
                                child: Text("Loading......."),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
