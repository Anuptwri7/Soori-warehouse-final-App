import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/login/login_screen.dart';
import 'package:soori_warehouse/ui/transfer%20Order/pickupPage.dart';


class TransferSummaryPage extends StatefulWidget {

  int id;

   TransferSummaryPage({Key? key,required this.id}) : super(key: key);

  @override
  State<TransferSummaryPage> createState() => _TransferSummaryPageState();
}

class _TransferSummaryPageState extends State<TransferSummaryPage> {

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

  final TextEditingController _searchController = TextEditingController();
  // ScrollController scrollController = ScrollController();

  String _search = '';

  // searchHandling<Result>() {
  //   log(" SEARCH ${_searchController.text}");
  //   if (_search == "") {
  //     transferList = transferList("");
  //     return transferList;
  //   } else {
  //     transferList = transferList(_search);
  //     return transferList;
  //   }
  // }

  // bool loading = false;
  // bool allLoaded = false;
  late ScrollController controller;
  @override
  void initState() {

    controller = ScrollController()..addListener(loadMore);
    firstLoad();

    pd = initProgressDialog(context);

    super.initState();
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels >=
    //           scrollController.position.maxScrollExtent &&
    //       !loading) {}
    // });
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
        title: Text("Transfer Summary"),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: FutureBuilder(
          future: transferSummary(),
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
                }
            }
          }),
    );
  }

  _pickOrderCards( data) {

    return data != null
        ? ListView.builder(
        // controller: controller,
        shrinkWrap: true,
        itemCount: data['transfer_details'].length,
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              data['transfer_packing_types']==null?
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PickupTransfer(data['transfer_details'][index]['id'],
                  data['transfer_details'][index]['ref_purchase_detail'],
                  data['transfer_details'][index]['qty'].toString(),
              ))):Fluttertoast.showToast(msg: "Transfer Picked Up");
            },
            child: Card(
              margin: kMarginPaddSmall,
              color:Colors.white,
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
                            "Ordered Qty:",
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
                                "${data['transfer_details'][index]['qty']}",
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
                            "Item:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 55,
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
                                "${data['transfer_details'][index]['item_name']}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                        SizedBox(
                          width: 10,
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
                    //           // data[index].pickVerified ||
                    //           //     !data[index].isPicked ||
                    //           //     data[index].status == 3
                    //           //     ? displayToast(msg: "Already Verified")
                    //           //     : goToPage(context,
                    //           //     PickUpVerified(id: data[index].id));
                    //         },
                    //         child: Icon(Icons.add_shopping_cart),
                    //         // style: ButtonStyle(
                    //         //   shadowColor: MaterialStateProperty.all<Color>(
                    //         //       Colors.grey),
                    //         //   backgroundColor:
                    //         //   MaterialStateProperty.all<Color>(data[index]
                    //         //        ||
                    //         //       !data[index].isPicked ||
                    //         //       data[index].status == 3
                    //         //       ? Color.fromARGB(255, 68, 110, 201)
                    //         //       .withOpacity(0.3)
                    //         //       : Color.fromARGB(255, 68, 110, 201)),
                    //         //   shape: MaterialStateProperty.all<
                    //         //       RoundedRectangleBorder>(
                    //         //     RoundedRectangleBorder(
                    //         //       borderRadius: BorderRadius.circular(15),
                    //         //       side: BorderSide(color: Colors.grey),
                    //         //     ),
                    //         //   ),
                    //         // ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //
                    //     SizedBox(
                    //       width: 20,
                    //     ),
                    //     // Container(
                    //     //   width: 100,
                    //     //   child: data[index]['is_transferred'] == "false"
                    //     //       ?
                    //     //   ElevatedButton(
                    //     //     onPressed: () =>
                    //     //     // data[index].byBatch ==
                    //     //     //     false
                    //     //     //     ? goToPage(context,
                    //     //     //     PickUpOrderDetails(data[index].id))
                    //     //     //     :
                    //     //     goToPage(
                    //     //         context,
                    //     //         PickUpOrderByBatchDetails(
                    //     //             data[index])),
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
  Future transferSummary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse("https://$finalUrl${StringConst.transferMaster}transfer-summary/${widget.id}"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // http.Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.baseUrl+StringConst.transferMaster}transfer-summary/${widget.id}')
    //     .getOrdersWithToken();
    print("Response Code Drop: ${response.statusCode}");
    log("${response.body}");

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
