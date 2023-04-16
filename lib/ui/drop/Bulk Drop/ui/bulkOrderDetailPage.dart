import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/buttons_const.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/drop/model/drop_details_model.dart';
import 'package:soori_warehouse/ui/drop/ui/drop_order_scan_location.dart';
import 'package:soori_warehouse/ui/in/po_in_list.dart';
import 'package:http/http.dart' as http;
import 'package:soori_warehouse/ui/login/login_screen.dart';

import 'bulkDropScanPage.dart';


class BulkDropOrderDetails extends StatefulWidget {

  final orderID;
  String orderNo;
  String Fname;

  BulkDropOrderDetails(this.orderID,this.orderNo,this.Fname);

  @override
  State<BulkDropOrderDetails> createState() => _BulkDropOrderDetailsState();
}

class _BulkDropOrderDetailsState extends State<BulkDropOrderDetails> {

  late http.Response response;
  late ProgressDialog pd;
  late Future<List<Result>?> dropOrderDetails;
  List packCodes = [];
  List locationCodesList = [];
  List locationCheck = [];

  @override
  void initState() {
    dropOrderDetails = dropOrdersDetails(widget.orderID);

    locationCodes();

    pd = initProgressDialog(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.bulkdropOrdersDetail,
          style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),

      body:  Card(
        margin: kMarginPaddSmall,
        color:
        Colors.white,

        elevation: kCardElevation,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: kMarginPaddSmall,
          child: Column(
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
              FutureBuilder<List<Result>?>(
                  future: dropOrderDetails,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return dropItemDetails(snapshot.data);
                        }
                    }
                  }),
            ],
          ),
        ),
      )




    );
  }


  Future<List<Result>?> dropOrdersDetails(int receivedOrderID)  async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    prefs.setString(StringConst.dropOrderID, widget.orderID.toString());
    String finalUrl = prefs.getString("subDomain").toString();

    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlPurchaseApp}location-purchase-order-details?limit=0&purchase_order=$receivedOrderID'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}location-purchase-order-details?limit=0&purchase_order=$receivedOrderID')
    //     .getOrdersWithToken();

        log(response.body);
        // log(dropOrderDetailsModelFromJson(response.body.toString()).results.toString());
    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return dropOrderDetailsModelFromJson(response.body.toString()).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }


  Future locationCodes()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl/api/v1/warehouse-location-app/location-map?limit=0'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //     '${finalUrl}/api/v1/warehouse-location-app/location-map?limit=0').getOrdersWithToken();

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonData = jsonDecode(response.body.toString());
        for(var result  in  jsonData["results"]){
          locationCodesList.add(result["code"]);
        }
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }


