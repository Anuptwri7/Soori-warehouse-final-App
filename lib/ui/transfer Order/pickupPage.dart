
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

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
import 'package:soori_warehouse/ui/transfer%20Order/scanToPickup.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';
String _scanLocationNo = '';
class PickupTransfer extends StatefulWidget {
  int detailId;
int id;
String qty;

  PickupTransfer(this.detailId,this.id,this.qty);


  @override
  State<PickupTransfer> createState() => _PickupTransferState();
}

class _PickupTransferState extends State<PickupTransfer> {

  final List<String> _scanSerialNo = [];
  String _currentScannedCode = '';
  int scannedItem = 0;
  int totalReceivedQty = 0;

  String finalUrl = '';
  late int pkOrderID;

  List packCodesID =  [];
  List<String> _packCodesList = [];
  List locationCodesList = [];
  List<String> previousSerialCodes = [];


  @override
  void initState() {
    // initUi();
    // getPickupDetail();
    // savePackCodeList(widget.customerPackingType);
    // _pickupInitDataWedgeListener();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pickup Transfer Order'),
        backgroundColor: Color(0xff2c51a4),),
      body:   FutureBuilder(
          future: getPickupDetail(),
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
          }),
    );
  }
  _pickOrderCards( data) {

    return data != null
        ? ListView.builder(
        // controller: controller,
        shrinkWrap: true,
        itemCount: data['results'].length,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          // log("im the data"+data.length.toString());
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanToPickup(widget.detailId,data['results'][index]['purchase_detail'],data['results'][index]['code'],data['results'][index]['id'],widget.qty)));
            },
            child: Card(
              margin: kMarginPaddSmall,
              color: Colors.white,
              elevation: kCardElevation,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                padding: kMarginPaddSmall,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Item:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 30,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xffeff3ff),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xffeff3ff),
                                offset: Offset(-2, -2),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                              child: Text(
                                "${data['results'][index]['item_name'].toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                    kHeightMedium,
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Location:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 30,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xffeff3ff),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xffeff3ff),
                                offset: Offset(-2, -2),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                              child: Text(
                                "${data['results'][index]['location_code'].toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                    kHeightMedium,

                  ],
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
  /*Network Part*/
  //
  // Future<void> postPickUpOrder(_pickUpOrderList, _pickUpDetailsItemID) async {
  //   pd.show(max: 100, msg: 'Updating Pickup Item...');
  //
  //   try {
  //     Response response = await NetworkHelper(
  //         '$finalUrl${StringConst.urlCustomerOrderApp}pickup-customer-order')
  //         .pickUpOrders(_pickUpDetailsItemID, _pickUpOrderList);
  //
  //     pd.close();
  //     if (response.statusCode == 401) {
  //       replacePage(LoginScreen(), context);
  //     } else {
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         popAndLoadPage(pkOrderID);
  //         displayToastSuccess(msg: 'Scan Successfull');
  //       } else {
  //         displayToast(msg: StringConst.somethingWrongMsg);
  //       }
  //     }
  //   }
  //   catch(e){
  //     displayToast(msg: e.toString());
  //     // pd.close();
  //
  //   }
  //
  // }

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

  _displayItemsSerialNo() {
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
                    '${StringConst.packSerialNo} / Pack No :',
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _scanSerialNo.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                        _scanSerialNo[index].isNotEmpty ? _scanSerialNo[index] : '',
                        style: kTextStyleSmall.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      );
                    },
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

  popAndLoadPage(pkOrderID) {
    Navigator.pop(context);
    Navigator.pop(context);
    goToPage(context, PickUpOrderDetails(pkOrderID));

    // goToPage(context, PickUpDetails());
  }
  //
  // Future<void> _pickupInitDataWedgeListener() async {
  //
  //   ZebraDataWedge.listenForDataWedgeEvent((response) {
  //
  //     if (response != null && response is String) {
  //       Map<String, dynamic>? jsonResponse;
  //       try {
  //         jsonResponse = json.decode(response);
  //
  //         if (jsonResponse != null) {
  //           _currentScannedCode = '';
  //
  //           _currentScannedCode = jsonResponse["decodedData"].toString().trim();
  //
  //           print("Current Location : $_currentScannedCode");
  //           print("Location Codes: $locationCodesList");
  //
  //           if(_scanLocationNo.isEmpty) {
  //             locationCodesList.contains(_currentScannedCode)
  //                 ? setState(() {_scanLocationNo = _currentScannedCode;})
  //                 : displayToast(msg: 'Invalid Location, Scan Again');
  //           }
  //
  //           else if(_scanSerialNo.isEmpty || _scanSerialNo.length<previousSerialCodes.length) {
  //             if(previousSerialCodes.contains(_currentScannedCode)) {
  //               setState(() {
  //                 _scanSerialNo.add(_currentScannedCode);
  //                 previousSerialCodes.remove(_currentScannedCode);
  //               });
  //             }
  //             else if(widget.customerPackingType[widget.index].code == _currentScannedCode
  //                 && _scanSerialNo.length < previousSerialCodes.length){
  //               setState(() {
  //                 _scanSerialNo.addAll(previousSerialCodes);
  //                 previousSerialCodes.remove(_currentScannedCode);
  //               });
  //             }
  //             /*  else{
  //               displayToast(msg: ' Invalid Serial or Pack No, Scan Again');
  //             }*/
  //           }
  //         }
  //         else{
  //           // displayToast(msg: 'Something went wrong, Please Scan Again');
  //         }
  //       } catch (e) {
  //         // displayToast(msg: 'Something went wrong, Please Scan Again');
  //       }
  //     }
  //
  //
  //     else{
  //       // print('')
  //     }
  //   });
  //
  // }



  // void savePackCodeList(List<CustomerPackingType> customerPackingType) {
  //
  //   totalReceivedQty = customerPackingType.length;
  //   locationCodesList.add(customerPackingType[widget.index].locationCode);
  //
  //   for(int i = 0; i < customerPackingType.length; i++){
  //     for(int j = 0; j < customerPackingType[i].salePackingTypeDetailCode.length; j++){
  //
  //       String serialNos = customerPackingType[i].salePackingTypeDetailCode[j].code;
  //       int serialID = customerPackingType[i].salePackingTypeDetailCode[j].id;
  //
  //       _packCodesList.add(customerPackingType[i].code);
  //       packCodesID.add(serialID);
  //       previousSerialCodes.add(serialNos);
  //
  //     }
  //   }
  //
  //   print("Serial Codes: $packCodesID");
  //   print("Previous Serial Code: $previousSerialCodes");
  //
  // }

  printLocationCodes() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: showMorePickUpLocations(" ${locationCodesList.join(" ").toString()} "),
    );
  }

  printSerialNos(){
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: smallShowMorePickUpLocations("${previousSerialCodes.join("\n").toString()} ")

    );


  }

  showPackCodes() {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: smallShowMorePickUpLocations("${_packCodesList.join("\n").toString()} ")

    );

  }

  Future getPickupDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse("https://$finalUrl${StringConst.pickupDetail}${widget.id}"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // http.Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.pickupDetail}${widget.id}')
    //     .getOrdersWithToken();
    print("Response Code Drop: ${response.statusCode}");
    log("+++++++++++++++++++${jsonDecode(response.body)}");

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

}
