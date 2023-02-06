import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/chalanReturnDrop/Model/chalanReturnDropScan.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import 'Model/chalanReturnDropModel.dart';
import 'package:http/http.dart' as http;
import 'Services/chalanReturnDropAPI.dart';
import 'chalanReturnDropScanPage.dart';


class ChalanReturnDropScanPage extends StatefulWidget {
final String id;

  const ChalanReturnDropScanPage({Key? key,required this.id}) : super(key: key);

  @override
  State<ChalanReturnDropScanPage> createState() =>
      _ChalanReturnDropScanPageState();
}

class _ChalanReturnDropScanPageState extends State<ChalanReturnDropScanPage> {
  List<String> _packCodesList = [];
  List<String> _packCodesID = [];
List<String> serial = [];
String ? id;
  List<String> locationNumber = [];
  // List<String> _savedPackCodesID = [];

  List<String> _scanedSerialNo = [];
  String _packCodeNo = '', _scanedLocationNo = '', receivedLocation = '';
  String _currentScannedCode = '';
  late int totalSerialNo;

  List<String> _scannedIndex = [];
  // String get $i => null;

  final TextEditingController _searchController = TextEditingController();
  static String _searchItem = '';
  ChalanReturnDropServices chalanReturnDropServices=ChalanReturnDropServices();
  Future searchHandling() async {
    // await Future.delayed(const Duration(seconds: 3));
    log(" SEARCH ${_searchController.text}");
    if (_searchItem == "") {
      return await chalanReturnDropServices.fetchChalanReturnDropScan('');
    } else {
      return await chalanReturnDropServices.fetchChalanReturnDropScan(widget.id);
    }
  }


  @override
  void initState() {

    _newPickupInitDataWedgeListener();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(serial.toString());

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
                      'Chalan Return Drop Scan',
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
                        FutureBuilder(
                          future: chalanReturnDropServices.fetchChalanReturnDropScan(widget.id),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {

                              try {
                                final snapshotData = json.decode(snapshot.data);
                                ChalanReturnDropScan chalanreturndropscan =
                                         ChalanReturnDropScan.fromJson(snapshotData);

                                return DataTable(
                                  columnSpacing: 15,
                                  horizontalMargin: 0,
                                  // columnSpacing: 10,
                                  columns: const [
                                    DataColumn(
                                      label: SizedBox(

                                        child: Text('Pack Code'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 80,
                                        child: Text('Location'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 80,
                                        child: Center(child: Text('Serial')),
                                      ),
                                    ),

                                  ],
                                  rows: List.generate(
                                    chalanreturndropscan.results!.length,
                                    (index) => DataRow(

                                      // selected: true,
                                      cells: [

                                        DataCell(
                                          Text(chalanreturndropscan.results![index].chalanPackingTypes![index].code.toString()),
                                        ),
                                        DataCell(
                                          Text(chalanreturndropscan.results![index].chalanPackingTypes![index].locationCode.toString()),
                                        ),
                                        DataCell(
                                          Container(
                                              decoration: BoxDecoration(
                            color:Colors.blue.shade100,
                            ),
                                              child: Text(chalanreturndropscan.results![index].chalanPackingTypes![index].salePackingTypeDetailCode![index].code.toString())),

                                        ),


                                      ],
                                    ),
                                  ),
                                );

                              } catch (e) {
                                throw Exception(e);
                              }
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),


                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          Text(
                            'Location',
                            style:
                            kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                          ),

                        ),
                        Card(
                          color: Color(0xffeff3ff),
                          elevation: 8.0,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Text("${locationNumber.isEmpty?"Please scan the location":locationNumber}"),
                        ),
                        kHeightMedium,
                        ElevatedButton(
                            onPressed: (){
                              ChalanReturnDropScanServices();

                            },
                            child: Text("Update"))
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
  Future<void> _newPickupInitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
        Map<String, dynamic>? jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {
            _currentScannedCode = jsonResponse["decodedData"].toString().trim();
            if(locationNumber.isEmpty){
              locationNumber.add(_currentScannedCode);
            }else{
              log("this is location"+ locationNumber.toString());
            }

          } else {
            // displayToast(msg: 'Something went wrong, Please Scan Again');
          }

          setState(() {});
        } catch (e) {
          // displayToast(msg: 'Something went wrong, Please Scan Again');
        }
      } else {
        // print('')
      }
    });
  }
  Future ChalanReturnDropScanServices() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    log(StringConst.baseUrl + StringConst.chalanReturnDropUpdate);

var serialFinal =[];
    for(int i=0;i<allData.length;i++){
      serialFinal.add(allData[i].id.toString());
      log(widget.id.toString()+serialFinal.toString());
    }
    final response = await http.post(
        Uri.parse(StringConst.baseUrl + StringConst.chalanReturnDropScanService),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        },
        body: json.encode(
            {
              "chalan_master": widget.id,
              "chalan_serial_nos":serialFinal
            }
        ));
    log(response.body);
      if (response.statusCode == 201) {
        serial.clear();
        allData.clear();

        locationNumber.clear();
        Navigator.pop(context);
        Fluttertoast.showToast(msg: " successfully!");
      }else{
        serial.clear();
        allData.clear();
      }

      if (kDebugMode) {
        log('hello${response.statusCode}');
      }
      return response;
    }

  }

