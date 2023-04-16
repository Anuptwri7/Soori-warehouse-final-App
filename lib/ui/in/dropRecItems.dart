
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
import 'package:soori_warehouse/ui/in/po_in_details.dart';
import 'package:soori_warehouse/ui/in/po_in_list.dart';
import 'package:soori_warehouse/ui/login/login_screen.dart';
import 'package:soori_warehouse/ui/pick/model/pickup_details.dart';
import 'package:soori_warehouse/ui/pick/ui/pickup_order_details.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';
String _scanLocationNo = '';
class ScanToDrop extends StatefulWidget {
  int detailId;
  int mainId;
  double qty;
  double receivingPackQty ;
  String grandTotal ;
  bool taxable;
  String netAmount;
  String purchaseCost;
  String taxRate;
  String taxAmount;
  bool discountable;
  String discountRate;
  String discountAmount;
  bool cancelled;
  int item;
  int packingType;
  int packingTypeDetail;
  String currency;
  int discountScheme;
  String endUserName;
  int appType;
  String shipmentTerms;
  String attendee;
  String orderNo;
  String subTotal;
  int supplier;
  int refPurchaseOrder;
  int deviceType;
  String currencyExchange;
  String termsOfPayment;

  ScanToDrop(this.detailId,this.mainId,this.qty,this.receivingPackQty,this.grandTotal,this.taxable,this.netAmount,this.purchaseCost,this.taxRate,this.taxAmount,this.discountable
      ,this.discountRate,this.discountAmount,this.cancelled,this.item,this.packingType,this.packingTypeDetail,this.currency,this.discountScheme,this.endUserName,this.appType,
  this.shipmentTerms, this.attendee,this.orderNo,this.subTotal,this.supplier,this.refPurchaseOrder,this.deviceType,this.currencyExchange,this.termsOfPayment);

  @override
  State<ScanToDrop> createState() => _ScanToDropState();
}

class _ScanToDropState extends State<ScanToDrop> {

