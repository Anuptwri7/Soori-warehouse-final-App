/*// @dart=2.9*/
/*

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_zebra_datawedge/flutter_zebra_datawedge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/model/get_pending_orders.dart';
import 'package:soori_warehouse/ui/in/po_in_list.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:expandable/expandable.dart';
import 'package:soori_warehouse/ui/in/po_in_details.dart';

class OpenScanner extends StatefulWidget {
  List<PurchaseOrderDetail> _purchaseOrderDetails = [];
  int index;

  OpenScanner(this._purchaseOrderDetails, this.index);

  @override
  _OpenScannerState createState() => _OpenScannerState();
}

class _OpenScannerState extends State<OpenScanner> {
  String _data = "waiting...";
  String _labelType = "waiting...";
  String _source = "waiting...";
  int totalUnitBoxes = 0;
  int totalUnitsInBoxes = 0;
  int count = 0;

  */
/*Saving Bill Data in arrayList*//*

  List<String> _refPurchaseOrderDetail = [];
  List<String> _qty = [];
  List<String> _item = [];
  List<String> _packingType = [];
  List<String> _packingTypeDetail = [];
  List<String> _serialNos = [];

  TextEditingController qtyController = TextEditingController();
  TextEditingController packingController = TextEditingController();
  TextEditingController packingQtyController = TextEditingController();

  bool acceptBarCode = true;
  List<String> dataArray = [];
  List<List<String>> tList = [];
  List<String> globalArray = [];

  final _scannerFormKey = GlobalKey<FormState>();

  bool startItemScan = false;

  @override
  void dispose() {
    qtyController.dispose();
    packingController.dispose();
    packingQtyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loadControllers();
    super.initState();
  }

// create a listener for data wedge package
  Future<void> initDataWedgeListener() async {
    FlutterZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
        setState(() {
          Map<String, dynamic> jsonResponse;
          try {
            jsonResponse = json.decode(response);
          } catch (e) {
            //TODO handling
          }
          if (jsonResponse != null) {
            _data = jsonResponse["decodedData"];
            _labelType = jsonResponse["decodedLabelType"];
            _source = jsonResponse["decodedSource"];

            dataArray.add(_data);

            var dataNew = dataArray.toList().toSet();
            dataArray.clear();
            dataArray.addAll(dataNew);

            */
/*Global Array*//*

            globalArray.add(_data);
            var dataGlobal = globalArray.toList().toSet();
            globalArray.clear();
            setState(() {
              globalArray.addAll(dataGlobal);
            });

            if (dataArray.length == totalUnitsInBoxes) {
              tList.add(dataArray);
              dataArray.clear();
            }
          } else {
            _source = "An error Occured";
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConst.updateSerialNumber,
          style: kTextStyleSmall,
        ),
        actions: [
          TextButton(
            onPressed: () {
              saveUserData();
              displayToast(msg: 'Save this Data');
              // do something
            },
            child: InkWell(
              onTap: () {},
              child: Container(
                child: Text(
                  'SAVE',
                  style: kTextStyleSmall,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: kMarginPaddMedium,
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item Name',
                  style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget._purchaseOrderDetails[widget.index].itemName,
                  style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            kHeightBig,
            Form(
              key: _scannerFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: qtyController,
                    onChanged: (value) {
                      setState(() {
                        totalUnitBoxes = double.parse(value).toInt();
                        calculatedBoxes();
                      });
                    },
                    decoration: kopenScannerDecoration.copyWith(
                        labelText: 'Received Qty', hintText: '100'),
                    */
