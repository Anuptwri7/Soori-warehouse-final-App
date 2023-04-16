import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/ui/location%20Shift/service/locationShiftService.dart';
import 'package:soori_warehouse/ui/pick/ui/pickup_order_save_codes.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';

import '../../../consts/buttons_const.dart';
import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import '../pick/model/pickup_list.dart';
import 'model/locationShifting.dart';

class LocationShifting extends StatefulWidget {

  @override
  State<LocationShifting> createState() => _LocationShiftingState();
}

class _LocationShiftingState extends State<LocationShifting> {
  List<String> _packCodesList = [];
  List<String> _packCodesID = [];
  late ProgressDialog pd;
  List<String> locationNumber = [];
  // List<String> _savedPackCodesID = [];

  List<String> _scanedSerialNo = [];
  String _packCodeNo = '', _scanedLocationNo = '', receivedLocation = '';
  String _currentScannedCode = '';
  late int totalSerialNo;

  List<String> _scannedIndex = [];

  @override
  void initState() {
    _newPickupInitDataWedgeListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Shifting",
          style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
        // backgroundColor: Color(0xff2c51a4),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Packet Code',
                style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.all(4.0),
              padding: EdgeInsets.all(4.0),
              decoration: kFormBoxDecoration,
              width: MediaQuery.of(context).size.width,
              child:  Text(
                  "${_packCodesList.isEmpty?"Please scan Pack code":_packCodesList}"),
            ),
            // Card(
            //   color: Color(0xffeff3ff),
            //   elevation: 8.0,
            //   clipBehavior: Clip.antiAlias,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12.0)),
            //   child: Text("${_packCodesList.isEmpty?"Please scan Pack code":_packCodesList}"),
            // ),
            kHeightMedium,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(
                    'Location',
                    style:
                    kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                  ),

            ),
            Container(
              margin: EdgeInsets.all(4.0),
              padding: EdgeInsets.all(4.0),
              decoration: kFormBoxDecoration,
              width: MediaQuery.of(context).size.width,
              child:  Text(
                  "${locationNumber.isEmpty?"Please scan the location":locationNumber}"),
            ),
            // Card(
            //   color: Color(0xffeff3ff),
            //   elevation: 8.0,
            //   clipBehavior: Clip.antiAlias,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12.0)),
            //   child: Text("${locationNumber.isEmpty?"Please scan the location":locationNumber}"),
            // ),
            kHeightMedium,

            ElevatedButton(
                onPressed: (){
                  LocationShiftingService();
                },
                child: Text("Update"))


          ],
        ),
      ),
    );
  }

  /*UI Part*/
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
                    _scanedLocationNo,
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
                    '${StringConst.packSerialNo} / Pack No :',
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _scanedSerialNo.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                        _scanedSerialNo[index].isNotEmpty
                            ? _scanedSerialNo[index]
                            : '',
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

  printLocationCodes() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        receivedLocation,
        style: kTextBlackSmall,
      ),
    );
  }

  displaySerialNos() {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: smallShowMorePickUpLocations(
            "${_packCodesList.join("\n").toString()} "));
  }



  Future<void> _newPickupInitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
        Map<String, dynamic>? jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {
            _currentScannedCode = jsonResponse["decodedData"].toString().trim();

            if(_packCodesList.isEmpty){
              _packCodesList.add(_currentScannedCode);
              LocationShiftingGetId(_packCodesList[0].toString());
            }else{
              locationNumber.add(_currentScannedCode);
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

  Future LocationShiftingGetId( String pk) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String finalUrl = sharedPreferences.getString("subDomain").toString();
    final response = await http.get(
      Uri.parse("https://${finalUrl}/api/v1/item-serialization-app/pack-code-location/${pk.toString()}" ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        }
    );
    if (response.statusCode == 200) {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sharedPreferences.setString("id",json.decode(response.body)['id'].toString());


      // log("got it ::::::::::::::"+response.body);


    } else{
      // log(response.statusCode.toString());
    }

    return response;
  }
  Future LocationShiftingService() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    log(StringConst.baseUrl + StringConst.locationShiftingApi);
    final response = await http.post(
        Uri.parse(StringConst.baseUrl + StringConst.locationShiftingApi),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        },
        body: json.encode(
          {
            "pack_type_code_id":int.parse(sharedPreferences.getString("id").toString()),
            "location_code": locationNumber[0].toString()
          }
        ));
    log("${int.parse(sharedPreferences.getString("id").toString())}");
    log("${locationNumber[0].toString()}");
    // log(response.body);
    if (response.statusCode == 201) {
      locationNumber.clear();
        Navigator.pop(context);
      Fluttertoast.showToast(msg: " successfully!");
    }else{
      Fluttertoast.showToast(msg: response.body.toString());
    }
    if (kDebugMode) {
      log('hello${response.statusCode}');
    }
    return response;
  }
  Future savePackIDToSP() async {
    pd = initProgressDialog(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? _savedPackCodesID =
    prefs.getStringList(StringConst.pickUpSavedPackCodesID);
    if (_savedPackCodesID != null) {
      _packCodesID.addAll(_savedPackCodesID);
    }
    ;
    prefs.setStringList(StringConst.pickUpSavedPackCodesID, _packCodesID);
    /*Adding the Index of Saved Codes*/
    List<String>? _scannedIndexID =
    prefs.getStringList(StringConst.pickUpsScannedIndex);
    if (_scannedIndexID != null) {
      _scannedIndex.addAll(_scannedIndexID);
    }
    prefs.setStringList(StringConst.pickUpsScannedIndex, _scannedIndex);

/*
    if(_scannedIDS !=null ) {
      prefs.setStringList(StringConst.pickUpsSavedItemID, );
      _packCodesID.addAll(_savedPackCodesID);
    };
*/

    pd.close();
    _scanedLocationNo == '';
    _scanedSerialNo.clear();
    displayToastSuccess(msg: 'Saved Successfuly');
    Navigator.pop(context);
  }

/*
  int pickupDetailsID;
  List<CustomerPackingType> customerPackingType;
  final  index;
  PickUpOrderSaveLocation(this.customerPackingType, this.pickupDetailsID, this.index);*/


}
