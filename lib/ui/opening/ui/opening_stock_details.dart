
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/ui/opening/model/opening_stock_details_model.dart';
import 'package:soori_warehouse/ui/opening/ui/opening_stock_scan.dart';

import '../../../consts/buttons_const.dart';
import '../../../consts/methods_const.dart';
import '../../../consts/string_const.dart';
import '../../../consts/style_const.dart';
import '../../../data/network/network_helper.dart';
import '../../in/po_in_list.dart';
import '../../login/login_screen.dart';
import 'package:http/http.dart' as http;
class OpeningStockDetails extends StatefulWidget {

  final orderID;
  String orderNo;
  OpeningStockDetails(this.orderID, this.orderNo,{Key? key}) : super(key: key);

  @override
  State<OpeningStockDetails> createState() => _OpeningStockDetailsState();
}

class _OpeningStockDetailsState extends State<OpeningStockDetails> {


  late Response response;
  late ProgressDialog pd;

  late Future<List<Result>?> openStockDetails;
  List locationCodesList = [];
  List locationCheck = [];

  @override
  void initState() {
    openStockDetails = listOpeningStockDetails(widget.orderID);

    locationCodes();

    pd = initProgressDialog(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.openingStockDetail,
          style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:ListView(
        shrinkWrap: true,
        children:[
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

          FutureBuilder<List<Result>?>(
              future: openStockDetails,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return openingStockItemDetails(snapshot.data);
                    }
                }
              }),
        ]

      )


    );
  }


  Future<List<Result>?> listOpeningStockDetails(int receivedOrderID)  async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    prefs.setString(StringConst.openingStockOrderID, widget.orderID.toString());
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlOpeningStockApp}location-purchase-details?purchase=$receivedOrderID'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlOpeningStockApp}location-purchase-details?purchase=$receivedOrderID').getOrdersWithToken();

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return openStockDetailsModelFromJson(response.body.toString()).results;
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
        print("Location Codes : ${locationCodesList.toString()}");
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }


/* Display Data*/
  openingStockItemDetails(List<Result>? data) {
    return data !=null
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {

          /*Save PackType codes*/
          savePackCodeList(data[index].puPackTypeCodes);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/2,
                                          child: Text(
                                            "${data[index].itemName}",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          "${data[index].packingType}",
                                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    kHeightSmall,
                                    Text(
                                      "Qty:${data[index].puPackTypeCodes.length.toString()}",
                                      style: TextStyle(),
                                    ),
                                    kHeightSmall,


                                  ],
                                ),
                              ],
                            ),
                            // Container(
                            //   child: Text("Item Name:",style: TextStyle(fontWeight: FontWeight.bold),),
                            // ),
                            // SizedBox(width:40,),
                            // Container(
                            //   height: 30,
                            //   width: MediaQuery.of(context).size.width/2,
                            //   decoration:  BoxDecoration(
                            //     color: const Color(0xffeff3ff),
                            //     borderRadius: BorderRadius.circular(10),
                            //     boxShadow: const [
                            //       BoxShadow(
                            //         color: Color(0xffeff3ff),
                            //         offset: Offset(-2, -2),
                            //         spreadRadius: 1,
                            //         blurRadius: 10,
                            //       ),
                            //     ],
                            //   ),
                            //
                            //   child: Center(child: Text("${data[index].itemName}",
                            //     overflow: TextOverflow.clip,
                            //     style: TextStyle(fontWeight: FontWeight.bold),)),
                            // ),
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
                    // poInRowDesign('Item Name :',data[index].itemName),
                    // kHeightSmall,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Container(
                    //           child: Text("Packing Type:",style: TextStyle(fontWeight: FontWeight.bold),),
                    //         ),
                    //         SizedBox(width:30,),
                    //         Container(
                    //           height: 30,
                    //           width: MediaQuery.of(context).size.width/2,
                    //           decoration:  BoxDecoration(
                    //             color: const Color(0xffeff3ff),
                    //             borderRadius: BorderRadius.circular(10),
                    //             boxShadow: const [
                    //               BoxShadow(
                    //                 color: Color(0xffeff3ff),
                    //                 offset: Offset(-2, -2),
                    //                 spreadRadius: 1,
                    //                 blurRadius: 10,
                    //               ),
                    //             ],
                    //           ),
                    //
                    //           child: Center(child: Text("${data[index].packingType}",
                    //             overflow: TextOverflow.clip,
                    //             style: TextStyle(fontWeight: FontWeight.bold),)),
                    //         ),
                    //       ],
                    //     ),
                    //     // Text(
                    //     //   'Item Name',
                    //     //   style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                    //     // ),
                    //     // const SizedBox(width: 8,),
                    //     // Flexible(
                    //     //   child: Text(
                    //     //     widget._purchaseOrderDetails[widget.index].itemName,
                    //     //     overflow: TextOverflow.clip,
                    //     //     style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),
                    // poInRowDesign(
                        // 'Packing Type:' ,data[index].packingType),
                    // kHeightSmall,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Container(
                    //           child: Text("Received Qty:",style: TextStyle(fontWeight: FontWeight.bold),),
                    //         ),
                    //         SizedBox(width:30,),
                    //         Container(
                    //           height: 30,
                    //           width: MediaQuery.of(context).size.width/2,
                    //           decoration:  BoxDecoration(
                    //             color: const Color(0xffeff3ff),
                    //             borderRadius: BorderRadius.circular(10),
                    //             boxShadow: const [
                    //               BoxShadow(
                    //                 color: Color(0xffeff3ff),
                    //                 offset: Offset(-2, -2),
                    //                 spreadRadius: 1,
                    //                 blurRadius: 10,
                    //               ),
                    //             ],
                    //           ),
                    //
                    //           child: Center(child: Text("${data[index].puPackTypeCodes.length.toString()}",
                    //             overflow: TextOverflow.clip,
                    //             style: TextStyle(fontWeight: FontWeight.bold),)),
                    //         ),
                    //       ],
                    //     ),
                    //     // Text(
                    //     //   'Item Name',
                    //     //   style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                    //     // ),
                    //     // const SizedBox(width: 8,),
                    //     // Flexible(
                    //     //   child: Text(
                    //     //     widget._purchaseOrderDetails[widget.index].itemName,
                    //     //     overflow: TextOverflow.clip,
                    //     //     style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),
                    // poInRowDesign('Received Qty :', data[index].puPackTypeCodes.length.toString()),
                    kHeightMedium,
                    locationCheck.contains(null)
                        ? RoundedButtons(
                      buttonText: 'Drop',
                      onTap: () =>
                          goToPage(context,
                              OpeningStockScan(
                              data[index].puPackTypeCodes,
                              locationCodesList,
                              widget.orderNo
                              // packCodes
                              )
                      ),
                      color:Color(0xff424143),
                    ) :
                    RoundedButtons(
                      buttonText: 'Dropped',
                      onTap: () {
                        return displayToastSuccess(msg : 'Item Alredy Dropped');
                      },
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          );
        })
        : const Text('We have no Data for now');
  }





  void savePackCodeList(List<PuPackTypeCode> poPackTypeCodes) {

    for(int i = 0; i < poPackTypeCodes.length; i++){
      locationCheck.add(poPackTypeCodes[i].location);
    }

    print("Opening Details Location Check : $locationCheck");
  }




}
