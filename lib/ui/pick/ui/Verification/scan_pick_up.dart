import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:soori_warehouse/ui/pick/ui/Verification/scan_verified_controller.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';

import '../../../../consts/buttons_const.dart';
import '../../../../consts/methods_const.dart';
import '../../../../consts/string_const.dart';
import '../../../../consts/style_const.dart';
import '../../model/pickup_verification_model.dart';

class ScanForVerified extends StatefulWidget {
  List<CustomerPackingType> customerPackingType;
  int index;
  int id;
  String qty;

  ScanForVerified(this.customerPackingType, this.index, this.id, this.qty);

  @override
  State<ScanForVerified> createState() => _ScanForVerifiedState();
}

class _ScanForVerifiedState extends State<ScanForVerified> {
  List<String> _packCodesList = [];
  List<String> _packCodesID = [];
  List<String> _pkCode = [];
  List<String> _scanedSerialNo = [];
  List<String> _scanedSerialId = [];
  Map<String, String> serialvalueDict = {};
  String _currentScannedCode = '';

  @override
  void initState() {
    savePackCodeList(widget.customerPackingType, widget.index);
    _newPickupInitDataWedgeListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Serial Codes ',
                  style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Pack Codes',
                  style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
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
                children: [
                  Expanded(
                    flex: 1,
                    child: displaySerialNos(),
                  ),
                  Expanded(flex: 1, child: displayPkNos()),
                ],
              )),
          kHeightMedium,
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
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
              onTap: () async {
                final pvr =
                    Provider.of<VerifiedController>(context, listen: false);
                List<String> updatedSerialId = pvr.serialId;
                updatedSerialId += _scanedSerialId;
                pvr.updateSerialId(newSerialId: updatedSerialId);
                _scanedSerialId.isNotEmpty
                    ? pvr.updateIndex(pk: widget.index)
                    : null;

                double a = double.parse(widget.qty);
                int itemCount = a.toInt();
                _scanedSerialId.length == itemCount
                    ? Navigator.pop(context)
                    : displayToast(msg: "Please Scan All serial number");

              },
              color: Color(0xff2c51a4),
            ),
          ),
        ],
      ),
    );
  }

  void savePackCodeList(List<CustomerPackingType> customerPackingType, index) {
    for (var i = 0; i < customerPackingType.length; i++) {
      for (var j = 0;
          j < customerPackingType[i].salePackingTypeDetailCode!.length;
          j++) {
        _packCodesList.add(customerPackingType[i]
            .salePackingTypeDetailCode![j]
            .code
            .toString());
        _packCodesID.add(
            customerPackingType[i].salePackingTypeDetailCode![j].id.toString());
      }
      _pkCode.add(customerPackingType[i].code.toString());
    }

    serialvalueDict.isNotEmpty
        ? {}
        : serialvalueDict = Map.fromIterables(_packCodesID, _packCodesList);
    log("dictionary" + serialvalueDict.toString());
    log(_pkCode.toString());
  }

  displaySerialNos() {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: smallShowMorePickUpLocations(
            "${_packCodesList.join("\n").toString()} "));
  }

  displayPkNos() {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            smallShowMorePickUpLocations("${_pkCode.join("\n").toString()} "));
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

  Future<void> _newPickupInitDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent(
      (response) {
        if (response != null && response is String) {
          Map<String, dynamic>? jsonResponse;
          try {
            jsonResponse = json.decode(response);

            if (jsonResponse != null) {
              _currentScannedCode =
                  jsonResponse["decodedData"].toString().trim();

              print("Scanned PK No : $_currentScannedCode");
              if (_pkCode.contains(_currentScannedCode)) {
                _scanedSerialNo.addAll(_packCodesList);
                _scanedSerialId.addAll(_packCodesID);
                _packCodesList.clear();
                _packCodesID.clear();
              } else if (serialvalueDict.containsValue(_currentScannedCode)) {
                serialvalueDict.forEach(
                  (key, value) {
                    if (value == _currentScannedCode) {
                      _scanedSerialId.add(key);
                    }
                  },
                );

                _scanedSerialNo.add(_currentScannedCode);
                _packCodesList.remove(_currentScannedCode);
              } else {
                displayToast(msg: "Wrong Scanned Plz Check Barcode");
              }
            } else {
              log("message error");
            }

            setState(() {});
          } catch (e) {
            rethrow;
          }
        } else {}
      },
    );
  }
}
