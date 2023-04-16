
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/buttons_const.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/login/login_screen.dart';
import 'package:soori_warehouse/ui/pick/model/pickup_details.dart';
import 'package:soori_warehouse/ui/pick/ui/pickup_order_details.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';
String _scanLocationNo = '';
class ScanToPickup extends StatefulWidget {
  int detailId;
  int id;
String code;
int packCodeId;
String qty;


  ScanToPickup(this.detailId,this.id,this.code,this.packCodeId,this.qty);

  @override
  State<ScanToPickup> createState() => _ScanToPickupState();
}

class _ScanToPickupState extends State<ScanToPickup> {
  Map dict={};
   List<String> _scanSerialNo = [];
  String _currentScannedCode = '';
  int scannedItem = 0;
  int totalReceivedQty = 0;
  String finalUrl = '';
  late int pkOrderID;
  List packCodesID =  [];
  List _packCodesList = [];
  List locationCodesList = [];
  List<String> previousSerialCodes = [];
  List gotSerialCodes=[];
  List gotSerialCodeId=[];
  List scannedSerialCodes=[];
  late ProgressDialog pd;
  List finalCodesToBeSent = [];

  @override
  void initState() {
    getSerialCode();
  log("dsfgfhg"+widget.id.toString());
  // getCodes();
  // int xyz=int.parse(widget.qty);
  // log("*-----------------------"+xyz.toString());
  // log(locationCodesList.toString())
  //   log(widget.code.toString());
    // initUi();
    // savePackCodeList(widget.customerPackingType);
    _pickupInitDataWedgeListener();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  log("//////"+gotSerialCodes.toString());
    return Scaffold(
      appBar: AppBar(title: Text('Scan Item Location'),
        backgroundColor: Color(0xff2c51a4),),
      body: ListView(
        children: [
          // FutureBuilder(
          //     future: getPickupDetail(),
          //     builder: (context, snapshot) {
          //       switch (snapshot.connectionState) {
          //         case ConnectionState.waiting:
          //           return const Center(
          //               child: CircularProgressIndicator());
          //         default:
          //           if (snapshot.hasError) {
          //
          //             return Text('Error: ${snapshot.error}');
          //           } else {
          //             return _pickOrderCards(snapshot.data);
          //             return Container();
          //           }
          //       }
          //     })
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pack Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
                Text('Qty : ${widget.qty}', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                _displayPackCode(),
                // _displayItemsSerialNo(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Serial Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          ListView(
            // controller: controller,
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: [
             // _currentScannedCode.isNotEmpty?
             FutureBuilder(
                  future: getSerialCode(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                            child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {

                          return Text('Error: ${snapshot.error}');
                        } else {
                          return _pickOrderCards(snapshot.data);
                          return Container();
                        }
                    }
                  })
                 // :Container()
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pack Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                _displayScannedCode(),
                // _displayItemsSerialNo(),
              ],
            ),
          ),


          kHeightMedium,

          Container(
            width: 120,
            padding:  const EdgeInsets.all(16.0),
            child: RoundedButtons(
              buttonText: 'Transfer',
              onTap: () =>
              // _packCodesList.length==widget.qty?
              postPickupTransfer(),
                  // :Fluttertoast.showToast(msg: "Scan Remaining items"),
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
  // _pickOrderCards( data) {
  //
  //
  //
  //   return data != null
  //       ? ListView.builder(
  //     // controller: controller,
  //       shrinkWrap: true,
  //       itemCount: data['results'].length,
  //       // physics: const NeverScrollableScrollPhysics(),
  //       itemBuilder: (context, index) {
  //         // log("im the data"+data.length.toString());
  //         return GestureDetector(
  //           onTap: (){
  //             // Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanToPickup()));
  //           },
  //           child: Card(
  //             margin: kMarginPaddSmall,
  //             color: Colors.white,
  //             elevation: kCardElevation,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12.0)),
  //             child: Container(
  //               padding: kMarginPaddSmall,
  //               child: Column(
  //                 children: [
  //                   Column(
  //                     children: [
  //                       Container(
  //                         height: 40,
  //                         width: 200,
  //                         // decoration: BoxDecoration(
  //                         //   color: const Color(0xffeff3ff),
  //                         //   borderRadius: BorderRadius.circular(10),
  //                         //   // boxShadow: const [
  //                         //   //   BoxShadow(
  //                         //   //     color: Color(0xffeff3ff),
  //                         //   //     offset: Offset(-2, -2),
  //                         //   //     spreadRadius: 1,
  //                         //   //     blurRadius: 10,
  //                         //   //   ),
  //                         //   // ],
  //                         // ),
  //                         child: Center(
  //                             child: Column(
  //                               children: [
  //                                 Text(
  //                                   "${data['results'][index]['code'].toString()}",
  //                                   style: TextStyle(fontWeight: FontWeight.bold),
  //                                 ),
  //                                 Text(
  //                                   "${data['results'][index]['location_code'].toString()}",
  //                                   style: TextStyle(fontWeight: FontWeight.bold),
  //                                 ),
  //                               ],
  //                             )),
  //                       ),
  //                     ],
  //                   ),
  //
  //
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       })
  //       : Center(
  //     child: Text(
  //       StringConst.noDataAvailable,
  //       style: kTextStyleBlack,
  //     ),
  //   );
  // }
  /*Network Part*/
  _pickOrderCards( data) {
    return data != null
        ? ListView.builder(
      // controller: controller,
        shrinkWrap: true,
        itemCount: 1,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          // log("im the data"+data.length.toString());
          return GestureDetector(
            onTap: (){
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanToPickup(data['results'][index]['purchase_detail'],data['results'][index]['code'],data['results'][index]['id'],widget.qty)));
            },
            child: Visibility(
              visible: data['result']==[]?false:true,
              child: Card(
                margin: kMarginPaddSmall,
                color: Colors.white,
                elevation: kCardElevation,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Container(

                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [

                      Row(
                        children: [

                          Container(

                            height: 80,
                            width: 200,
                            // decoration: BoxDecoration(
                            //   color: const Color(0xffeff3ff),
                            //   borderRadius: BorderRadius.circular(10),
                            //   boxShadow: const [
                            //     BoxShadow(
                            //       color: Color(0xffeff3ff),
                            //       offset: Offset(-2, -2),
                            //       spreadRadius: 1,
                            //       blurRadius: 10,
                            //     ),
                            //   ],
                            // ),
                            child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    "${gotSerialCodes}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),

                        ],
                      ),
                      kHeightMedium,


                    ],
                  ),
                ),
              ),
            ),
          );
        })
        : Center(
      child: Text(
        StringConst.noDataAvailable,
        style: kTextStyleBlack,
      ),
    );
  }
  _displayPackCode() {
    return Card(
      elevation: kCardElevation,
      shape: kCardRoundedShape,
      child: Padding(
        padding: kMarginPaddSmall,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    widget.code,
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
            kHeightSmall,
          ],
        ),
      ),
    );
  }
  _displayScannedCode() {
    return Card(
      elevation: kCardElevation,
      shape: kCardRoundedShape,
      child: Padding(
        padding: kMarginPaddSmall,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    _packCodesList.toString(),
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
            kHeightSmall,
          ],
        ),
      ),
    );
  }

  /*UI Part*/
  _displayLocationSerialNo() {
    return Card(
      elevation: kCardElevation,
      shape: kCardRoundedShape,
      child: Padding(
        padding: kMarginPaddSmall,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Location No :',
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    _scanLocationNo,
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
            kHeightSmall,
          ],
        ),
      ),
    );
  }

  // _displayItemsSerialNo() {
  //   return Card(
  //     elevation: kCardElevation,
  //     shape: kCardRoundedShape,
  //     child: Padding(
  //       padding: kMarginPaddSmall,
  //       child: Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(
  //                 flex: 2,
  //                 child: Text(
  //                   '${StringConst.packSerialNo} / Pack No :',
  //                   style: kTextStyleSmall.copyWith(
  //                       fontWeight: FontWeight.bold, color: Colors.black),
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 4,
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: _scanSerialNo.length,
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   itemBuilder: (BuildContext context, int index) {
  //                     return Text(
  //                       _scanSerialNo[index].isNotEmpty ? _scanSerialNo[index] : '',
  //                       style: kTextStyleSmall.copyWith(
  //                           fontWeight: FontWeight.bold, color: Colors.black),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //           kHeightSmall,
  //         ],
  //       ),
  //     ),
  //   );
  // }

  popAndLoadPage(pkOrderID) {
    Navigator.pop(context);
    Navigator.pop(context);
    goToPage(context, PickUpOrderDetails(pkOrderID));

    // goToPage(context, PickUpDetails());
  }

  Future<void> _pickupInitDataWedgeListener() async {

    ZebraDataWedge.listenForDataWedgeEvent((response) {

      if (response != null && response is String) {
        Map<String, dynamic>? jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {
            _currentScannedCode = '';

            _currentScannedCode = jsonResponse["decodedData"].toString().trim();

            print("Current Location : $_currentScannedCode");
            print("Location Codes: $_packCodesList");
          if(dict.containsKey(_currentScannedCode)){
            dict.forEach((key, value) {
              if(key==_currentScannedCode){
                finalCodesToBeSent.add(value);
              }
            });
          }
          log("dfhakjghslkdgjk"+finalCodesToBeSent.toString());
            if(_packCodesList.contains(_currentScannedCode)){}
            else{
              if(gotSerialCodes.contains(_currentScannedCode)){
                setState(() {
                  _packCodesList.add(_currentScannedCode);

                });
              }
            }

                  // getSerialCode();
          }
          else{
            // displayToast(msg: 'Something went wrong, Please Scan Again');
          }
        } catch (e) {
          // displayToast(msg: 'Something went wrong, Please Scan Again');
        }
      }


      else{
        // print('')
      }
    });

  }


  void savePackCodeList(List<CustomerPackingType> customerPackingType) {

    totalReceivedQty = customerPackingType.length;
    // locationCodesList.add(customerPackingType[widget.index].locationCode);

    for(int i = 0; i < customerPackingType.length; i++){
      for(int j = 0; j < customerPackingType[i].salePackingTypeDetailCode.length; j++){

        String serialNos = customerPackingType[i].salePackingTypeDetailCode[j].code;
        int serialID = customerPackingType[i].salePackingTypeDetailCode[j].id;

        _packCodesList.add(customerPackingType[i].code);
        packCodesID.add(serialID);
        previousSerialCodes.add(serialNos);

      }
    }

    print("Serial Codes: $packCodesID");
    print("Previous Serial Code: $previousSerialCodes");

  }
  Future getPickupScanDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString(StringConst.subDomain).toString();
    http.Response response = await NetworkHelper(
        '$finalUrl${StringConst.baseUrl+StringConst.pickupDetail}${widget.id}')
        .getOrdersWithToken();
    print("Response Code Drop: ${response.statusCode}");
    log("--------------------${jsonDecode(response.body)}");

    if (response.statusCode == 404) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        printResponse(response);
        return jsonDecode(response.body);
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
    // setState(() {
    //   isFirstLoadRunning = false;
    // }
    // );
    return null;
  }
  Future getSerialCode() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse("https://$finalUrl${StringConst.getSerialCode}pack_type_code=${widget.packCodeId}&limit=${widget.qty}&code="),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // http.Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.baseUrl+StringConst.getSerialCode}pack_type_code=${widget.packCodeId}&limit=${widget.qty}&code=')
    //     .getOrdersWithToken();
    print("Response Code Drop-----------: ${response.statusCode}");
    log("--------------------${jsonDecode(response.body)}");
        var serial;
        var code;
    if (response.statusCode == 404) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        printResponse(response);

        for(int i=0;i<jsonDecode(response.body)['results'].length;i++){
          if(gotSerialCodes.length==jsonDecode(response.body)['results'].length){

          }else{
            gotSerialCodes.add(jsonDecode(response.body)['results'][i]["code"]);
            gotSerialCodeId.add(jsonDecode(response.body)['results'][i]["id"]);

            dict=  Map.fromIterables(gotSerialCodes,gotSerialCodeId);
          }

        }
        log(dict.toString());

        return jsonDecode(response.body);
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
    // setState(() {
    //   isFirstLoadRunning = false;
    // }
    // );
    return null;
  }
  Future postPickupTransfer() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    finalUrl = sharedPreferences.getString(StringConst.subDomain).toString();
   var baseUrl= sharedPreferences.getString("subDomain");
    log(StringConst.baseUrl + StringConst.postPickupTransfer);

    log(dict.toString());

    var finalBody = [];
    for(int i =0;i<finalCodesToBeSent.length;i++){
      finalBody.add({
        "packing_type_detail_code": finalCodesToBeSent[i]
      });
    }


    final response = await http.post(
        Uri.parse('https://$finalUrl${StringConst.postPickupTransfer}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        },
        body:(jsonEncode(
            {
              "transfer_detail":widget.detailId,
              "transfer_packing_types": [
                {
                  "packing_type_code": widget.packCodeId,
                  "sale_packing_type_detail_code": finalBody
                }
              ]
            }
        )));

    if (response.statusCode == 201) {

      dict.clear();
      Navigator.pop(context);

    }else{

    }
    
    if (kDebugMode) {
      log('hello${response.statusCode}');
    }
    return response;
  }


}

