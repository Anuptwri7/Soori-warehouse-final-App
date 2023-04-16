import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/buttons_const.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/in/po_in_list.dart';
import 'package:http/http.dart' as http;
import 'package:soori_warehouse/ui/login/login_screen.dart';
import 'package:soori_warehouse/ui/pick/ui/pickup_order_save_codes.dart';

import '../model/pickup_details.dart';

class PickUpOrderDetails extends StatefulWidget {
  final orderID;
  PickUpOrderDetails(this.orderID);

  @override
  State<PickUpOrderDetails> createState() => _PickUpOrderDetailsState();
}

class _PickUpOrderDetailsState extends State<PickUpOrderDetails> {
  late http.Response response;
  late ProgressDialog pd;
  late Future<List<Result>?> pickUpDetails;
  bool isPicked = true;
  List packLocations = [];

  @override
  void initState() {
    pickUpDetails = pickUpOrdersDetails(widget.orderID);
    packLocations.clear();
    pd = initProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pickup Details"),
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

    prefs.setString(StringConst.pickUpOrderID, widget.orderID.toString());
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlCustomerOrderApp}order-detail?&limit=0&order=$receivedOrderID'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //         '$finalUrl${StringConst.baseUrl+StringConst.urlCustomerOrderApp}order-detail?&limit=0&order=$receivedOrderID')
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
              /*Save PackType codes*/
              savePackCodeList(data[index].customerPackingTypes);
              isPicked = data[index].picked;
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
                          children: [
                            Container(
                              child: Text(
                                "Item Name:",
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
                                "${data[index].itemName}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          ],
                        ),
                        // poInRowDesign('Item Name :',data[index].itemName),
                        kHeightSmall,
                        // poInRowDesign('Ordered Qty :', data[index].qty.toString()),
                        // kHeightMedium,
                        // poInRowDesign('Pickup Locations :', ''),
                        kHeightSmall,
                        Container(
                          alignment: AlignmentDirectional.topStart,
                          child: showMorePickUpLocations(showPickUpLocations()),
                        ),

                        kHeightMedium,
                        pickedOrNotPicked(data, index),
                      ],
                    ),
                  ),
                ),
              );
            })
        : const Text('We have no Data for now');
  }

  void savePackCodeList(List<CustomerPackingType> customerPackingTypes) {
    for (int i = 0; i < customerPackingTypes.length; i++) {
      packLocations.add(customerPackingTypes[i].locationCode ?? "" + "\n");
    }
  }

  String showPickUpLocations() {
    return packLocations.join(" , ").toString();
  }

  pickedOrNotPicked(data, index) {
    return !isPicked
        ? RoundedButtons(
            buttonText: 'Pick',
            onTap: () => {
              // goToPage(context, PickUpScanLocation(data[index].customerPackingTypes, data[index].id, index))},
              goToPage(
                  context,
                  PickUpOrderSaveLocation(
                      data[index].customerPackingTypes, data[index].id, index))
            },
            color: Color(0xff2c51a4),
          )
        : RoundedButtons(
            buttonText: 'Picked',
            onTap: () {
              return displayToastSuccess(msg: 'Item Alredy Dropped');
            },
            color: Color(0xff6b88e8),
          );
  }
}
