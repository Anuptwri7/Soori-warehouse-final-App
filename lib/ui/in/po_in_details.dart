import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/in/model/inModel.dart';
import 'package:soori_warehouse/ui/in/po_in_details.dart';
import 'package:soori_warehouse/ui/login/login_screen.dart';

class PurchaseOrdersDetails extends StatefulWidget {
  int id;
   PurchaseOrdersDetails({Key? key,required this.id}) : super(key: key);

  @override
  State<PurchaseOrdersDetails> createState() => _PurchaseOrdersDetailsState();
}

class _PurchaseOrdersDetailsState extends State<PurchaseOrdersDetails> {

  int page =0;
  int limit = 10;
  bool isFirstLoadRunning = false;
  List post = [];
  bool hasNextPage=true;
  bool isLoadMoreRunning = false;

  void firstLoad(){
    setState(() {
      isFirstLoadRunning = true;
    });
    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    setState(() {
      isLoadMoreRunning = true;
    });
    page+=10;
    setState(() {
      isLoadMoreRunning = false;
    });
  }

  late http.Response response;
  late ProgressDialog pd;
  late Future<List<Results>?> pickUpList;
  late ScrollController controller;
  @override
  void initState() {
    controller = ScrollController()..addListener(loadMore);
    firstLoad();
    pd = initProgressDialog(context);
    super.initState();
  }

  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pickup List detail"),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // controller: controller,
        child: Column(

          children: [

            ListView(
              // controller: controller,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                FutureBuilder(
                    future: purchaseOrderDetail(widget.id),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {

                            return Text('Error: ${snapshot.error}');
                          } else {
                            return _pickOrderCards(snapshot.data);
                            return Container();
                          }
                      }
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  _pickOrderCards( data) {
    return data != null
        ? ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: data['purchase_order_details'].length,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
                log(data['purchase_order_details'].length.toString());
          return GestureDetector(
            onTap: (){},
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
                      children: [
                        Container(
                          child: Text(
                            "Item:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 30,
                          width: 150,
                          decoration: BoxDecoration(
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
                          child: Center(
                              child: Text(
                                "${data['purchase_order_details'][index]['item_name'].toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
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
                          child: Center(
                              child: Text(
                                "${data['purchase_order_details'][index]['packing_type_details_itemwise'][index]['packing_type_name'].toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                    kHeightSmall,
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Grand Total:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
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
                          child: Center(
                              child: Text(
                                "${data['grand_total'].toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          child: Text(
                            "Qty:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
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
                          child: Center(
                              child: Text(
                                "${data['purchase_order_details'][index]['qty'].toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),

                    // kHeightMedium,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Container(
                    //       child: ElevatedButton(
                    //         onPressed: () {
                    //           // data['results'][index]['status']=="RECEIVED" ||
                    //           //     data['results'][index]['status']=="CANCELLED"
                    //           //     ? displayToast(msg: "Already Verified")
                    //           //     : displayToast(msg: "Already ");
                    //           // goToPage(context,
                    //           //     PurchaseOrdersDetails( data['results'][index]['id']));
                    //         },
                    //         child: Icon(Icons.check),
                    //         style: ButtonStyle(
                    //           shadowColor: MaterialStateProperty.all<Color>(
                    //               Colors.grey),
                    //           // backgroundColor:
                    //           // MaterialStateProperty.all<Color>(
                    //           //     data['results'][index]['status']=="RECEIVED" ||
                    //           //         data['results'][index]['status']=="CANCELLED"
                    //           //         ? Color.fromARGB(255, 68, 110, 201)
                    //           //         .withOpacity(0.3)
                    //           //         : Color.fromARGB(255, 68, 110, 201)),
                    //           shape: MaterialStateProperty.all<
                    //               RoundedRectangleBorder>(
                    //             RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(15),
                    //               side: BorderSide(color: Colors.grey),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 20,
                    //     ),
                    //     // Container(
                    //     //   width: 100,
                    //     //   child: data[index].isPicked == false
                    //     //       ? ElevatedButton(
                    //     //     onPressed: () => data[index].byBatch ==
                    //     //         false
                    //     //         ? goToPage(context,
                    //     //         PickUpOrderDetails(data[index].id))
                    //     //         : goToPage(
                    //     //         context,
                    //     //         PickUpOrderByBatchDetails(
                    //     //             data[index].id)),
                    //     //     child: Text(
                    //     //       "PickUp",
                    //     //       style: TextStyle(
                    //     //           fontSize: 12,
                    //     //           fontWeight: FontWeight.bold),
                    //     //     ),
                    //     //     style: ButtonStyle(
                    //     //         shadowColor:
                    //     //         MaterialStateProperty.all<Color>(
                    //     //             Colors.grey),
                    //     //         backgroundColor:
                    //     //         MaterialStateProperty.all<Color>(
                    //     //             Color(0xff3667d4)),
                    //     //         shape: MaterialStateProperty.all<
                    //     //             RoundedRectangleBorder>(
                    //     //             RoundedRectangleBorder(
                    //     //                 borderRadius:
                    //     //                 BorderRadius.circular(15),
                    //     //                 side: BorderSide(
                    //     //                     color: Colors.grey)))),
                    //     //   )
                    //     //       : ElevatedButton(
                    //     //     onPressed: () {
                    //     //       displayToast(msg: "Already Picked");
                    //     //     },
                    //     //     child: Text(
                    //     //       "Picked",
                    //     //       style: TextStyle(
                    //     //           fontSize: 12,
                    //     //           fontWeight: FontWeight.bold),
                    //     //     ),
                    //     //     style: ButtonStyle(
                    //     //       shadowColor:
                    //     //       MaterialStateProperty.all<Color>(
                    //     //           Colors.grey),
                    //     //       backgroundColor:
                    //     //       MaterialStateProperty.all<Color>(
                    //     //           Color.fromARGB(255, 68, 110, 201)
                    //     //               .withOpacity(0.3)),
                    //     //       shape: MaterialStateProperty.all<
                    //     //           RoundedRectangleBorder>(
                    //     //         RoundedRectangleBorder(
                    //     //           borderRadius:
                    //     //           BorderRadius.circular(15),
                    //     //           side: BorderSide(color: Colors.grey),
                    //     //         ),
                    //     //       ),
                    //     //     ),
                    //     //   ),
                    //     // )
                    //   ],
                    // ),
                  ],
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

  Future purchaseOrderDetail(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.pendingPurchaseSummary}pending-purchase-order-summary/$id'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // http.Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.pendingPurchaseSummary}pending-purchase-order-summary/$id')
    //     .getOrdersWithToken();
    print("Response Code Drop: ${response.statusCode}");
    log("${jsonDecode(response.body)['count']}");

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        printResponse(response);
        return jsonDecode(response.body);
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
    setState(() {
      isFirstLoadRunning = false;
    });
    return null;
  }
}
