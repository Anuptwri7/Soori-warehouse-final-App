
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:soori_warehouse/consts/buttons_const.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/audit/scan_audit_items.dart';
import 'package:soori_warehouse/ui/in/po_in_list.dart';
import 'package:soori_warehouse/ui/login/login_screen.dart';

import '../model/audit_list_model.dart';
import 'package:http/http.dart' as http;

class AuditList extends StatefulWidget {
  const AuditList({Key? key}) : super(key: key);

  @override
  State<AuditList> createState() => _AuditListState();
}

class _AuditListState extends State<AuditList> {

  late Response response;
  late ProgressDialog pd;
  late Future<List<Result>?> _auditList;

  @override
  void initState() {
    _auditList = listAuditItems();
    // pd = initProgressDialog(context);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Scan Items'),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: Stack(
        children: [
          Positioned(
            child: ListView(
              shrinkWrap: true,
              children: [
                kHeightMedium,
                const Center(
                  child: Text(
                    'List of Audits',
                    style: kTextStyleBlack,
                  ),
                ),
                kHeightBig,
                FutureBuilder<List<Result>?>(
                    future: _auditList,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return _auditItemCards(snapshot.data);
                          }
                      }
                    }),
              ],
            ),
          ),
          Positioned(
            child:  Container(
            alignment: Alignment.bottomCenter,
            padding: kMarginPaddSmall,
            child: RoundedButtonTwo(
              buttonText: 'Create Audit',
              onTap: () => scanAuditItems(),
              color: Colors.green,
            ),
          ),)
        ],
      ),
    );
  }

  _auditItemCards(List<Result>? data){
    return  data != null
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
            child: InkWell(
              onTap: () {
                data[index].isFinished
                    ? displayToastSuccess(msg : 'This Audit is Completed')
                    :goToPage(context, ScanAuditItems(auditID: data[index].id, isCompleted : false, isFirstTime : false));
              },
              child: Container(
                padding: kMarginPaddMedium,
                child: Column(
                  children: [
                    kHeightSmall,
                    Text( data[index].auditNo),
                    kHeightMedium,
                    Text( data[index].isFinished ? 'Completed' : 'Not Completed'),
                    kHeightSmall,
                  ],
                ),
              ),
            ),
          );
        })
        : Center(child: Text(
        StringConst.noDataAvailable,
        style: kTextStyleBlack,
      ),
    );



  }


  scanAuditItems() {
    goToPage(context, ScanAuditItems(auditID : -1, isCompleted : false, isFirstTime : true));
  }

  Future<List<Result>?> listAuditItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String finalUrl = prefs.getString(StringConst.subDomain).toString();
    String finalUrl = prefs.getString("subDomain").toString();
    final response = await http.get(
        Uri.parse('https://$finalUrl/api/v1/audit-app/audit-report'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.get("access_token")}'
        });
     // response = await NetworkHelper(
     //    'https://api-soori-ims-staging.dipendranath.com.np/api/v1/audit-app/audit-report')
     //    .getOrdersWithToken();

    if (response.statusCode == 401) {
      replacePage(LoginScreen(), context);
    } else {
      if (response.statusCode == 200 || response.statusCode == 201) {
        printResponse(response);
        return auditGetDataFromJson(response.body.toString()).results;
      } else {
        displayToast(msg: StringConst.somethingWrongMsg);
      }
    }
  }

}
