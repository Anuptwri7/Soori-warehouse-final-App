import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soori_warehouse/SerialInfo/serialInfoPage.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/ui/Pack%20Info/packInfoPage.dart';
import 'package:soori_warehouse/ui/audit/ui/audit_list.dart';
import 'package:soori_warehouse/ui/in/po_in_list.dart';
import 'package:soori_warehouse/ui/opening/ui/opening_list.dart';
import 'package:soori_warehouse/ui/pick/ui/pick_order_list.dart';
import 'package:soori_warehouse/ui/transfer%20Order/transferList.dart';
import '../Chalan/chalanMainUi.dart';
import '../Sales/SalesMainUi.dart';
import '../main.dart';
import 'Notification/controller/notificationController.dart';
import 'drop/Bulk Drop/ui/bulkDropListPage.dart';
import 'drop/ui/drop_ order_list.dart';
import 'location Shift/locationShiftPage.dart';
import 'package:http/http.dart' as http;

import 'login/login_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String ? name;
  int numNotific = 10;

  @override
  void initState() {
    super.initState();
    final data = Provider.of<NotificationClass>(context, listen: false);
    data.fetchCount(context);

  }

  @override
  Widget build(BuildContext context) {
    final count = Provider.of<NotificationClass>(context);
    return  Scaffold(
      appBar:AppBar(
        actions: [
          // const Icon(
          //   Icons.search,
          //   color: Color(0xff2c51a4),
          // ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.grey,
                  size: 30,
                ),
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const NotificationPage()));
                },
              ),
              if (count.notificationCountModel?.unreadCount != null)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      "${(count.notificationCountModel?.unreadCount)}",
                      //! > (numNotific) ?"9+":count.notificationCountModel?.unreadCount
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Container(),
            ],
          ),

          // const SizedBox(
          //   width: 10,
          // ),
          InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const NotificationPage()));
            },
            child: Stack(
              children: [


                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onPressed: ()async{
                    final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();

                    sharedPreferences.clear();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));
                  },
                ),

              ],
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],

        title: Row(
          children:  [

            Text(
              "SOORI WAREHOUSE",
              style: TextStyle(color: Colors.blueGrey, fontSize: 15,fontWeight: FontWeight.bold),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:10.0,left: 20,right:20 ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    // height: 350,
                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow:[
                        BoxShadow(
                          color: Color(0x155665df),
                          spreadRadius: 5,
                          blurRadius: 17,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.poIn,
                                goToPage: () => goToPage(context, PendingOrderInList())),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.poDrop,
                                goToPage: () => (OpenDialogCustomer(context))),
                          ],
                        ),
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.poOut,
                                goToPage: () => goToPage(context, PickOrder())),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.poAudit,
                                goToPage: () => goToPage(context, AuditList())),
                          ],
                        ),
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.locationShifting,
                                goToPage: () => goToPage(context, LocationShifting())),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.info,
                                goToPage: () => (OpenDialogInfo(context))),
                          ],
                        ),

                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesign(Icons.arrow_drop_up, StringConst.chalan,
                                goToPage: () => goToPage(context, ChalanMainUI())),
                            kHeightVeryBig,
                            _poButtonDesign(Icons.arrow_drop_down, StringConst.sale,
                                goToPage: () => goToPage(context, SalesMainUI())),
                          ],
                        ),
                        kHeightVeryBig,
                        _poButtonDesign(Icons.arrow_drop_up, StringConst.transfer,
                            goToPage: () => goToPage(context, TransferListPage())),
                        kHeightVeryBig,
                        _poButtonDesign(Icons.arrow_drop_up, StringConst.openingStock,
                            goToPage: () => goToPage(context, OpeningStockList())),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }

  _poButtonDesign(IconData buttonIcon, String buttonString,
      {required VoidCallback goToPage}) {
    return Card(
      elevation: kCardElevation,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        focusColor: Colors.white,
        onTap: goToPage,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          height: 60,
          width: 150,
          // color: Colors.blueGrey[700],
          // color: Colors.white10,
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
          child: Column(
            children: [
              Icon(
                buttonIcon,
                size: 32,
                color: Colors.black,
              ),
              Text(
                buttonString,
                style: kTextStyleBlack,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _poButtonDesignDailog(IconData buttonIcon, String buttonString,
      {required VoidCallback goToPage}) {
    return Card(
      elevation: kCardElevation,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        focusColor: Colors.white,
        onTap: goToPage,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          height: 60,
          width: 120,
          // color: Colors.blueGrey[700],
          // color: Colors.white10,
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
          child: Column(
            children: [
              SizedBox(height: 10,),
              Icon(
                buttonIcon,
                size: 20,
                color: Colors.black,
              ),
              // SizedBox(height: 5,),
              Text(
                buttonString,
                style: kTextStyleBlack,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future OpenDialogCustomer(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesignDailog(Icons.arrow_circle_down_sharp, StringConst.bulkDrop,
                                goToPage: () => goToPage(context, BulkPODrop())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.singleDrop,
                                goToPage: () => goToPage(context, PODrop())),
                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView(
                              // controller: scrollController,
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              children: [

                              ],
                            ),


                          ],
                        ),


                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.ac_unit_sharp,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );
  Future OpenDialogInfo(BuildContext context) =>
      showDialog(
        barrierColor: Colors.black38,

        context: context,

        builder: (context) => Dialog(
          backgroundColor: Colors.indigo.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // height:600,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: Column(
                      children: [
                        kHeightVeryBig,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _poButtonDesignDailog(Icons.arrow_circle_down_sharp, StringConst.getPackInfo,
                                goToPage: () => goToPage(context, PackInfo())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.serialInfo,
                                goToPage: () => goToPage(context, SerialInfoPage())),
                            kHeightVeryBig,
                            kHeightVeryBig,
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView(
                              // controller: scrollController,
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              children: [

                              ],
                            ),


                          ],
                        ),


                      ],
                    ),
                  ),

                ),
              ),
              Positioned(
                  top:-35,

                  child: CircleAvatar(
                    child: Icon(Icons.ac_unit_sharp,size: 40,),
                    radius: 40,

                  )),

            ],
          ),
        ),

      );
}