/*                   decoration: kFormFieldDecoration.copyWith(
                        labelText: 'Received Quantity', hintText: '100'),*//*

                  ),
                  kHeightMedium,
                  TextFormField(
                    controller: packingController,
                    onChanged: (value) {
                      setState(() {
                        TextSelection previousSelection =
                            packingController.selection;
                        packingController.text = value;
                        packingController.selection = previousSelection;
                        // packingController.text = value;
                      });
                    },
                    decoration: kopenScannerDecoration.copyWith(
                        labelText: 'Packing Type', hintText: 'Container'),
                  ),
                  kHeightMedium,
                  TextFormField(
                    controller: packingQtyController,
                    onChanged: (value) {
                      setState(() {
                        TextSelection previousSelection =
                            packingQtyController.selection;
                        packingQtyController.text = value;
                        packingQtyController.selection = previousSelection;
                        calculatedBoxes();
                      });
                    },
                    decoration: kopenScannerDecoration.copyWith(
                        labelText: 'Packing Type Quantity ', hintText: ''),
                  ),
                ],
              ),
            ),
            kHeightMedium,
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: kMarginPaddMedium,
                    child: Text(
                      'Bar Codes ?',
                      overflow: TextOverflow.ellipsis,
                      style: kTextStyleSmall.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  checkBarCodes(),
                ],
              ),
            ),
            kHeightMedium,
            _haveBarCodes(),
          ],
        ),
      ),
    );
  }

  checkBarCodes() {
    return LiteRollingSwitch(
      value: true,
      textOn: 'Yes',
      textOff: 'No',
      colorOn: Colors.greenAccent[700],
      colorOff: Colors.redAccent[700],
      iconOn: Icons.done,
      iconOff: Icons.remove_circle_outline,
      textSize: 16.0,
      onChanged: (bool state) {
        //Use it to manage the different states
        acceptBarCode = state;
        */
/*  setState(() {
          acceptBarCode = state;
        });*//*


        if (acceptBarCode == true) {
          initDataWedgeListener();
        }
        // setState(() {});
      },
    );
  }

  _haveBarCodes() {
    return acceptBarCode
        ? _showQRScans()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Save Your Data',
              style: kTextStyleBlack,
            ),
          );
  }

  _showQRScans() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: totalUnitBoxes,
        // itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          // return eachUnitList(index);

          return Text(
              '${globalArray.isNotEmpty ? globalArray.length > index ? globalArray[index] : '' : ''}');
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  eachUnitList(indexPrevious) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: _listExpandedPanel(indexPrevious),
    );
  }

  _listExpandedPanel(indexPrevious) {
    return ExpandablePanel(
      header: Container(
        margin: kMarginPaddSmall,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ' ${packingController.text}: ${indexPrevious + 1}',
              style: kTextStyleBlack,
            ),
          ],
        ),
      ),
      expanded: Card(
        elevation: kCardElevation,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: totalUnitsInBoxes,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Text(
                      displaySerialNo(index, indexPrevious),
                      style: kTextStyleSmall.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  */
/*
  *  tList.length > indexPrevious
                        ? Text(
                            'Serial :  ${tList[indexPrevious][index] ?? dataArray[indexPrevious]}',
                            style:
                                kTextStyleSmall.copyWith(color: Colors.black),
                          )
  * *//*


  */
