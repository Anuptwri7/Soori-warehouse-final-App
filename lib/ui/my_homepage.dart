import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soori_warehouse/SerialInfo/serialInfoPage.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/in/po_in_list.dart';
import 'package:soori_warehouse/ui/Pack%20Info/packInfoPage.dart';
import 'package:soori_warehouse/ui/audit/ui/audit_list.dart';
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
    return  SafeArea(
      child: Scaffold(
        appBar:AppBar(
          actions: [

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
                      color:Color(0xffBF1E2E),
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
                // SizedBox(height: 20,),
                Text(
                  "Welcome To",
                  style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:85.0),
                  child: Row(
                    children: [
                      Text(
                        "SOORI",
                        style: TextStyle(fontSize: 22,color: Color(0xffBF1E2E),fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " Warehouse",
                        style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                kHeightVeryBig,
                Padding(
                  padding: const EdgeInsets.only(top:10.0,left: 20,right:20 ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      // height: 350,
                      // width: MediaQuery.of(context).size.width,
                      // decoration: BoxDecoration(
                      //   boxShadow:[
                      //     BoxShadow(
                      //       color: Color(0x155665df),
                      //       spreadRadius: 5,
                      //       blurRadius: 17,
                      //       offset: Offset(0, 3),
                      //     ),
                      //   ],
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _poButtonDesign(Icons.arrow_drop_up, StringConst.poIn,'assets/images/receive.png',
                                  goToPage: () => goToPage(context, PendingOrderInList())),
                              kHeightVeryBig,
                              _poButtonDesign(Icons.arrow_drop_down, StringConst.poDrop,'assets/images/drop.png',
                                  goToPage: () => goToPage(context,BulkPODrop())),
                            ],
                          ),
                          kHeightVeryBig,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _poButtonDesign(Icons.arrow_drop_up, StringConst.poOut,'assets/images/PickUp.png',
                                  goToPage: () => goToPage(context, PickOrder())),
                              kHeightVeryBig,
                              _poButtonDesign(Icons.arrow_drop_down, StringConst.poAudit,'assets/images/audit.png',
                                  goToPage: () => goToPage(context, AuditList())),
                            ],
                          ),
                          kHeightVeryBig,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _poButtonDesign(Icons.arrow_drop_up, StringConst.locationShifting,'assets/images/locationshift.png',
                                  goToPage: () => goToPage(context, LocationShifting())),
                              kHeightVeryBig,
                              _poButtonDesign(Icons.arrow_drop_down, StringConst.info,'assets/images/packinfo.png',
                                  goToPage: () => (OpenDialogInfo(context))),
                            ],
                          ),

                          kHeightVeryBig,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _poButtonDesign(Icons.arrow_drop_up, StringConst.chalan,'assets/images/chalan.png',
                                  goToPage: () => goToPage(context, ChalanMainUI())),
                              kHeightVeryBig,
                              _poButtonDesign(Icons.arrow_drop_down, StringConst.sale,'assets/images/sale.png',
                                  goToPage: () => goToPage(context, SalesMainUI())),
                            ],
                          ),
                          kHeightVeryBig,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _poButtonDesign(Icons.arrow_drop_up, StringConst.transfer,'assets/images/transfer.png',
                                  goToPage: () => goToPage(context, TransferListPage())),
                              kHeightVeryBig,
                              _poButtonDesign(Icons.arrow_drop_up, StringConst.openingStock,'assets/images/openstock.png',
                                  goToPage: () => goToPage(context, OpeningStockList())),
                            ],
                          ),
                          kHeightVeryBig,

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

      ),
    );
  }

  _poButtonDesign(IconData buttonIcon, String buttonString,String image,
      {required VoidCallback goToPage}) {
    return Card(
      elevation: kCardElevation,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        focusColor: Colors.white,
        onTap: goToPage,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          height: 60,
          width: 150,
          // color: Colors.blueGrey[700],
          // color: Colors.white10,
          // decoration: BoxDecoration(
          //   color:  Colors.white,
          //   borderRadius: BorderRadius.circular(10),
          //   // boxShadow: const [
          //   //   BoxShadow(
          //   //     color: Color(0xffeff3ff),
          //   //     offset: Offset(-2, -2),
          //   //     spreadRadius: 1,
          //   //     blurRadius: 10,
          //   //   ),
          //   // ],
          // ),
          child: Row(
            children: [
              SizedBox(width: 10,),
              Image.asset(
               image
              ),
              SizedBox(width: 10,),
              Text(
                buttonString,
                style: kTextStyleBlackForHomePage,
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
            color: Colors.white,
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
          // backgroundColor: Colors.indigo.shade50,
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
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/images/soorilogo.png"),
                    radius: 45,

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
          // backgroundColor: Colors.indigo.shade50,
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
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.getPackInfo,
                                goToPage: () => goToPage(context, PackInfo())),
                            kHeightVeryBig,
                            _poButtonDesignDailog(Icons.arrow_drop_down, StringConst.serialInfo,
                                goToPage: () => goToPage(context, SerialInfoPage())),
                            kHeightVeryBig,
                            kHeightVeryBig,
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
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/images/soorilogo.png"),
                    radius: 45,

                  )),

            ],
          ),
        ),

      );
}

