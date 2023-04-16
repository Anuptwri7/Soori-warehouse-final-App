 import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/login/login_screen.dart';
import 'package:soori_warehouse/ui/pick/ui/ByBatch/pick_order_byBatch.dart';
import 'package:soori_warehouse/ui/pick/ui/Verification/pickUp_verify.dart';
import 'package:soori_warehouse/ui/pick/ui/pickup_order_details.dart';

import '../model/pickup_list.dart';

class PickOrder extends StatefulWidget {
  const PickOrder({Key? key}) : super(key: key);

  @override
  State<PickOrder> createState() => _PickOrderState();
}

class _PickOrderState extends State<PickOrder> with TickerProviderStateMixin{

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
  late Future<List<Result>?> pickUpList;
  final TextEditingController _searchController = TextEditingController();
  // ScrollController scrollController = ScrollController();

  String _search = '';

  searchHandling<Result>() {
    log(" SEARCH ${_searchController.text}");
    if (_search == "") {
      pickUpList = pickUpOrders("");
      return pickUpList;
    } else {
      pickUpList = pickUpOrders(_search);
      return pickUpList;
    }
  }

  // bool loading = false;
  // bool allLoaded = false;
  late ScrollController controller;
  late TabController? _controller;
  int _selectedIndex = 0;
  @override
  void initState() {

    controller = ScrollController()..addListener(loadMore);
    firstLoad();
    pd = initProgressDialog(context);
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _controller!.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
      log("Selected Index: " + _controller!.index.toString());
    });
  }


  @override
  void dispose() {
    _controller!.dispose();
    // _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar:AppBar(

          title: Row(
            children:  [
              Text(
                "Pickup list",
                style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _controller,
            indicatorColor:Color(0xffBF1E2E),
            indicatorWeight: 2,
            unselectedLabelColor: Colors.grey,
            labelColor:Color(0xffBF1E2E),
            tabs: [
              Tab(text: "Pending",),
              Tab(text: "Picked",),
              Tab(text: "Verified",),
            ],
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                  FutureBuilder<List<Result>?>(
                      future: searchHandling(),
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
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _pickOrderCards(List<Result>? data) {

    return data != null
        ? ListView.builder(
        controller: controller,
            shrinkWrap: true,
            itemCount: data.length,
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  data[index].byBatch ==
                                        false
                                    ? goToPage(context,
                                        PickUpOrderDetails(data[index].id))
                                    : goToPage(
                                        context,
                                        PickUpOrderByBatchDetails(data[index].orderNo,data[index].customerFirstName,data[index].customerLastName,
                                            data[index].id));
                },
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
                            Icon(Icons.battery_charging_full_outlined),
                            Text("${data[index].orderNo}"),
                            SizedBox(width: 60,),
                            Text("Rs.${data[index].grandTotal}")
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.brown.shade800,
                              child:  Text('${data[index].customerFirstName.substring(0,1).toUpperCase() }'),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              width: 200,
                              child: Text(
                        "${data[index].customerFirstName + data[index].customerLastName}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            // SizedBox(
                            //   width: 10,
                            // ),

                          ],
                        ),
                        kHeightSmall,
                        // Row(
                        //   children: [
                        //     Container(
                        //       child: Text(
                        //         "Order No:",
                        //         style: TextStyle(fontWeight: FontWeight.bold),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 20,
                        //     ),
                        //     Container(
                        //       height: 30,
                        //       width: 200,
                        //       decoration: BoxDecoration(
                        //         color: const Color(0xffeff3ff),
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: const [
                        //           BoxShadow(
                        //             color: Color(0xffeff3ff),
                        //             offset: Offset(-2, -2),
                        //             spreadRadius: 1,
                        //             blurRadius: 10,
                        //           ),
                        //         ],
                        //       ),
                        //       child: Center(
                        //           child: Text(
                        //         "${data[index].orderNo}",
                        //         style: TextStyle(fontWeight: FontWeight.bold),
                        //       )),
                        //     ),
                        //   ],
                        // ),
                        // kHeightMedium,
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Container(
                        //       child: ElevatedButton(
                        //         onPressed: () {
                        //           data[index].pickVerified ||
                        //                   !data[index].isPicked ||
                        //                   data[index].status == 3
                        //               ? displayToast(msg: "Already Verified")
                        //               : goToPage(context,
                        //                   PickUpVerified(id: data[index].id));
                        //         },
                        //         child: Icon(Icons.check),
                        //         style: ButtonStyle(
                        //           shadowColor: MaterialStateProperty.all<Color>(
                        //               Colors.grey),
                        //           backgroundColor:
                        //               MaterialStateProperty.all<Color>(data[index]
                        //                           .pickVerified ||
                        //                       !data[index].isPicked ||
                        //                       data[index].status == 3
                        //                   ? Color.fromARGB(255, 68, 110, 201)
                        //                       .withOpacity(0.3)
                        //                   : Color.fromARGB(255, 68, 110, 201)),
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
                        //     Container(
                        //       width: 100,
                        //       child: data[index].isPicked == false
                        //           ? ElevatedButton(
                        //               onPressed: () => data[index].byBatch ==
                        //                       false
                        //                   ? goToPage(context,
                        //                       PickUpOrderDetails(data[index].id))
                        //                   : goToPage(
                        //                       context,
                        //                       PickUpOrderByBatchDetails(
                        //                           data[index].id)),
                        //               child: Text(
                        //                 "PickUp",
                        //                 style: TextStyle(
                        //                     fontSize: 12,
                        //                     fontWeight: FontWeight.bold),
                        //               ),
                        //               style: ButtonStyle(
                        //                   shadowColor:
                        //                       MaterialStateProperty.all<Color>(
                        //                           Colors.grey),
                        //                   backgroundColor:
                        //                       MaterialStateProperty.all<Color>(
                        //                           Color(0xff3667d4)),
                        //                   shape: MaterialStateProperty.all<
                        //                           RoundedRectangleBorder>(
                        //                       RoundedRectangleBorder(
                        //                           borderRadius:
                        //                               BorderRadius.circular(15),
                        //                           side: BorderSide(
                        //                               color: Colors.grey)))),
                        //             )
                        //           : ElevatedButton(
                        //               onPressed: () {
                        //                 displayToast(msg: "Already Picked");
                        //               },
                        //               child: Text(
                        //                 "Picked",
                        //                 style: TextStyle(
                        //                     fontSize: 12,
                        //                     fontWeight: FontWeight.bold),
                        //               ),
                        //               style: ButtonStyle(
                        //                 shadowColor:
                        //                     MaterialStateProperty.all<Color>(
                        //                         Colors.grey),
                        //                 backgroundColor:
                        //                     MaterialStateProperty.all<Color>(
                        //                         Color.fromARGB(255, 68, 110, 201)
                        //                             .withOpacity(0.3)),
                        //                 shape: MaterialStateProperty.all<
                        //                     RoundedRectangleBorder>(
                        //                   RoundedRectangleBorder(
                        //                     borderRadius:
                        //                         BorderRadius.circular(15),
                        //                     side: BorderSide(color: Colors.grey),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //     )
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

  Future<List<Result>?> pickUpOrders(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();

    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlCustomerOrderApp}order-master?ordering=-id&limit=0&offset=0&search=$search'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // http.Response response = await NetworkHelper(
    //         '$finalUrl${StringConst.urlCustomerOrderApp}order-master?ordering=-id&limit=0&offset=0&search=$search')
    //     .getOrdersWithToken();
    print("Response Code Drop: ${response.statusCode}");
    log("${response.body}");

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        printResponse(response);
        return pickUpListFromJson(response.body.toString()).results;
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
