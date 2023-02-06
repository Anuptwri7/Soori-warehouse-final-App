
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
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
class PickUpScanLocation extends StatefulWidget {

  int pickupDetailsID;
  List<CustomerPackingType> customerPackingType;
  final  index;
  PickUpScanLocation(this.customerPackingType, this.pickupDetailsID, this.index);


  @override
  State<PickUpScanLocation> createState() => _PickUpScanLocationState();
}

class _PickUpScanLocationState extends State<PickUpScanLocation> {

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

  late ProgressDialog pd;

  @override
  void initState() {
    initUi();
    savePackCodeList(widget.customerPackingType);
    _pickupInitDataWedgeListener();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popAndLoadPage(pkOrderID),
      child: Scaffold(
        appBar: AppBar(title: const Text('Scan Item Location'),
          backgroundColor: Color(0xff2c51a4),),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total : ${totalReceivedQty}', style:  kHintTextStyle,),
                  Text('Scanned : $scannedItem', style: kHintTextStyle),
                ],
              ),
            ),
            kHeightMedium,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Pickup Location', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
            ),
            Card(
              elevation: 8.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: printLocationCodes(),
            ),
            kHeightMedium,

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Serial Codes ', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
                  Text('Pack Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Card(
              elevation: 8.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 2,
                    child : printSerialNos(),
                  ),
                  Expanded(
                      flex: 2,
                    child: showPackCodes(),
                  ),
                ],
              )
            ),

            kHeightMedium,
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  _displayLocationSerialNo(),
                  _displayItemsSerialNo(),
                ],
              ),
            ),
            kHeightMedium,
            Container(
              width: 120,
              padding:  const EdgeInsets.all(16.0),
              child: RoundedButtons(
                buttonText: 'Pickup',
                onTap: () =>  _scanSerialNo.length == previousSerialCodes.length
                    ?  postPickUpOrder(packCodesID, widget.pickupDetailsID)
                    : displayToast(msg: 'Please Complete Your Scan First'),
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Network Part*/

  Future<void> postPickUpOrder(_pickUpOrderList, _pickUpDetailsItemID) async {
    pd.show(max: 100, msg: 'Updating Pickup Item...');

    try {
      Response response = await NetworkHelper(
          '$finalUrl${StringConst.urlCustomerOrderApp}pickup-customer-order')
          .pickUpOrders(_pickUpDetailsItemID, _pickUpOrderList);

       pd.close();
      if (response.statusCode == 401) {
        replacePage(LoginScreen(), context);
      } else {
        if (response.statusCode == 200 || response.statusCode == 201) {
          popAndLoadPage(pkOrderID);
          displayToastSuccess(msg: 'Scan Successfull');
        } else {
          displayToast(msg: StringConst.somethingWrongMsg);
        }
      }
    }
      catch(e){
        displayToast(msg: e.toString());
        // pd.close();

      }

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
            print("Location Codes: $locationCodesList");

            if(_scanLocationNo.isEmpty) {
              locationCodesList.contains(_currentScannedCode)
                  ? setState(() {_scanLocationNo = _currentScannedCode;})
                  : displayToast(msg: 'Invalid Location, Scan Again');
            }

            else if(_scanSerialNo.isEmpty || _scanSerialNo.length<previousSerialCodes.length) {
              if(previousSerialCodes.contains(_currentScannedCode)) {
                setState(() {
                  _scanSerialNo.add(_currentScannedCode);
                  previousSerialCodes.remove(_currentScannedCode);
                });
              }
              else if(widget.customerPackingType[widget.index].code == _currentScannedCode
                  && _scanSerialNo.length < previousSerialCodes.length){
                setState(() {
                  _scanSerialNo.addAll(previousSerialCodes);
                  previousSerialCodes.remove(_currentScannedCode);
                });
              }
            /*  else{
                displayToast(msg: ' Invalid Serial or Pack No, Scan Again');
              }*/
            }
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

  Future<void> initUi() async {

    pd = initProgressDialog(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    finalUrl = prefs.getString(StringConst.subDomain).toString();
    String pickOrderID = prefs.getString(StringConst.pickUpOrderID).toString();
    pkOrderID = int.parse(pickOrderID);
  }

  void savePackCodeList(List<CustomerPackingType> customerPackingType) {

    totalReceivedQty = customerPackingType.length;
      locationCodesList.add(customerPackingType[widget.index].locationCode);

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

}
