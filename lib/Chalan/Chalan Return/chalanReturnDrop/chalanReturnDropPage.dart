import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Model/chalanReturnDropModel.dart';
import 'Services/chalanReturnDropAPI.dart';
import 'chalanReturnDropScanPage.dart';


class ChalanReturnDropPage extends StatefulWidget {
  const ChalanReturnDropPage({Key? key}) : super(key: key);

  @override
  State<ChalanReturnDropPage> createState() =>
      _ChalanReturnDropPageState();
}

class _ChalanReturnDropPageState extends State<ChalanReturnDropPage> {
  // String get $i => null;

  final TextEditingController _searchController = TextEditingController();
  static String _searchItem = '';
  ChalanReturnDropServices chalanReturnDropServices=ChalanReturnDropServices();
  Future searchHandling() async {
    // await Future.delayed(const Duration(seconds: 3));
    log(" SEARCH ${_searchController.text}");
    if (_searchItem == "") {
      return await chalanReturnDropServices.fetchChalanReturnDrop('');
    } else {
      return await chalanReturnDropServices.fetchChalanReturnDrop(_searchItem);
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
                      'Chalan Return Drop',
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
                        TextFormField(
                          controller: _searchController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle:
                            Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            // filled: true,
                            // fillColor: Theme.of(context).backgroundColor,
                            prefixIcon: const Icon(Icons.search),
                            border: InputBorder.none,
                            errorBorder: InputBorder.none,
                            errorMaxLines: 4,
                          ),
                          // validator: validator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (query) {
                            setState(() {
                              _searchItem = query;
                            });
                          },
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        FutureBuilder(

                          // future: customerServices
                          //     .fetchOrderListFromUrl(_searchItem),
                          future: searchHandling(),

                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              try {
                                final snapshotData = json.decode(snapshot.data);
                                ChalanReturnDrop chalanReturndrop =
                                ChalanReturnDrop.fromJson(snapshotData);

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
                                          width: width * .3,
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
                                          width: width * .15,
                                          child: const Text(
                                            'Grand',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: width * .2,
                                          child: const Center(
                                              child: Text(
                                                'Action',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(
                                        chalanReturndrop.results!.length,
                                            (index) => DataRow(
                                          // selected: true,
                                          cells: [
                                            DataCell(
                                              Container(
                                                height:40,

                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Text(
                                                    chalanReturndrop
                                                        .results![index].chalanNo
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                                Container(
                                                  height:40,
                                                  width:110,

                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top:8.0),
                                                    child: Text(
                                                      chalanReturndrop
                                                          .results![index]
                                                          .customer!.firstName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                )),
                                            DataCell(
                                                Container(
                                                  height:40,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top:8.0),
                                                    child: Text(
                                                      chalanReturndrop
                                                          .results![index]
                                                          .grandTotal
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                )),

                                            DataCell(
                                              GestureDetector(
                                                onTap: (){

                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChalanReturnDropScanPage(
                                                  id:  chalanReturndrop.results![index].id.toString(),

                                                  )));
                                                  log(chalanReturndrop.results![index].id.toString());
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
                                                          .dropbox,
                                                      size: 15,
                                                      color:
                                                      Colors.white,
                                                    ),
                                                  ),
                                                ),
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
