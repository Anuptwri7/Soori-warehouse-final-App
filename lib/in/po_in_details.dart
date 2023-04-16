import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/model/get_pending_orders.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/in/po_in_list.dart';

import '../consts/buttons_const.dart';
import 'code_scanner.dart';
import 'po_in_list.dart';

class PurchaseOrdersDetails extends StatefulWidget {
  List<PurchaseOrderDetail> purchaseOrderDetails = [];
  int purchasedID;
  String orderNo;
  String Fname;

  PurchaseOrdersDetails(this.purchaseOrderDetails, this.purchasedID,this.orderNo,this.Fname);

  @override
  _PurchaseOrdersDetailsState createState() => _PurchaseOrdersDetailsState();
}

class _PurchaseOrdersDetailsState extends State<PurchaseOrdersDetails> {
  List<String> pItemID = [];
  List<String> pItemPackingType = [];
  List<String> pItemPackingDetails = [];
  List<String> pItemQty = [];
  List<String> pItemRefDetailID = [];
  late http.Response response;
  late ProgressDialog pd;

  @override
  void initState() {
    pd = initProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConst.purchaseOrdersDetail,
          style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () => savePurchaseOrders(),
            child: Center(
              child: Container(
                padding: kMarginPaddMedium,
                child: Text(
                  StringConst.saveButton,
                  style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:100.0),
            child: Row(
              children: [
                Icon(Icons.battery_charging_full_outlined),
                Text("${widget.orderNo}"),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left:60.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xffF3F6F9),
                  child:  Text('${widget.Fname.substring(0,1).toUpperCase() }'),
                ),
                SizedBox(width: 10,),
                Container(
                  width: 200,
                  child: Text(
                    "${widget.Fname}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // SizedBox(
                //   width: 10,
                // ),

              ],
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.purchaseOrderDetails.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                loadPurchaseDetails(widget.purchaseOrderDetails, index);

                return Card(
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
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xffF3F6F9),
                              child:  Text('${widget.purchaseOrderDetails[index].itemName.substring(0,1).toUpperCase() }'),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${widget.purchaseOrderDetails[index].itemName}",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                      SizedBox(width: 70,),
                                    Text(
                                      "${widget.purchaseOrderDetails[index].packingType.name}",
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),
                                    ),
                                  ],
                                ),
                                kHeightSmall,
                                Text(
                                  "Qty:${widget.purchaseOrderDetails[index].qty}",
                                  style: TextStyle(),
                                ),
                                kHeightSmall,
                                Text(
                                  "Category Name:${widget
                                      .purchaseOrderDetails[index].itemCategoryName}",
                                  style: TextStyle(),
                                ),

                              ],
                            ),
                          ],
                        ),
                        // poInRowDesign('Item Name :',
                        //     widget.purchaseOrderDetails[index].itemName),
                        // kHeightSmall,
                        // poInRowDesign(
                        //     'Category Name :',
                        //     widget
                        //         .purchaseOrderDetails[index].itemCategoryName),
                        // kHeightSmall,
                        // poInRowDesign(' Ordered Qty :',
                        //     widget.purchaseOrderDetails[index].qty),
                        // kHeightSmall,
                        // poInRowDesign('Received Qty :', ''),
                        // kHeightSmall,
                        // // poInRowDesign('Serial Numbers:', ''),
                        // kHeightSmall,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoundedButtonsCustomized(
                              color:  Color(0xff424143),
                              buttonText: "Start Scan",
                              onTap: () {
                                goToPage(
                                    context,
                                    CodeScanner(widget.purchaseOrderDetails,
                                        index));
                              }),
                        ),
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }

  Future savePurchaseOrders() async {
    pd.show(max: 100, msg: 'Updating Serial No...');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String finalUrl = prefs.getString(StringConst.subDomain).toString();

      // Getting Data from  Shared Prefs
      List<String>? purchaseQty = prefs.getStringList(StringConst.pQty);

      List<String>? purchaseBoxes =
          prefs.getStringList(StringConst.pTotalUnitBoxes);

      List<String>? pPackingType =
          prefs.getStringList(StringConst.pPackingType);
      List<String>? pPackingTypeDetail =
          prefs.getStringList(StringConst.pPackingTypeDetail);
      List<String>? purchaseSerialNo =
          prefs.getStringList(StringConst.pSerialNo) ?? [];

      /*Clear Preference*/
      clearPrefs(prefs);

      /*Load Serial Numbers*/
      if (purchaseBoxes != null) {
        List _currentSerialNo = [];
        List _allPackTypeCodes = [];
        List _pd = [];

        for (var item in purchaseSerialNo) {
          /*Converting String into List*/
          var itemSplit = json.decode(item);

          int itemNoCount = 0;

          /*Submitting the POrder with Codes*/
          if (itemSplit.length > 0) {
            for (List newItem in itemSplit) {
              for (var finalItem in newItem) {
                _currentSerialNo.add(
                  {'code': finalItem.toString()},
                );
              }
              _allPackTypeCodes.add({
                'pack_no': itemNoCount,
                'pack_type_detail_codes': _currentSerialNo.toList()
              });
              itemNoCount++;
              _currentSerialNo.clear();
            }
          }
          /*Submitting without scanned Codes*/
          else {
            for (int i = 0; i < purchaseBoxes.length; i++) {
              print(int.parse(purchaseBoxes[i]));
              for (int j = 0; j < int.parse(purchaseBoxes[i]); j++) {
                _allPackTypeCodes
                    .add({'pack_no': j, 'pack_type_detail_codes': []});
              }
            }
          }
        }

        for (int i = 0; i < widget.purchaseOrderDetails.length; i++) {
          _pd.add({
            'ref_purchase_order_detail': widget.purchaseOrderDetails[i].id,
            'item': widget.purchaseOrderDetails[i].item,
            'qty': double.parse(purchaseQty![i]).toInt(),
            'packing_type': double.parse(pPackingType![i]).toInt(),
            'packing_type_detail': double.parse(pPackingTypeDetail![i]).toInt(),
            'po_pack_type_codes': _allPackTypeCodes,
            'discountable':widget.purchaseOrderDetails[i].discountable,
            'taxable':widget.purchaseOrderDetails[i].taxable,
          });
        }
        final response = await http.post(
            Uri.parse('https://$finalUrl/api/v1/purchase-app/receive-purchase-order'),
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${prefs.get("access_token")}'
            },
            body: jsonEncode({
              'purchase_order_details': _pd,
              'ref_purchase_order': widget.purchasedID,

            }));
        // response = await NetworkHelper(
        //         'https://$finalUrl${StringConst.urlPurchaseApp}receive-purchase-order')
        //     .userPurchaseOrder(
        //         refPurchaseOrder: widget.purchasedID, purchaseDetails: _pd);
log(({
  'ref_purchase_order': widget.purchasedID,
  'purchase_order_details': _pd
}).toString());
log('https://$finalUrl/api/v1/purchase-app/receive-purchase-order');
log(response.body);
        pd.close();

        var jsonData = jsonDecode(response.body.toString());
        if (response.statusCode >= 200 && response.statusCode < 300) {
          /**/
          displayToast(msg: 'Data is successfully Added');
          Navigator.pop(context);
        } else {
          displayToast(msg: 'Error : ${jsonData['message']}');
        }
      } else {
        pd.close();
        displayToast(msg: 'No Item Saved, Please Save and Try Again');
      }
    } catch (e) {
      print("Current Error: ${e.toString()}");
      displayToast(msg: StringConst.serverErrorMsg);
      pd.close();
    }
  }

  _purchaseOrderIcons(IconData iconImage, Color iconColor) {
    return IconButton(
      iconSize: 48,
      color: iconColor,
      icon: Icon(iconImage),
      onPressed: () {},
    );
  }

  void loadPurchaseDetails(
      List<PurchaseOrderDetail> purchaseOrderDetails, int index) {
    pItemRefDetailID.add(purchaseOrderDetails[index].id.toString());
    pItemID.add(purchaseOrderDetails[index].item.toString());
    pItemPackingType.add(purchaseOrderDetails[index].packingType.id.toString());
    pItemPackingDetails
        .add(purchaseOrderDetails[index].packingTypeDetail.id.toString());
    pItemQty.add(purchaseOrderDetails[index].qty.toString());
  }

  clearPrefs(prefs) async {
    prefs.remove(StringConst.pQty);
    prefs.remove(StringConst.pPackingType);
    prefs.remove(StringConst.pPackingTypeDetail);
    prefs.remove(StringConst.pSerialNo);
    prefs.remove(StringConst.pTotalUnitBoxes);
    print('Prefs Cleared: ');
  }
}
