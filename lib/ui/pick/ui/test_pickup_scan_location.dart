import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/ui/pick/ui/pickup_order_save_codes.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';

import '../../../consts/buttons_const.dart';
import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import '../model/pickup_details.dart';

class TestPickupScanLocation extends StatefulWidget {
  List<CustomerPackingType> customerPackingType;
  int index;
  int savePickupCodesIndex, scanPickupDetailsID;

  TestPickupScanLocation(this.customerPackingType, this.index,
      this.savePickupCodesIndex, this.scanPickupDetailsID);

  @override
  State<TestPickupScanLocation> createState() => _TestPickupScanLocationState();
}

class _TestPickupScanLocationState extends State<TestPickupScanLocation> {
  List<String> _packCodesList = [];
  List<String> _packCodesID = [];
  late ProgressDialog pd;

  // List<String> _savedPackCodesID = [];

  List<String> _scanedSerialNo = [];
  String _packCodeNo = '', _scanedLocationNo = '', receivedLocation = '';
  String _currentScannedCode = '';
  late int totalSerialNo;

  List<String> _scannedIndex = [];

  @override
  void initState() {
    initUi();

    savePackCodeList(widget.customerPackingType, widget.index);
    _newPickupInitDataWedgeListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popAndLoadPage(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan Item Location'),
          backgroundColor: Color(0xff2c51a4),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pickup Location',
                style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              color: Color(0xffeff3ff),
              elevation: 8.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: printLocationCodes(),
            ),
            kHeightMedium,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Serial Codes ',
                    style:
                        kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Pack Codes',
                    style:
                        kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Card(
                color: Color(0xffeff3ff),
                elevation: 8.0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 2,
                      child: displaySerialNos(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        _packCodeNo,
                        style: kTextBlackSmall,
                      ),
                    ),
                  ],
                )),
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
              padding: const EdgeInsets.all(16.0),
              child: RoundedButtons(
                buttonText: 'Save',
                onTap: () => {
                  // Save to local Preference
                  print("Total Serila No : $totalSerialNo "),
                  print("Scanned Serila No : ${_scanedSerialNo.length}"),
                  if (totalSerialNo == _scanedSerialNo.length)
                    {savePackIDToSP()}
                },
                color: Color(0xff2c51a4),
              ),
            ),
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

  void savePackCodeList(List<CustomerPackingType> customerPackingType, index) {
    _packCodeNo = customerPackingType[index].code;
    for (int j = 0;
        j < customerPackingType[index].salePackingTypeDetailCode.length;
        j++) {
      int serialID = customerPackingType[index].salePackingTypeDetailCode[j].id;
      _packCodesList
          .add(customerPackingType[index].salePackingTypeDetailCode[j].code);
      _packCodesID.add(serialID.toString());
    }
    totalSerialNo = _packCodesList.length;
  }

  Future<void> _newPickupInitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
        Map<String, dynamic>? jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {
            _currentScannedCode = jsonResponse["decodedData"].toString().trim();

            print("Scanned Location No : $_scanedLocationNo");

            if (_scanedLocationNo.isEmpty && _scanedSerialNo.isEmpty) {
              receivedLocation == _currentScannedCode
                  ? _scanedLocationNo = _currentScannedCode
                  : displayToast(msg: 'Invalid Location, Scan Again');
            } else if (_scanedSerialNo.isEmpty ||
                _scanedSerialNo.length < _packCodesList.length) {
              if (_packCodesList.contains(_currentScannedCode)) {
                _scanedSerialNo.add(_currentScannedCode);
                _packCodesList.remove(_currentScannedCode);
              } else if (_packCodeNo == _currentScannedCode &&
                  _scanedSerialNo.length < _packCodesList.length) {
                _scanedSerialNo.addAll(_packCodesList);
                _packCodesList.remove(_currentScannedCode);
              }
              /*  else{
                displayToast(msg: ' Invalid Serial or Pack No, Scan Again');
              }*/
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

  void initUi() {
    receivedLocation =
        widget.customerPackingType[widget.index].locationCode.toString();
    // log(receivedLocation);
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
    _scannedIndex.add(widget.index.toString());
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

  popAndLoadPage() {
    Navigator.pop(context);
    Navigator.pop(context);
    goToPage(
        context,
        PickUpOrderSaveLocation(widget.customerPackingType,
            widget.scanPickupDetailsID, widget.savePickupCodesIndex));

    // goToPage(context, PickUpDetails());
  }
}