/*
  *                    tList.length >= indexPrevious
                        ? dataArray.length > index
                            ? Text('Serial No : ${dataArray[index] ?? 0}',
                                  style: kTextStyleSmall.copyWith(
                                  color: Colors.black54,
                                ),
                              )
                            : Text('')
                        : Text('')
  *
  * *//*

  _scanContainer(indexPrevious) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ' ${packingController.text}: ${indexPrevious + 1}',
                style: kTextStyleBlack,
              ),
              InkWell(
                onTap: () {
                  displayToast(msg: 'Activate Scan: ');
                  setState(() {
                    startItemScan = true;
                  });
                  // _listExpandedPanel(indexPrevious);
                },
                child: Card(
                  elevation: kCardElevation,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Container(
                    padding: kMarginPaddSmall,
                    child: Text(
                      'Scan',
                      style: kTextStyleBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
          startItemScan ? _listExpandedPanel(indexPrevious) : Container()
        ],
      ),
    );
  }

  void loadControllers() {
    String receivedQty =
        widget._purchaseOrderDetails[widget.index].qty.toString();
    qtyController.text = receivedQty;

    String packingTypeQty = widget._purchaseOrderDetails[widget.index]
        .packingTypeDetailsItemwise[0].packQty
        .toString();

    packingController.text = widget._purchaseOrderDetails[widget.index]
        .packingTypeDetailsItemwise[0].packingTypeName;

    packingQtyController.text = packingTypeQty;

    var totalUnits =
        double.parse(receivedQty) / double.parse(packingQtyController.text);

    totalUnitBoxes = totalUnits.toInt();
    totalUnitsInBoxes = double.parse(packingTypeQty).toInt();
  }

  saveUserData() async {
    String receivedQty = qtyController.text;
    String packingUnit = packingController.text;
    String packingQty = packingQtyController.text;
    String refPurchaseOrderDetail =
        widget._purchaseOrderDetails[widget.index].refPurchaseOrderDetail;
    String item = widget._purchaseOrderDetails[widget.index].item.toString();
    String packingType =
        widget._purchaseOrderDetails[widget.index].packingType.toString();
    String packingTypeDetail =
        widget._purchaseOrderDetails[widget.index].packingTypeDetail.toString();

    for (int i = 0; i < totalUnitBoxes; i++) {
      List<String> printSerialNo = tList.isNotEmpty ? tList[i] : [];
      print('Print Serial No : ${printSerialNo.toString()}');
    }

    String serialNos = tList.toString();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // ===
    _qty = prefs.getStringList(StringConst.pQty) ?? [];
    _item = prefs.getStringList(StringConst.pItem) ?? [];
    _packingType = prefs.getStringList(StringConst.pPackingType) ?? [];
    _packingTypeDetail =
        prefs.getStringList(StringConst.pPackingTypeDetail) ?? [];
    _refPurchaseOrderDetail =
        prefs.getStringList(StringConst.pRefPurchaseOrderDetail) ?? [];
    _serialNos = prefs.getStringList(StringConst.pSerialNo) ?? [];

    _qty.add(receivedQty);
    _item.add(item);
    _packingType.add(packingType);
    _packingTypeDetail.add(packingTypeDetail);
    _refPurchaseOrderDetail.add(refPurchaseOrderDetail);
    _serialNos.add(serialNos);

    // Saving to Shared Prefs
    prefs.setStringList(StringConst.pQty, _qty);
    prefs.setStringList(StringConst.pItem, _item);
    prefs.setStringList(StringConst.pPackingType, _packingType);
    prefs.setStringList(StringConst.pPackingTypeDetail, _packingTypeDetail);
    prefs.setStringList(
        StringConst.pRefPurchaseOrderDetail, _refPurchaseOrderDetail);
    prefs.setStringList(StringConst.pSerialNo, _serialNos);

    print(
      ' Data for ${widget.index} :  '
      'Received Qty : ${_qty.toString()},'
      'Packing Unit:  ${_item.toString()},'
      'Packing Qty:  ${_packingType.toString()},'
      'Packing Type Detail:  ${_packingTypeDetail.toList().toString()},'
      'Ref Purchase Order:  ${_refPurchaseOrderDetail.toString()},'
      'Serial No :  ${_serialNos.toString()},',
    );
    Navigator.pop(context);
  }

  calculatedBoxes() {
    var totalUnits = double.parse(qtyController.text) /
        double.parse(packingQtyController.text);
    totalUnitBoxes = totalUnits.toInt();
    totalUnitsInBoxes = double.parse(packingQtyController.text).toInt();

    print(
        'Total Unit Boxes: $totalUnitBoxes, Unit in Boxes: $totalUnitsInBoxes');
    count = 0;
  }

  String displaySerialNo(index, indexPrevious) {
    String result = '';
    count = 0;
    int totalItems = totalUnitBoxes * totalUnitsInBoxes;
    print('Total Items : $totalItems');
    print('Total Items : ${globalArray.toString()}');

    List newresult = [];
    for (int i = 0; i < totalItems; i++) {
      print(globalArray.toString());

      for (int j = 0; j < totalUnitBoxes; j++) {
        newresult.add(' Serial No : $i');
        print("Count Current Value : $count");
      }

      // result = globalArray[i].isNotEmpty ? globalArray[i] : '';

      */
/*
      if (globalArray.length > i) {
      }*//*


      for (var _result in newresult) {
        String finalAns = globalArray.length > indexPrevious ? _result : '';
        return finalAns;
      }
    }
    */
/*
    for (int i = 0; i <= indexPrevious; i++) {
      result = globalArray.length > index ? globalArray[count] : '';
      count++;
    }
*//*

    // return result;
  }
}
*/
