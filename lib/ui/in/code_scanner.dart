import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soori_warehouse/consts/buttons_const.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/model/get_pending_orders.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';


class CodeScanner extends StatefulWidget {
  List<PurchaseOrderDetail> _purchaseOrderDetails = [];
  int index;

  CodeScanner(this._purchaseOrderDetails, this.index);

  @override
  _CodeScannerState createState() => _CodeScannerState();
}

class _CodeScannerState extends State<CodeScanner> {
  String _serialNo = "waiting...";
  String _source = "waiting...";
  final _scannerFormKey = GlobalKey<FormState>();
  late TextEditingController qtyController;

  int totalUnitBoxes = 0;
  int totalUnitsInBoxes = 0;
  int count = 0, packageCount = 0;
  int totalQuantity = 0;

  String _packingUnitType = '';
  String orderQty = '';
  var packingType = StringConst.packingType;

  List<String> packingTypeValue = [];
  List<String> packingTypeValueUnits = [];
  List<String> dataArray = [];

  List<List<String>> serialNoList = [];

  /*Sharedprefs List*/
  List<String> _qty = [];
  List<String> _totalUnitBoxes = [];
  List<String> _serialNos = [];
  List<String> _packingType = [];
  List<String> _packingTypeDetail = [];

  @override
  void dispose() {
    qtyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initDataWedgeListener();

    loadControllers(widget._purchaseOrderDetails[widget.index]);
    loadPackingTypeDetails(widget._purchaseOrderDetails[widget.index]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConst.updateSerialNumber,
          style: kTextStyleSmall,

        ),
        backgroundColor: Color(0xff2c51a4),
        actions: [
          InkWell(
            onTap: () async {
              print('Total Quantity : $totalQuantity');

              if (packingType == StringConst.packingType) {
                displayToast(msg: 'Please Select a Packing Type');
              } else if (totalQuantity == 0 || totalQuantity < 0) {
                displayToast(msg: 'Please Specify Your Total Quantity');
              } else {
                saveUserData(widget._purchaseOrderDetails[widget.index]);
              }
            },
            child: Center(
              child: Container(
                padding: kMarginPaddMedium,
                child: Text(
                  StringConst.saveButton,
                  style: kTextStyleSmall,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: kMarginPaddSmall,
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: Text("Item Name:",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(width:60,),
                    Container(
                      height: 30,
                      width: 200,
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

                      child: Center(child: Text("${widget._purchaseOrderDetails[widget.index].itemName}",
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                  ],
                ),
                // Text(
                //   'Item Name',
                //   style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(width: 8,),
                // Flexible(
                //   child: Text(
                //     widget._purchaseOrderDetails[widget.index].itemName,
                //     overflow: TextOverflow.clip,
                //     style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                //   ),
                // ),
              ],
            ),
            kHeightBig,
            _serialNoForm(),
            kHeightMedium,
            Card(
              color: Color(0xffeff3ff),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
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
                            'Serial No',
                            style: kTextStyleSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Expanded(

                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Count',
                                style: kTextStyleSmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                'Pack.',
                                style: kTextStyleSmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kHeightSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            _serialNo,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$count / ${totalUnitsInBoxes}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '$packageCount / ${totalUnitBoxes}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kHeightSmall,
                  ],
                ),
              ),
            ),
            kHeightMedium,
            _displayBox()
          ],
        ),
      ),
    );
  }

  void loadControllers(PurchaseOrderDetail purchaseOrderDetail) {
    qtyController = TextEditingController();

    orderQty = purchaseOrderDetail.qty.toString();
    qtyController.text = orderQty;
    totalQuantity = double.parse(orderQty).toInt();
  }

  _dropdownItems(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: kTextStyleBlack.copyWith(fontSize: 16.0),
      ),
    );
  }

  _serialNoForm() {
    return Form(
      key: _scannerFormKey,
      child: Column(
        children: [
          Container(
            padding: kMarginPaddSmall,
            decoration: kSerialFormDecoration,
            child: DropdownButton<String>(
              hint: Text(packingType, style: kHintTextStyle),
              value: packingType,
              elevation: 24,
              isExpanded: true,
              style: kTextStyleBlack,
              underline: hideDropDownLine(),
              onChanged: (newValue) {
                setState(() {
                  _calculatePackQuantity(newValue);
                });
              },
              items: packingTypeValue
                  .map<DropdownMenuItem<String>>((String value) {
                return _dropdownItems(value);
              }).toList(),
              iconSize: 24.0,
              icon: dropdownIcon(),
            ),
          ),
          kHeightMedium,
          Card(
            color: Color(0xffeff3ff),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            elevation: 4,
            child: Padding(
              padding: kMarginPaddMedium,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(

                      child: Text(
                        ' Pack Qty : $totalUnitsInBoxes',
                        style: kTextBlackSmall,
                      )),
                  Container(
                      child: Text(
                        'Order Qty : ${orderQty}',
                        style: kTextBlackSmall,
                      )),
                ],
              ),
            ),
          ),
          kHeightMedium,
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      TextSelection previousSelection = qtyController.selection;
                      qtyController.text = value;
                      qtyController.selection = previousSelection;
                    },
                    decoration: kopenScannerDecoration.copyWith(
                        labelText: 'Received Qty', hintText: '100'),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 2,
                  child: RoundedButtonTwo(
                    buttonText: 'Update',
                    onTap: () =>
                        updateReceivedQty(qtyController.text.toString()),
                    color: Color(0xff2c51a4),
                  ),
                )
              ],
            ),
          ),
          kHeightMedium,
        ],
      ),
    );
  }

  /*Display Serial Numbers*/

  _displayBox() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: totalUnitBoxes,
        itemBuilder: (context, boxIndex) {
          return _displayBoxItems(boxIndex);
        });
  }

  _displayBoxItems(boxIndex) {
    return ExpandablePanel(
      header: Container(
        margin: kMarginPaddSmall,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_packingUnitType ${boxIndex + 1}',
              style: kTextStyleBlack,
            ),
          ],
        ),
      ),
      expanded: Card(
        elevation: kCardElevation,
        child: Container(
          padding: kMarginPaddSmall,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalUnitsInBoxes,
              itemBuilder: (context, boxItemIndex) {
                return Padding(
                  padding: kMarginPaddSmall,
                  child: _displaySerialNo(boxItemIndex, boxIndex),

                );
              }),
        ),
      ),
      collapsed: const Divider(),
    );
  }

  _displaySerialNo(boxItemIndex, boxIndex) {
    if (serialNoList.isNotEmpty && serialNoList.length == packageCount) {
      return Text(serialNoList[boxIndex].isNotEmpty
          ? serialNoList[boxIndex][boxItemIndex].isNotEmpty
          ? serialNoList[boxIndex][boxItemIndex]
          : ''
          : '');
    } else {
      return Text('');
    }
  }

  // create a listener for data wedge package
  Future<void> _initDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {
        Map<String, dynamic>? jsonResponse;
        try {
          jsonResponse = json.decode(response);

          if (jsonResponse != null) {

            if (packageCount != totalUnitBoxes) {

              _serialNo = jsonResponse["decodedData"].toString().trim();
              dataArray.add(_serialNo);
              var dataNew = dataArray.toList().toSet();
              dataArray.clear();
              dataArray.addAll(dataNew);

              count = dataArray.length;

              if (dataArray.length == totalUnitsInBoxes) {
                setState(() {
                  serialNoList.add(dataArray.toList());
                  packageCount++;
                  dataArray.clear();
                  count = 0;

                  if (packageCount == totalUnitBoxes) {
                    _serialNo = 'Task Completed';
                  } else {
                    _serialNo = 'Package $packageCount Added';
                  }
                });
              }
            } else {
              _serialNo = 'Task Completed';
              displayToast(msg: 'Task Completed, Please Save your Task');
            }
          } else {
            _source = "An error Occured";
          }


        } catch (e) {
          // displayToast(msg: 'Something went wrong, Please Scan Again');
        }

        setState(() {   });

      }
    });
  }

  void loadPackingTypeDetails(PurchaseOrderDetail purchaseOrderDetail) {
    int packingOptions = purchaseOrderDetail.packingTypeDetailsItemwise.length;
    var _packingTypeDetails = purchaseOrderDetail.packingTypeDetailsItemwise;
    packingTypeValue.clear();
    packingTypeValueUnits.clear();
    packingTypeValue.add(StringConst.packingType);
    packingTypeValueUnits.add('0');

    for (int i = 0; i < packingOptions; i++) {
      packingTypeValue.add(_packingTypeDetails[i].packingTypeName);
      packingTypeValueUnits.add((_packingTypeDetails[i].packQty.toString()));
    }
  }

  void _calculatePackQuantity(String? newValue) {
    packingType = newValue!;
    if (packingType == StringConst.packingType) {
      totalUnitsInBoxes = 0;
      totalUnitBoxes = 0;
      displayToast(msg: 'Please Select a Packing Type');
    } else {
      for (int i = 0; i < packingTypeValueUnits.length; i++) {
        if (packingTypeValue[i].toString() == packingType.toString()) {
          totalUnitsInBoxes = double.parse(packingTypeValueUnits[i]).toInt();
          setState(() {
            _packingUnitType = packingTypeValue[i].toString();
          });
          double _boxes = totalQuantity / totalUnitsInBoxes;
          totalUnitBoxes = (_boxes).toInt();
        }
      }
    }
  }

  void saveUserData(PurchaseOrderDetail purchaseOrderDetail) async {
    String packingType = purchaseOrderDetail.packingType.id.toString();
    String packingTypeDetail =
    purchaseOrderDetail.packingTypeDetail.id.toString();
    String serialNos = json.encode(serialNoList);
    String totalBoxes = totalUnitBoxes.toString();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _qty = prefs.getStringList(StringConst.pQty) ?? [];
    _totalUnitBoxes = prefs.getStringList(StringConst.pTotalUnitBoxes) ?? [];
    _packingType = prefs.getStringList(StringConst.pPackingType) ?? [];

    _serialNos = prefs.getStringList(StringConst.pSerialNo) ?? [];

    print("Getting Serial No: ${_serialNos.toString()}");

    _packingTypeDetail =
        prefs.getStringList(StringConst.pPackingTypeDetail) ?? [];

    /*Adding New Data in List*/
    _qty.add(totalQuantity.toString());
    _totalUnitBoxes.add(totalBoxes);
    _packingType.add(packingType);
    _packingTypeDetail.add(packingTypeDetail);

    print("Saving Serial No : ${_serialNos.toString()}");

    _serialNos.add(serialNos);

    // Saving to Shared Prefs
    prefs.setStringList(StringConst.pQty, _qty);
    prefs.setStringList(StringConst.pPackingType, _packingType);
    prefs.setStringList(StringConst.pPackingTypeDetail, _packingTypeDetail);
    prefs.setStringList(StringConst.pSerialNo, _serialNos);
    prefs.setStringList(StringConst.pTotalUnitBoxes, _totalUnitBoxes);

    displayToast(msg: 'Your Data is Saved');
    Navigator.pop(context);
  }

  displaySave() {
    displayToast(msg: 'Save Your Serial No');
  }

  void updateReceivedQty(String quantityUpdated) {
    if (totalUnitsInBoxes.toInt() != 0) {
      try {
        int _quantityUpdated = double.parse(quantityUpdated).toInt();

        if (_quantityUpdated % totalUnitsInBoxes != 0) {
          displayToast(
              msg: 'Please Enter in the multiple of $totalUnitsInBoxes');
        } else {
          setState(() {
            totalQuantity = _quantityUpdated;
            totalUnitsInBoxes = totalUnitsInBoxes;
            totalUnitBoxes = totalQuantity ~/ totalUnitsInBoxes;
            _packingUnitType = packingType;
          });
          displayToast(msg: 'Quantity Updated');
        }
      } catch (e) {
        print(e.toString());
        displayToast(msg: 'Something went wrong, Please Check your Input');
      }
    } else {
      displayToast(msg: 'Please Select a valid Packing Type');
    }
  }
}