/* Display Data*/
  dropItemDetails(List<Result>? data) {
    return data !=null
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {

          /*Save PackType codes*/
          savePackCodeList(data[index].poPackTypeCodes);

          return GestureDetector(
            onTap: (){
              data[index].poPackTypeCodes[index].location==null
                  ?
              goToPage(context,
                BulkDOScanLocation(
                  data[index].poPackTypeCodes,
                  widget.orderNo,
                  widget.Fname,
                  locationCodesList,
                ),
              )
              :  displayToastSuccess(msg : 'Item Already Dropped');
              ;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shadowColor: Colors.white,
                margin: kMarginPaddSmall,
                // color: data[index].picked == false
                //     ? Colors.white
                //     : Colors.grey,
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
                            child:  Text('${data[index].itemName.substring(0,1).toUpperCase() }'),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            children: [
                              Text(
                                "${data[index].itemName}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              kHeightSmall,
                              Text(
                                "Qty:${data[index].poPackTypeCodes.length.toString()}",
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          SizedBox(width: 80,),
                          Image.asset(data[index].poPackTypeCodes[index].location==null?"assets/images/notPicked.png":"assets/images/picked.png")
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );



          //   Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     margin: kMarginPaddSmall,
          //     color: Colors.white,
          //     elevation: kCardElevation,
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12.0)),
          //     child: Container(
          //       padding: kMarginPaddSmall,
          //       child: Column(
          //         children: [
          //           Row(
          //             children: [
          //               Container(
          //                 child: Text("Item Name:",style: TextStyle(fontWeight: FontWeight.bold),),
          //               ),
          //
          //               Container(
          //                 height: 30,
          //                 width: 200,
          //                 decoration:  BoxDecoration(
          //                   color: const Color(0xffeff3ff),
          //                   borderRadius: BorderRadius.circular(10),
          //                   boxShadow: const [
          //                     BoxShadow(
          //                       color: Color(0xffeff3ff),
          //                       offset: Offset(-2, -2),
          //                       spreadRadius: 1,
          //                       blurRadius: 10,
          //                     ),
          //                   ],
          //                 ),
          //                 child: Center(child: Text("${data[index].itemName}",style: TextStyle(fontWeight: FontWeight.bold),)),
          //               ),
          //             ],
          //           ),
          //           // poInRowDesign('Item Name :',data[index].itemName),
          //           kHeightSmall,
          //           Row(
          //             children: [
          //               Container(
          //                 child: Text("Packing Type:",style: TextStyle(fontWeight: FontWeight.bold),),
          //               ),
          //               Container(
          //                 height: 30,
          //                 width: 150,
          //                 decoration:  BoxDecoration(
          //                   color: const Color(0xffeff3ff),
          //                   borderRadius: BorderRadius.circular(10),
          //                   boxShadow: const [
          //                     BoxShadow(
          //                       color: Color(0xffeff3ff),
          //                       offset: Offset(-2, -2),
          //                       spreadRadius: 1,
          //                       blurRadius: 10,
          //                     ),
          //                   ],
          //                 ),
          //                 child: Center(child: Text("${data[index].packingType}",style: TextStyle(fontWeight: FontWeight.bold),)),
          //               ),
          //             ],
          //           ),
          //           // poInRowDesign(
          //           //     'Packing Type:' ,data[index].packingType),
          //           kHeightSmall,
          //           Row(
          //             children: [
          //               Container(
          //                 child: Text("Received Qty:",style: TextStyle(fontWeight: FontWeight.bold),),
          //               ),
          //               Container(
          //                 height: 30,
          //                 width: 120,
          //                 decoration:  BoxDecoration(
          //                   color: const Color(0xffeff3ff),
          //                   borderRadius: BorderRadius.circular(10),
          //                   boxShadow: const [
          //                     BoxShadow(
          //                       color: Color(0xffeff3ff),
          //                       offset: Offset(-2, -2),
          //                       spreadRadius: 1,
          //                       blurRadius: 10,
          //                     ),
          //                   ],
          //                 ),
          //                 child: Center(child: Text("${data[index].poPackTypeCodes.length.toString()}",style: TextStyle(fontWeight: FontWeight.bold),)),
          //               ),
          //             ],
          //           ),
          //           // poInRowDesign('Received Qty :', data[index].poPackTypeCodes.length.toString()),
          //           kHeightMedium,
          //           locationCheck.contains(null)
          //           //  data[index].poPackTypeCodes[index].location==""
          //                ? RoundedButtons(
          //             buttonText: 'Drop',
          //             onTap: () => goToPage(context,
          //               BulkDOScanLocation(
          //                 data[index].poPackTypeCodes,
          //                 locationCodesList,
          //               ),
          //             ),
          //             color: Color(0xff2c51a4),
          //           )
          //               :RoundedButtons(
          //             buttonText: 'Dropped',
          //             onTap: () {
          //               return displayToastSuccess(msg : 'Item Alredy Dropped');
          //             },
          //             color: Color(0xff6b88e8),
          //           )
          //
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        })
        : const Text('We have no Data for now');
  }

  void savePackCodeList(List<PoPackTypeCode> poPackTypeCodes) {

    for(int i = 0; i < poPackTypeCodes.length; i++){
      locationCheck.add(poPackTypeCodes[i].location);
      log(locationCheck.toString());
    }

  }





}
