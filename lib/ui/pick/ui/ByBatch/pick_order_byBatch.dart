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
  String orderNo;
  String Fname;
  String Lname;
  final orderID;

  PickUpOrderByBatchDetails(this.orderNo,this.Fname,this.Lname,this.orderID);


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
        title: Text("Pickup Order Details By Batch",
          style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: Card(
        margin: kMarginPaddSmall,
        color: Colors.white,
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
                        "${widget.Fname +widget.Lname}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Result>?>(
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
            ],
          ),
        ),
      )

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
                              data[index].qty,
                          widget.orderNo,
                          widget.Fname,
                          widget.Lname))
                      : displayToastSuccess(msg: 'Item Alredy Dropped')
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shadowColor: Colors.white,
                    margin: kMarginPaddSmall,

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
                                    "Qty:${data[index].qty.toInt()}",
                                    style: TextStyle(),
                                  ),


                                ],
                              ),
                              SizedBox(width: 80,),
                              Image.asset(data[index].picked==true?"assets/images/picked.png":"assets/images/notPicked.png")
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
        : const Text('We have no Data for now');
  }


}
