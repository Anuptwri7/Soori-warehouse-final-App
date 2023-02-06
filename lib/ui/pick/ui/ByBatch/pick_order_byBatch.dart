import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:http/http.dart' as http;
import 'package:soori_warehouse/ui/login/login_screen.dart';
import 'package:soori_warehouse/ui/pick/ui/ByBatch/pickup_order_save_byBatch.dart';

import '../../model/pickup_details.dart';

class PickUpOrderByBatchDetails extends StatefulWidget {
  final orderID;
  PickUpOrderByBatchDetails(this.orderID);

  @override
  State<PickUpOrderByBatchDetails> createState() =>
      _PickUpOrderByBatchDetailsState();
}

class _PickUpOrderByBatchDetailsState extends State<PickUpOrderByBatchDetails> {
  late http.Response response;
  late ProgressDialog pd;
  late Future<List<Result>?> pickUpDetails;
  List byBatchList = [];

  @override
  void initState() {
    pickUpDetails = pickUpOrdersDetails(widget.orderID);
    byBatchList.clear();
    pd = initProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pickup Order Details By Batch"),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: FutureBuilder<List<Result>?>(
          future: pickUpDetails,
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
    );
  }

  Future<List<Result>?> pickUpOrdersDetails(int receivedOrderID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    log(receivedOrderID.toString());
    prefs.setString("order", widget.orderID.toString());
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlCustomerOrderApp}order-detail?&limit=0&cancelled=false&order=$receivedOrderID'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //         '$finalUrl${StringConst.baseUrl+StringConst.urlCustomerOrderApp}order-detail?&limit=0&cancelled=false&order=$receivedOrderID')
    //     .getOrdersWithToken();

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return pickUpDetailsFromJson(response.body.toString()).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
    return null;
  }

  dropItemDetails(List<Result>? data) {
    return data != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => {
                  data[index].picked == false
                      ? goToPage(
                          context,
                          PickUpOrderByBatchSaveLocation(
                              data[index].purchaseDetail,
                              data[index].id,
                              data[index].qty))
                      : displayToastSuccess(msg: 'Item Alredy Dropped')
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    margin: kMarginPaddSmall,
                    color: data[index].picked == false
                        ? Colors.white
                        : Colors.grey,
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
                                  "Item Name:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 17,
                              ),
                              Container(
                                height: 30,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: const Color(0xffeff3ff),
                                  borderRadius: BorderRadius.circular(10),
                                  // boxShadow: const [
                                  //   BoxShadow(
                                  //     color: Color(0xffeff3ff),
                                  //     offset: Offset(-2, -2),
                                  //     spreadRadius: 1,
                                  //     blurRadius: 10,
                                  //   ),
                                  // ],
                                ),
                                child: Center(
                                    child: Text(
                                  "${data[index].itemName}",
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
                                  "Batch no:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Container(
                                height: 30,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: const Color(0xffeff3ff),
                                  borderRadius: BorderRadius.circular(10),
                                  // boxShadow: const [
                                  //   BoxShadow(
                                  //     color: Color(0xffeff3ff),
                                  //     offset: Offset(-2, -2),
                                  //     spreadRadius: 1,
                                  //     blurRadius: 10,
                                  //   ),
                                  // ],
                                ),
                                child: Center(
                                    child: Text(
                                  "${data[index].purchaseDetail}",
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
                                  "Quantity:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Container(
                                height: 30,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: const Color(0xffeff3ff),
                                  borderRadius: BorderRadius.circular(10),
                                  // boxShadow: const [
                                  //   BoxShadow(
                                  //     color: Color(0xffeff3ff),
                                  //     offset: Offset(-2, -2),
                                  //     spreadRadius: 1,
                                  //     blurRadius: 10,
                                  //   ),
                                  // ],
                                ),
                                child: Center(
                                    child: Text(
                                  "${data[index].qty}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            ],
                          ),
                          // kHeightMedium,
                          // pickedOrNotPicked(data, index),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
        : const Text('We have no Data for now');
  }

  // void savePackCodeList(List<CustomerPackingType> customerPackingTypes) {
  //   for (int i = 0; i < customerPackingTypes.length; i++) {
  //     byBatchList.add(customerPackingTypes[i].locationCode ?? "" + "\n");
  //   }
  // }

  // String showPickUpByBatch() {
  //   return byBatchList.join(" , ").toString();
  // }

  // pickedOrNotPicked(data, index) {
  //   return !isPicked
  //       ? RoundedButtons(
  //           buttonText: 'Pick',
  //           onTap: () => {
  //             goToPage(
  //                 context,
  //                 PickUpOrderByBatchSaveLocation(data[index].purchaseDetail,
  //                     data[index].id, data[index].qty))
  //           },
  //           color: Color(0xff2c51a4),
  //         )
  //       : RoundedButtons(
  //           buttonText: 'Picked',
  //           onTap: () {
  //             return displayToastSuccess(msg: 'Item Alredy Dropped');
  //           },
  //           color: Color(0xff6b88e8),
  //         );
  // }
}
