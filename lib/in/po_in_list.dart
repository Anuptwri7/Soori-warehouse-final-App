import 'package:flutter/material.dart';
import 'package:soori_warehouse/consts/buttons_const.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/model/get_pending_orders.dart';
import 'package:soori_warehouse/in/po_in_details.dart';
import '../../data/network/network_methods.dart';

class PendingOrderInList extends StatefulWidget {
  @override
  _PendingOrderInListState createState() => _PendingOrderInListState();
}

class _PendingOrderInListState extends State<PendingOrderInList> {
 late Future<List<Result>?> purchaseOrders;

  @override
  void initState() {
    purchaseOrders = NetworkMethods.listPendingOrders(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.pendingOrders,
          style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:  ListView(
        shrinkWrap: true,
        children: [

          FutureBuilder<List<Result>?>(
              future: purchaseOrders,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return _pendingOrderCards(snapshot.data);
                    }
                }
              })
        ],
      ),


    );
  }

  _pendingOrderCards(List<Result>? data) {
    return data != null
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
            goToPage(
                context,
                PurchaseOrdersDetails(data[index].purchaseOrderDetails,
                    data[index].id,data[index].orderNo,data[index].supplierName));
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
                    SizedBox(width: 10,),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.brown.shade800,
                          child:  Text('${data[index].supplierName.substring(0,1).toUpperCase() }'),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 200,
                          child: Text(
                            "${data[index].supplierName}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),

                      ],
                    ),


                    // poInRowDesign(
                    //     'Date :',
                    //     data[index]
                    //         .createdDateAd
                    //         .toLocal()
                    //         .toString()
                    //         .substring(0, 10)),


                    // poInRowDesign(
                    //     'Remarks :',
                    //     data[index].remarks.isNotEmpty
                    //         ? data[index].remarks
                    //         : "-"),
                    kHeightSmall,
                    // RoundedButtons(
                    //   buttonText: 'View Details',
                    //   onTap: () {
                    //     goToPage(
                    //         context,
                    //         PurchaseOrdersDetails(data[index].purchaseOrderDetails,
                    //             data[index].id));
                    //   },
                    //   color:  Color(0xff2c51a4),
                    // )
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
}

poInRowDesign(labelName, labelValue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      poInRowTextDesign(labelName),
      poInRowTextDesign(labelValue),
    ],
  );
}

poInRowTextDesign(textValue) {
  return Flexible(
    child: Text(
      textValue,
      overflow: TextOverflow.clip,
      style: kTextStyleBlack.copyWith(fontSize: 16),
    ),
  );
}
