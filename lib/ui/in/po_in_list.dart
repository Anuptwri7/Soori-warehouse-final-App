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

class PendingOrderInList extends StatefulWidget {
  const PendingOrderInList({Key? key}) : super(key: key);

  @override
  State<PendingOrderInList> createState() => _PendingOrderInListState();
}

class _PendingOrderInListState extends State<PendingOrderInList> {

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
  final TextEditingController _searchController = TextEditingController();
  // ScrollController scrollController = ScrollController();

  String _search = '';

  // searchHandling<Results>() {
  //   log(" SEARCH ${_searchController.text}");
  //   if (_search == "") {
  //     pickUpList = pickUpOrders("");
  //     return pickUpList;
  //   } else {
  //     pickUpList = pickUpOrders(_search);
  //     return pickUpList;
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
        title: Text("Pending Order"),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // controller: controller,
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                // filled: true,
                // fillColor: Theme.of(context).backgroundColor,
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                errorMaxLines: 4,
              ),
              // validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (query) {
                setState(() {
                  _search = query;
                  log(_search);
                });
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            ListView(
              // controller: controller,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                FutureBuilder(
                    future: pendingUpOrders(),
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
        itemCount: data['count'],
        // physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          // log("im the data"+data.length.toString());
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
                      Container(
                        child: Text(
                          "Order No:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 30,
                        width: 200,
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
                              "${data['results'][index]['order_no'].toString()}",
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
                          "Supplier Name:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 30,
                        width: 200,
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
                              "${data['results'][index]['supplier']['name'].toString()}",
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
                        width: 20,
                      ),
                      Container(
                        height: 30,
                        width: 200,
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
                              "${data['results'][index]['grand_total'].toString()}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  kHeightMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            data['results'][index]['status']=="RECEIVED" ||
                                data['results'][index]['status']=="CANCELLED"
                                ? displayToast(msg: "Already Verified")
                                :
                            goToPage(context,
                                PurchaseOrdersDetails( id:data['results'][index]['id']));
                          },
                          child: Icon(Icons.check),
                          style: ButtonStyle(
                            shadowColor: MaterialStateProperty.all<Color>(
                                Colors.grey),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                                data['results'][index]['status']=="RECEIVED" ||
                                data['results'][index]['status']=="CANCELLED"
                                ? Color.fromARGB(255, 68, 110, 201)
                                .withOpacity(0.3)
                                : Color.fromARGB(255, 68, 110, 201)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      // Container(
                      //   width: 100,
                      //   child: data[index].isPicked == false
                      //       ? ElevatedButton(
                      //     onPressed: () => data[index].byBatch ==
                      //         false
                      //         ? goToPage(context,
                      //         PickUpOrderDetails(data[index].id))
                      //         : goToPage(
                      //         context,
                      //         PickUpOrderByBatchDetails(
                      //             data[index].id)),
                      //     child: Text(
                      //       "PickUp",
                      //       style: TextStyle(
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //     style: ButtonStyle(
                      //         shadowColor:
                      //         MaterialStateProperty.all<Color>(
                      //             Colors.grey),
                      //         backgroundColor:
                      //         MaterialStateProperty.all<Color>(
                      //             Color(0xff3667d4)),
                      //         shape: MaterialStateProperty.all<
                      //             RoundedRectangleBorder>(
                      //             RoundedRectangleBorder(
                      //                 borderRadius:
                      //                 BorderRadius.circular(15),
                      //                 side: BorderSide(
                      //                     color: Colors.grey)))),
                      //   )
                      //       : ElevatedButton(
                      //     onPressed: () {
                      //       displayToast(msg: "Already Picked");
                      //     },
                      //     child: Text(
                      //       "Picked",
                      //       style: TextStyle(
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //     style: ButtonStyle(
                      //       shadowColor:
                      //       MaterialStateProperty.all<Color>(
                      //           Colors.grey),
                      //       backgroundColor:
                      //       MaterialStateProperty.all<Color>(
                      //           Color.fromARGB(255, 68, 110, 201)
                      //               .withOpacity(0.3)),
                      //       shape: MaterialStateProperty.all<
                      //           RoundedRectangleBorder>(
                      //         RoundedRectangleBorder(
                      //           borderRadius:
                      //           BorderRadius.circular(15),
                      //           side: BorderSide(color: Colors.grey),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ],
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

  Future pendingUpOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlPurchaseApp}pending-purchase-order-master?offset=0&limit=0&ordering=-order_no&item=&supplier=&date_after=&date_before='),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // http.Response response = await NetworkHelper(
    //     '$finalUrl${StringConst.urlPurchaseApp}pending-purchase-order-master?offset=0&limit=0&ordering=-order_no&item=&supplier=&date_after=&date_before=')
    //     .getOrdersWithToken();
    print("Response Code Drop: ${response.statusCode}");
    log("${(response.body)}");

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
