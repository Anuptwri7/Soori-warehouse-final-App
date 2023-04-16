import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soori_warehouse/ui/pick/ui/Verification/scan_pick_up.dart';
import 'package:soori_warehouse/ui/pick/ui/Verification/scan_verified_controller.dart';

import '../../../../consts/methods_const.dart';
import '../../../../consts/string_const.dart';
import '../../../../consts/style_const.dart';
import '../../../../data/network/network_helper.dart';
import '../../../login/login_screen.dart';
import '../../model/pickup_verification_model.dart';

class PickUpVerified extends StatefulWidget {
  int id;
  PickUpVerified({Key? key, required this.id}) : super(key: key);

  @override
  State<PickUpVerified> createState() => _PickUpVerifiedState();
}

class _PickUpVerifiedState extends State<PickUpVerified> {
  late http.Response response;

  late Future<List<OrderDetail>?> pickUpVerify;
  int? item;

  @override
  void initState() {
    pickUpVerify = pickUpVerification(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pvr = Provider.of<VerifiedController>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pvr.index.length == item ? _completedButton(context) : null;
    });

    return WillPopScope(
      onWillPop: () async {
        pvr.index.clear();
        pvr.serialId.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(onTap:()=>
              _completedButton(context),child:Row(children: [
            Text("Pickup Verification"),

            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text("Save"),
            )
          ],) ),
          backgroundColor: Color(0xff2c51a4),
          
        ),
        body: Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              FutureBuilder<List<OrderDetail>?>(
                  future: pickUpVerify,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return _verifiedOrderCards(snapshot.data, pvr.index);
                        }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  _completedButton(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(
              'Do You Finished Scanning?',
              style: kTextStyleBlack,
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Yes',
                  style: kTextStyleBlack,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _savePickUpOrderTask();
                  displayToast(msg: "Verify Sucessfully");
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  // Navigator.of(context).pop();
                },
              ),
              noAlertTextButton()
            ],
          );
        });
  }

  noAlertTextButton() {
    return TextButton(
      child: const Text('No', style: kTextStyleBlack),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Future _savePickUpOrderTask() async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    final scan = Provider.of<VerifiedController>(context, listen: false);
    final scannedId = scan.serialId;
    log("Scanned Serial code Id" + scannedId.toString());
    String finalUrl = prefs.getString("subDomain").toString();

    final responseBody = {
      "order_master": widget.id,
      "serial_nos": jsonDecode(scannedId.toString())
    };
    log("Scanned Serial code final" + json.encode(responseBody));
    try {
      final response = await http.post(
          Uri.parse('https://$finalUrl${StringConst.pickupVerify}'),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${prefs.get("access_token")}'
          },
          body: json.encode(responseBody));

      if (response.statusCode == 200 || response.statusCode == 201) {
        scan.serialId.clear();
        scan.index.clear();
        // displayToast(msg: " Succefully");
      } else {
        displayToast(msg: "${response.reasonPhrase}+ Please Scan Again");
      }
    } catch (e) {
      displayToast(msg: e.toString());
      rethrow;
    }
  }

  _verifiedOrderCards(data, p) {
    return data != null
        ? ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, count) {
              return !data[count].cancelled
                  ? GestureDetector(
                      onTap: () => p.contains(count)
                          ? displayToast(msg: "Already Scan")
                          : goToPage(
                              context,
                              ScanForVerified(
                                  data[count].customerPackingTypes,
                                  count,
                                  data[count].id!.toInt(),
                                  data[count].qty)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          margin: kMarginPaddSmall,
                          color: p.contains(count) ? Colors.grey : Colors.white,
                          // color: Color(0xff2c51a4),
                          elevation: kCardElevation,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Container(
                            padding: kMarginPaddSmall,
                            child: Column(
                              children: [
                                kHeightMedium,
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "Item",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                                      ),
                                      child: Center(
                                          child: Text(
                                        "${data[count].item!.name}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ],
                                ),
                                kHeightMedium,
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "Pickup Location:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffeff3ff),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "${data[count].qty}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container();
            })
        : const Text('We have no Data for now');
  }

  Future<List<OrderDetail>?> pickUpVerification(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlCustomerOrderApp}order-summary/$id'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // http.Response response = await NetworkHelper(
    //         '$finalUrl${StringConst.urlCustomerOrderApp}order-summary/$id')
    //     .getOrdersWithToken();
    print("Response Code Verified: ${response.statusCode}");
    log("yes${response.body}");

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        printResponse(response);
        log(response.body);
        // if(json.decode(response.body)['order_details'][0]['cancelled']==false){
        //
        // }
        // item = json.decode(response.body)["order_details"].length;
        return pickUpVerificationModelFromJson(response.body.toString())
            .orderDetails;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
    return null;
  }
}