  TextEditingController recQty = TextEditingController();
  Map dict={};
  List<String> _scanSerialNo = [];
  String _currentScannedCode = '';
  int scannedItem = 0;
  int totalReceivedQty = 0;
  String finalUrl = '';
  late int pkOrderID;
  List packCodesID =  [];
  List _packCodesList = [];
  List _packCodeScannedList = [];
  List locationCodesList = [];
  List<String> previousSerialCodes = [];
  List gotSerialCodes=[];
  List gotSerialCodeId=[];
  List scannedSerialCodes=[];
  late ProgressDialog pd;
  List finalCodesToBeSent = [];
  int recNetQty=1;
  int recInputQty=0;
  int recPackQty=0;
  int orderedQty=0;
  bool startScan= false;
  List<String> list = <String>['Box','Unit'];
  String dropdownValue = 'Select Packing Type';
  int totalCodeToScan =0;
  int itemCount=0;
  @override
  void initState() {
    super.initState();
    recPackQty = widget.receivingPackQty.toInt();
    log(widget.refPurchaseOrder.toString());
    orderedQty = widget.qty.toInt();
    _pickupInitDataWedgeListener();

  }
  double number=0;
  getIncreasedItemCount(){
     number = recNetQty/recInputQty;

        if (_packCodesList.length==widget.receivingPackQty){
          setState(() {
            itemCount=itemCount++;
          });

      }
  }
  @override
  Widget build(BuildContext context) {
    log("//////"+gotSerialCodes.toString());
    return Listener(
      onPointerDown: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('Scan Item Location'),
          backgroundColor: Color(0xff2c51a4),),
        body: ListView(
          padding: kMarginPaddSmall,
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
                  Column(
                    children: [
                      Text('Sub Total', style: kTextStyleBlack.copyWith(),),
                      Text('${widget.grandTotal}', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Column(
                    children: [
                      Text('O. Qty ', style: kTextStyleBlack.copyWith(),),
                      Text(' ${widget.qty}', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Pack Qty', style: kTextStyleBlack.copyWith(),),
                      Text(' ${widget.receivingPackQty}', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Rec Net Qty', style: kTextStyleBlack.copyWith(),),
                      Text('${recNetQty}', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
                    ],

                  ),

                ],
              ),
            ),
            kHeightMedium,
            Visibility(
              // visible: startScan==false?true:false,
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width/3.2,
                // margin: const EdgeInsets.only(top:10,right: 20,left: 20,bottom: 10),
                //margin: EdgeInsets.only(left:10,right:60),
                decoration: kSerialFormDecoration,
                padding: const EdgeInsets.only(left:70, right: 0),
                child: DropdownButton<String>(
                  // value: dropdownValue,
                  hint: Text(dropdownValue),

                  // icon: const Icon(Icons.arrow_downward,color: Color,),
                  elevation: 24,
                  isExpanded: true,
                  style:kTextStyleBlack,
                  iconSize: 24.0,
                  icon: dropdownIcon(),
                  underline: hideDropDownLine(),
                  onChanged: (String? value) {

                    setState(() {
                      dropdownValue = value!;
                      // value=="Pending"?status='1':value=="Completed"?status='4':'';
                      log(dropdownValue);
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            kHeightMedium,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                  validator: (value){

                  },
                    controller: recQty,
                    keyboardType: TextInputType.number,
                    // The validator receives the text that the user has entered.
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please the receiving quantity';
                    //   }
                    // },
                    style: TextStyle(color: Colors.grey),
                    onChanged: (value){
                      int recInputForConditionQty=0;
                      setState(() {
                        if(value.isEmpty){
                          value="0";
                        }
                         recInputForConditionQty = int.parse(value);
                         if(recInputForConditionQty<orderedQty||recInputForConditionQty==orderedQty){
                           setState(() {
                             recInputQty = int.parse(value);
                             recNetQty = recInputQty*recPackQty;
                           });
                         }else{
                            Fluttertoast.showToast(msg: "The Quantity Exceed , Please Select Allowed Quantity");
                         }
                      });

                    },
                    cursorColor: Color(0xff3667d4),

                    decoration: kFormFieldDecoration.copyWith(
                        hintText: "Receiving quantity",
                        prefixIcon: const Icon(
                          Icons.stop_circle,
                          color: Colors.grey,
                        ),
                        ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RoundedButtonTwo(
                    buttonText: 'Update',
                      onTap: (){
                        if(recInputQty==0){
                          Fluttertoast.showToast(msg: "Please enter the receiving quantity");

                        }else{
                          if(recNetQty<orderedQty||recNetQty==orderedQty){
                              if(dropdownValue=="Box"){
                                setState(() {
                                  totalCodeToScan = recNetQty;
                                  startScan =true;
                                  log(totalCodeToScan.toString());
                                });
                              }else{
                                setState(() {
                                  totalCodeToScan = recNetQty;
                                  startScan =true;
                                  log(totalCodeToScan.toString());
                                });
                              }

                          }
                          else if(recInputQty<(recNetQty/recPackQty)){
                            setState(() {
                              startScan =true;
                            });
                          }
                          else{
                            Fluttertoast.showToast(msg: "Received Quantity cannot be greater than ordered quantity");
                            setState(() {
                              startScan=false;
                            });
                          }
                        }


                      },
                    // updateReceivedQty(qtyController.text.toString()),
                    color: Color(0xff2c51a4),
                  ),
                )
              ],
            ),

            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Column(
            //     children: [
            //       _displayPackCode(),
            //       // _displayItemsSerialNo(),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text('Serial Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),),
            //     ],
            //   ),
            // ),
            // Visibility(
            //   visible: startScan==false?true:false,
            //   child: RoundedButtons(
            //       color: Colors.indigo,
            //       buttonText: "Validate",
            //       onTap: (){
            //         if(recInputQty==0){
            //           Fluttertoast.showToast(msg: "Please enter the receiving quantity");
            //
            //         }else{
            //           if(recNetQty<orderedQty||recNetQty==orderedQty){
            //
            //             setState(() {
            //               startScan =true;
            //             });
            //           }
            //           else if(recInputQty<(recNetQty/recPackQty)){
            //             setState(() {
            //               startScan =true;
            //             });
            //           }
            //           else{
            //             Fluttertoast.showToast(msg: "Received Quantity cannot be greater than ordered quantity");
            //             setState(() {
            //               startScan=false;
            //             });
            //           }
            //         }
            //
            //
            //       }
            //   ),
            // ),


            Visibility(
              visible: startScan,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Visibility(
                    //   visible: dropdownValue=="Box"?true:false,
                    //   child: Expanded(
                    //       flex: 2,
                    //       child: Text('Pack Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),)),
                    // ),
                    Visibility(
                      visible: dropdownValue=="Box"?true:false,
                      child: Expanded(
                          flex: 3,
                          child: Text('${itemCount}/${recInputQty}', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),)),
                    ),
                    // Expanded(
                    //   flex: 2,
                    //     child: Text('Serial Codes', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),)),
                    // Expanded(
                    //   flex: 3,
                    //     child: Text('${_packCodesList.length}/${totalCodeToScan}', style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),)),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: startScan,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    _displayScannedCode(),
                    // _displayItemsSerialNo(),
                  ],
                ),
              ),
            ),


            kHeightMedium,
            //
            Visibility(
              visible: startScan,
              child: Container(
                width: 120,
                padding:  const EdgeInsets.all(16.0),
                child: RoundedButtons(
                  buttonText: 'Save',
                  onTap: () =>{
                    _packCodesList.length==recNetQty?dropCurrentItem():Fluttertoast.showToast(msg: "Please Scan All the Serial Codes")
                  },
                  // _packCodesList.length==widget.qty?
                  // postPickupTransfer(),
                  // :Fluttertoast.showToast(msg: "Scan Remaining items"),
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),

    );

  }
  Future dropCurrentItem()  async {
    // pd.show(max: 100, msg: 'Updating Drop Item...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();
    List purchaseOrderDetail =[] ;
    List packTypeDetailCode=[];
    List finalPackTypeDetail=[];

    for(int i=0;i<_packCodesList.length;i++){
      packTypeDetailCode.add({


          "pack_type_detail_codes": [
           {
             "code": _packCodesList[i],
           }
          ],
          "pack_no": i+1,
          "location":null,
          // "ref_packing_type_code": 0

                    // "ref_packing_type_detail_code": 0
                  }
                  );
    }
    for(int i=0;i<1;i++){
      purchaseOrderDetail.add({
        "po_pack_type_codes": packTypeDetailCode,
        "pack_qty": widget.receivingPackQty,
        // "sale_cost": ,
        "gross_amount": widget.grandTotal,
        "net_amount": widget.netAmount,
        "ref_purchase_order_detail": widget.detailId,
        "device_type": widget.deviceType,
        "app_type": widget.appType,
        "purchase_cost": widget.purchaseCost,
        "qty": dropdownValue=="Box"?recInputQty:totalCodeToScan,
        "taxable": widget.taxable,
        "tax_rate": widget.taxRate,
        "tax_amount": widget.taxAmount,
        "discountable": widget.discountable,
        "discount_rate": widget.discountRate,
        "discount_amount": widget.discountAmount,
        "cancelled": widget.cancelled,
        "remarks": " ",
        "item": widget.item,
        "packing_type": widget.packingType,
        "packing_type_detail": widget.packingTypeDetail
      });
    }

List finalPackCode =[];

    // for(int i=0;i<widget.receivingPackQty;i++){
    //   finalPackCode.add(purchaseOrderDetail[i]);
    // }
    final response = await http.post(
        Uri.parse('https://$finalUrl${StringConst.receivePurchaseOrder}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        },
        body: (jsonEncode({
          "purchase_order_details": purchaseOrderDetail,
          "order_type": 3,
          "order_no": widget.orderNo,
          "sub_total": widget.subTotal,
          "grand_total": widget.grandTotal,
          "supplier": widget.supplier,
          "ref_purchase_order": widget.refPurchaseOrder,
          "device_type": widget.deviceType,
          "app_type": widget.appType,
          "total_discount": widget.discountAmount,
          "discount_rate": widget.discountRate,
          "total_discountable_amount": widget.grandTotal,
          "total_taxable_amount": widget.grandTotal,
          "total_non_taxable_amount": 0,
          "total_tax": widget.taxAmount,
          "currency_exchange_rate": widget.currencyExchange,
          "remarks": " ",
          "terms_of_payment": widget.termsOfPayment,
          "shipment_terms": widget.shipmentTerms,
          "attendee": widget.attendee,
          "end_user_name": widget.endUserName,
          // "discount_scheme": widget.discountScheme,
          "currency": widget.currency
        })));


    log({
      "purchase_order_details": purchaseOrderDetail,
      "order_type": 3,
      "order_no": widget.orderNo,
      "sub_total": widget.subTotal,
      "grand_total": widget.grandTotal,
      "supplier": widget.supplier,
      "ref_purchase_order": widget.refPurchaseOrder,
      "device_type": widget.deviceType,
      "app_type": widget.appType,
      "total_discount": widget.discountAmount,
      "discount_rate": widget.discountRate,
      "total_discountable_amount": widget.grandTotal,
      "total_taxable_amount": widget.grandTotal,
      "total_non_taxable_amount": 0,
      "total_tax": widget.taxAmount,
      "currency_exchange_rate": widget.currencyExchange,
      "remarks": " ",
      "terms_of_payment": widget.termsOfPayment,
      "shipment_terms": widget.shipmentTerms,
      "attendee": widget.attendee,
      "end_user_name": widget.endUserName,
      "discount_scheme": widget.discountScheme,
      "currency": widget.currency
    }.toString());


    log("dflkjdlk"+response.body);
    log(response.statusCode.toString());
    if (response.statusCode == 401) {replacePage(LoginScreen(), context);}
    else {
      if (response.statusCode == 200 || response.statusCode == 201) {

        displayToastSuccess(msg: 'Item Dropped Successfully');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PendingOrderInList()));

        if(scannedItem==totalReceivedQty){

        }
      } else {
        // displayToast(msg: StringConst.somethingWrongMsg);
      }
    }

  }

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
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanToDrop(data['results'][index]['purchase_detail'],data['results'][index]['code'],data['results'][index]['id'],widget.qty)));
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
                  child: TextFormField()
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
            DataTable(
            sortColumnIndex: 0,
            sortAscending: true,
            columnSpacing: 0,
            horizontalMargin: 0,

            // columnSpacing: 10,

            columns: [
              DataColumn(
                label: SizedBox(
                  // width:0,
                  child:  Text(
                    'Serial Codes ${_packCodesList.length}/${totalCodeToScan} ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            ],
            rows: List.generate(
                _packCodesList.length,
                    (index) => DataRow(
                  // selected: true,
                  cells: [
                    DataCell(
                      Container(
                        height:40,

                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            _packCodesList[index]
                                .toString(),
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight:
                                FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                  ],
                ))),

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
              int toScanLength = recNetQty;
              log(toScanLength.toString());

            _currentScannedCode = jsonResponse["decodedData"].toString().trim();
              if(_packCodesList.length<toScanLength){

                if (_packCodesList.contains(_currentScannedCode)){
                    Fluttertoast.showToast(msg: "Scan Unique Code");
                }
                else {
                  setState(() {
                    _packCodesList.add(_currentScannedCode);
                    getIncreasedItemCount();

                  });
                }
              }else{
                // Fluttertoast.showToast(msg: "The total Number of Serial is $toScanLength which is scanned");
              }


            // if(_packCodesList.contains(_currentScannedCode)){}
            // else{
            //   if(gotSerialCodes.contains(_currentScannedCode)){
            //     setState(() {
            //       _packCodesList.add(_currentScannedCode);
            //
            //     });
            //   }
            // }

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


  // Future postPickupTransfer() async {
  //   final SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //   finalUrl = sharedPreferences.getString(StringConst.subDomain).toString();
  //   var baseUrl= sharedPreferences.getString("subDomain");
  //   log(StringConst.baseUrl + StringConst.postPickupTransfer);
  //
  //   log(dict.toString());
  //
  //   var finalBody = [];
  //   for(int i =0;i<finalCodesToBeSent.length;i++){
  //     finalBody.add({
  //       "packing_type_detail_code": finalCodesToBeSent[i]
  //     });
  //   }
  //
  //
  //   final response = await http.post(
  //       Uri.parse('https://$finalUrl${StringConst.postPickupTransfer}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
  //       },
  //       body:(jsonEncode(
  //           {
  //             "transfer_detail":widget.detailId,
  //             "transfer_packing_types": [
  //               {
  //                 "packing_type_code": widget.packCodeId,
  //                 "sale_packing_type_detail_code": finalBody
  //               }
  //             ]
  //           }
  //       )));
  //
  //   if (response.statusCode == 201) {
  //
  //     dict.clear();
  //     Navigator.pop(context);
  //
  //   }else{
  //
  //   }
  //
  //   if (kDebugMode) {
  //     log('hello${response.statusCode}');
  //   }
  //   return response;
  // }


}

