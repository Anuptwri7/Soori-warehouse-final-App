import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/opening/model/opening_stocklist_model.dart';
import '../../../consts/buttons_const.dart';
import '../../../consts/methods_const.dart';
import '../../../consts/style_const.dart';
import '../../in/po_in_list.dart';
import '../../login/login_screen.dart';
import 'opening_stock_details.dart';
import 'package:http/http.dart' as http;
class OpeningStockList extends StatefulWidget {
  const OpeningStockList({Key? key}) : super(key: key);

  @override
  State<OpeningStockList> createState() => _OpeningStockListState();
}

class _OpeningStockListState extends State<OpeningStockList> {
  late Response response;
  late ProgressDialog pd;

  late Future<List<Result>?> openinglistmodel;

  @override
  void initState() {
    openinglistmodel = listOpeningStocks();
    pd = initProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.openingStocks),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          FutureBuilder<List<Result>?>(
              future: openinglistmodel,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return _openingStockOrderCards(snapshot.data);
                    }
                }
              })
        ],
      ),
    );
  }

  _openingStockOrderCards(List<Result>? data) {
    return data != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
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
                              "Purchase No :",
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
                              "${data[index].purchaseNo}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                      // poInRowDesign('Purchase No :', data[index].purchaseNo),
                      kHeightSmall,
                      Row(
                        children: [
                          Container(
                            child: Text(
                              "Date :",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 75,
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
                              "${data[index].createdDateAd.toLocal().toString().substring(0, 10)}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                      // poInRowDesign(
                      //     'Date :',
                      //     data[index]
                      //         .createdDateAd
                      //         .toLocal()
                      //         .toString()
                      //         .substring(0, 10)),
                      kHeightSmall,
                      // Row(
                      //   children: [
                      //     Container(
                      //       child: Text(
                      //         "Supplier Name:",
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
                      //             "${data[index].supplierName ?? ''}",
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           )),
                      //     ),
                      //   ],
                      // ),
                      // poInRowDesign(
                      //     'Supplier Name :', data[index].supplierName ?? ''),
                      kHeightMedium,
                      RoundedButtons(
                        buttonText: 'View Details',
                        onTap: () => goToPage(
                            context, OpeningStockDetails(data[index].id)),
                        color: Color(0xff2c51a4),
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

  /*Network Calls
  * TODO Keep All Network Calls in Separate Files*/
  Future<List<Result>?> listOpeningStocks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl${StringConst.urlOpeningStockApp}opening-stock?ordering=-id&limit=0'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
    // response = await NetworkHelper(
    //         '$finalUrl${StringConst.urlOpeningStockApp}opening-stock?ordering=-id&limit=0')
    //     .getOrdersWithToken();

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return openingStockListModelFromJson(response.body.toString()).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }
}
