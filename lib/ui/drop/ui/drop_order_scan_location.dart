
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/buttons_const.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/drop/ui/drop_order_details.dart';
import 'package:soori_warehouse/ui/login/login_screen.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';

import '../model/drop_details_model.dart';
String _scanLocationNo = '';
class DOScanLocation extends StatefulWidget {

  List locationSavedCodes = [];
  List<PoPackTypeCode> poPackTypeCode = [];

  DOScanLocation(this.poPackTypeCode, this.locationSavedCodes);

  @override
  State<DOScanLocation> createState() => _DOScanLocationState();
}

class _DOScanLocationState extends State<DOScanLocation> {

  String _scanPackNo = '';
  String _currentScannedCode = '';

  int scannedItem = 0;
  String finalUrl = '';
  late int _dropOrderID;
  late ProgressDialog pd;

  List packSavedCodes = [];
  int totalReceivedQty = 0;

  @override
  void initState() {

    initUi();
    _dropinitDataWedgeListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popAndLoadPage(_dropOrderID),
      child: Scaffold(
        appBar: AppBar(title: const Text('Scan Item Location'),
        backgroundColor: Color(0xff2c51a4),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text("Total:",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 30,),
                      Container(
                        height: 30,
                        width: 60,
                        decoration:  BoxDecoration(
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
                        child: Center(child: Text("${totalReceivedQty}",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  ),
                  // Text('Total : ${totalReceivedQty}', style:  kHintTextStyle,),
                  Row(
                    children: [
                      Container(
                        child: Text("Scanned:",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 30,),
                      Container(
                        height: 30,
                        width: 60,
                        decoration:  BoxDecoration(
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
                        child: Center(child: Text("${scannedItem}",style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  ),
                  // Text('Scanned : $scannedItem', style: kHintTextStyle),
                ],
              ),
              kHeightMedium,
              Padding(
                padding: const EdgeInsets.all(8.0),

                child: Text('Pack Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
              ),
              Card(
                color: Color(0xffeff3ff),
                elevation: 8.0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: printPackCodes(),
              ),
              kHeightMedium,
              Column(
                children: [
                  _displayLocationSerialNo(),
                  _displayItemsSerialNo(),
                ],
              ),
              kHeightMedium,
              Container(
                width: 120,
                padding:  const EdgeInsets.all(16.0),
                child: RoundedButtons(
                  buttonText: 'Drop',
                  onTap: () =>
                      _scanLocationNo.isNotEmpty && _scanPackNo.isNotEmpty
                      ? dropCurrentItem(_scanLocationNo, _scanPackNo)
                      : displayToast(msg:  'Please Scan Codes and Try Again'),
                  color: Color(0xff2c51a4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  /*Network Request*/
  Future dropCurrentItem(locationCode, packCode)  async {
    // pd.show(max: 100, msg: 'Updating Drop Item...');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // String finalUrl = prefs.getString(StringConst.subDomain).toString();
      String dropOrderID = prefs.getString(StringConst.dropOrderID).toString();
      int _dropOrderID = int.parse(dropOrderID);
      String finalUrl = prefs.getString("subDomain").toString();
      final response = await http.post(
          Uri.parse('https://$finalUrl${StringConst.urlPurchaseApp}location-purchase-order-details'),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${prefs.get("access_token")}'
          },
      body: (jsonEncode({
        "packing_type_code":packCode ,
        "location_code":locationCode
      })));
      // Response response = await NetworkHelper(
      //     '$finalUrl${StringConst.urlPurchaseApp}location-purchase-order-details')
      //     .dropReceivedOrders(locationCode, packCode);

      // pd.close();

      if (response.statusCode == 401) {replacePage(LoginScreen(), context);}
      else {
        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            scannedItem++;
            _scanLocationNo = '';
            _scanPackNo = '';
            packSavedCodes.remove(packCode);
          });
          displayToastSuccess(msg: 'Item Dropped Successfully');

          if(scannedItem==totalReceivedQty){
            popAndLoadPage(_dropOrderID);
          }
        } else {
          // displayToast(msg: StringConst.somethingWrongMsg);
        }
      }

  }


  /*UI Part*/
  Future<void> _dropinitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
          Map<String, dynamic>? jsonResponse;
          try {
            jsonResponse = json.decode(response);

            if (jsonResponse != null) {
              _currentScannedCode = jsonResponse["decodedData"].toString().trim();

              if(_scanLocationNo.isEmpty) {
                widget.locationSavedCodes.contains(_currentScannedCode)
                    ? setState(() {_scanLocationNo = _currentScannedCode;})
                    : displayToast(msg : "Invalid Pack Location");
              }
              // if(_scanPackNo!=_currentScannedCode){
              //   Fluttertoast.showToast(msg: "Error");
              // }
              // else
                if(_scanPackNo.isEmpty){
                packSavedCodes.contains(_currentScannedCode)
                    ? setState(() {
                  _scanPackNo = _currentScannedCode;
                })
                    : displayToast(msg: 'Pack Code Invalid, Try Again');
              }
              else{
                // displayToast(msg: 'Please Save, and Try Again');
              }

            } else {
              // displayToast(msg: 'Something went wrong, Please Try Again');
              // _source = "An error Occured";
            }


          } catch (e) {
            // displayToast(msg: 'Something went wrong, Please Scan Again');
          }

      }
      else{
        //
      }
    });
  }

  popAndLoadPage(dropOrderID) {
    Navigator.pop(context);
    Navigator.pop(context);
    goToPage(context, DropOrderDetails(dropOrderID));
  }

  Future<void> initUi() async {
    // pd = initProgressDialog(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
     finalUrl = prefs.getString(StringConst.subDomain).toString();
    String dropOrderID = prefs.getString(StringConst.dropOrderID).toString();
    _dropOrderID = int.parse(dropOrderID);


    /*Total Received Qty*/
    totalReceivedQty  = int.parse(widget.poPackTypeCode.length.toString());

    savePackCodeList(widget.poPackTypeCode);

    print("REceived Location CodeS: ${widget.locationSavedCodes}");


  }

  _displayLocationSerialNo() {
    return Card(
      color: Color(0xffeff3ff),
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
      color: Color(0xffeff3ff),
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
                    'Pack Code: ',
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    _scanPackNo,
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

  printPackCodes() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: showMorePickUpLocations(packSavedCodes.join("\n").toString(),),
    );
  }


  void savePackCodeList(List<PoPackTypeCode> poPackTypeCodes) {

    for(int i = 0 ; i < poPackTypeCodes.length; i++){
      packSavedCodes.add(poPackTypeCodes[i].code);
    }
    setState(() {
    });

  }

}

