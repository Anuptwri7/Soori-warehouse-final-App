import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/buttons_const.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/audit/ui/audit_list.dart';
import 'package:soori_warehouse/ui/login/login_screen.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';

class ScanAuditItems extends StatefulWidget {

  final  auditID;
  final isCompleted;
  final isFirstTime;
  ScanAuditItems({this.auditID, this.isCompleted, this.isFirstTime});


  @override
  _ScanAuditItemsState createState() => _ScanAuditItemsState();
}

class _ScanAuditItemsState extends State<ScanAuditItems> {
  String _source = '';
  String _serialNo = '';
  int count = 0;
  final List<String> _auditSerialNo = [];
  late http.Response response;
  late ProgressDialog pd;
  bool _isFinished = false;

  @override
  void initState() {
    initDataWedgeListener();
    // pd = initProgressDialog(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popAndLoadPage(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Audit List'),
          backgroundColor: Color(0xff2c51a4),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            kHeightMedium,
            Center(
              child: Text(
                'Audit No',
                style: kTextStyleBlack.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            kHeightMedium,
            _displayCurrentSerialNo(),
            kHeightMedium,
            _displayBox(),
            kHeightMedium,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: RoundedButtons
                    (color: Colors.green,
                      buttonText: 'Completed',
                      onTap: () => _completedButton()
                  )),
                  const SizedBox(width: 16,),
                  Flexible(child: RoundedButtons(color: Colors.red, buttonText: 'Continue', onTap: ()=> _continueButton())),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _displayBox() {
    return Card(
      elevation: kCardElevation,
      shape: kCardRoundedShape,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: _auditSerialNo.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: kMarginPaddSmall,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(displayAuditSerialList(index),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _auditSerialNo.removeAt(index);
                          count = _auditSerialNo.length;
                        });
                      },
                      icon: Icon(Icons.close),),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Future<void> initDataWedgeListener() async {
    ZebraDataWedge.listenForDataWedgeEvent((response) {
      if (response != null && response is String) {

          Map<String, dynamic>? jsonResponse;
          try {
            jsonResponse = json.decode(response);

            if (jsonResponse != null) {
              _serialNo = jsonResponse["decodedData"].toString().trim();

              _auditSerialNo.add(_serialNo);
              var _newAuditSerialNo = _auditSerialNo.toList().toSet();
              _auditSerialNo.clear();
              _auditSerialNo.addAll(_newAuditSerialNo);
              count = _auditSerialNo.length;
            } else {
              _source = "An error Occured";
            }

          } catch (e) {
            displayToast(msg: 'Something went wrong, Please Scan Again');
          }

          setState(() {});

      }
    });
  }

  _displayCurrentSerialNo() {
    return Card(
      elevation: kCardElevation,
      shape: kCardRoundedShape,
      child: Padding(
        padding: kMarginPaddSmall,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Serial No',
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Count',
                    style: kTextStyleSmall.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
            kHeightSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    _serialNo,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    count.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            kHeightSmall,
          ],
        ),
      ),
    );
  }

  String displayAuditSerialList(index) {
    String _serialNumbers = '';
    if (_auditSerialNo.length > index) {
      _serialNumbers = _auditSerialNo[index];
      _serialNumbers = (index + 1).toString() + ". \t" + _serialNumbers;
    } else {
      _serialNumbers = '';
    }
    return _serialNumbers;
  }
  

  _completedButton() {
    showDialog(context: context,
        builder: (_){
        return  AlertDialog(
          title: const Text('Do You Finished Scanning?'),
          actions: [
            TextButton(
              child: const Text('Yes', style: kTextStyleBlack,),
              onPressed: () {
                Navigator.of(context).pop();
                _saveCompleteTask();
                },
            ),
            noAlertTextButton()
          ],
        );
        });
  }

  _continueButton() {
    showDialog(context: context,
        builder: (_){
        return  AlertDialog(
          title: const Text('Are you Ready to Save Your Task?'),
          actions: [
            TextButton(
              child: const Text('Yes', style: kTextStyleBlack,),
              onPressed: () {
                Navigator.of(context).pop();
                _saveContinueTask();
              },
            ),
            noAlertTextButton()
          ],
        );
        });
  }

  noAlertTextButton(){
    return TextButton(
      child: const Text('No', style: kTextStyleBlack),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }


  /*Future Works*/
  void _saveContinueTask() {
    _isFinished = false;
    sendAuditList(_isFinished, widget.isFirstTime);
  }

  void _saveCompleteTask() {
    sendAuditList(true, widget.isFirstTime);
  }
  popAndLoadPage() {
    Navigator.pop(context);
    Navigator.pop(context);
    goToPage(context, AuditList());
  }

  Future sendAuditList(isTaskFinished, _isFirstTime) async {
    // log("jghjh"+widget.auditID.toString());
    if (_auditSerialNo.isNotEmpty) {
      // pd.show(max: 100, msg: 'Items Uploading...');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String finalUrl = prefs.getString(StringConst.subDomain).toString();
      var jsonData;
      /*Audit Details*/

      List  auditDetails = [];
      for(int i = 0; i< _auditSerialNo.length;  i++){
        auditDetails.add({'packing_type_detail_code': _auditSerialNo[i]});
      }
      try {
        if(isTaskFinished && _isFirstTime){
          String finalUrl = prefs.getString("subDomain").toString();
           response = await http.post(
              Uri.parse('https://$finalUrl/api/v1/audit-app/save-audit'),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${prefs.get("access_token")}'
              });
          // response = await NetworkHelper('https://api-soori-ims-staging.dipendranath.com.np/api/v1/audit-app/save-audit')
          //     .sendAuditSerialNo(auditDetails: auditDetails, isFinished : isTaskFinished

        }
        /*For Continue in First Time*/
        else if(!isTaskFinished && _isFirstTime) {
          response = await http.post(
              Uri.parse('https://$finalUrl/api/v1/audit-app/save-audit'),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${prefs.get("access_token")}'
              });
          // response = await NetworkHelper('https://api-soori-ims-staging.dipendranath.com.np/api/v1/audit-app/save-audit')
          //     .sendAuditSerialNo(auditDetails: auditDetails, isFinished : isTaskFinished
          // );
        }

        else if(isTaskFinished && !_isFirstTime) {
          response = await http.post(
              Uri.parse('https://$finalUrl/api/v1/audit-app/save-audit/${widget.auditID}'),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${prefs.get("access_token")}'
              });
          // response = await NetworkHelper('https://api-soori-ims-staging.dipendranath.com.np/api/v1/audit-app/save-audit/${widget.auditID}')
          //
          //     .updateAuditSerialNo(auditDetails: auditDetails, isFinished : isTaskFinished
          // );
        }
        /*    else if(isTaskFinished && !_isFirstTime) {
          response = await NetworkHelper('$finalUrl${StringConst.urlAuditApp}save-audit')
              .sendAuditSerialNo(auditDetails: auditDetails, isFinished : isTaskFinished
          );
        }*/
        else {
          response = await http.post(
              Uri.parse('https://$finalUrl/api/v1/audit-app/save-audit/${widget.auditID}}'),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${prefs.get("access_token")}'
              });
          // response = await NetworkHelper('https://api-soori-ims-staging.dipendranath.com.np/api/v1/audit-app/save-audit/${widget.auditID}')
          //     .updateAuditSerialNo(auditDetails: auditDetails, isFinished : isTaskFinished
          // );

        }


        jsonData = jsonDecode(response.body.toString());
        // pd.close();

        print("Response Code Audit : ${response.statusCode}");

        if (response.statusCode >= 200 && response.statusCode < 300) {
          displayToast(msg: 'Data Inserted Successfully');
          setState(() {
            _auditSerialNo.clear();
            count = 0;
            _serialNo = '';
          });
          popAndLoadPage();
        } else if (response.statusCode == 400 ) {
          displayToast(msg: '${jsonData['message']}, Please Scan Again');
        } else if (response.statusCode == 401) {
          displayToast(msg: 'User Expired, Please Try Again');
          replacePage(LoginScreen(), context);
        } else if (response.statusCode >= 500 && response.statusCode < 600) {
          displayToast(msg: StringConst.serverErrorMsg);
        }
      } catch (e) {
        displayToast(msg: StringConst.serverErrorMsg);
        // pd.close();
      }
    } else {
      displayToast(msg: 'Please Add Serial Numbers First');
    }
  }
  

}
