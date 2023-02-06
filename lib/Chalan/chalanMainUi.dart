import 'package:flutter/material.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/chalanReturnPage.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/ui/Pack%20Info/packInfoPage.dart';
import 'package:soori_warehouse/ui/audit/ui/audit_list.dart';
import 'package:soori_warehouse/ui/in/po_in_list.dart';
import 'package:soori_warehouse/ui/opening/ui/opening_list.dart';
import 'package:soori_warehouse/ui/pick/ui/pick_order_list.dart';
import '../Chalan/Chalan Return/chalanReturnDrop/chalanReturnDropPage.dart';


class ChalanMainUI extends StatefulWidget {
  @override
  State<ChalanMainUI> createState() => _ChalanMainUIState();
}

class _ChalanMainUIState extends State<ChalanMainUI> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: Text("Chalan"),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top:0.0),
            //   child: Container(
            //     height: 80,
            //     decoration: const BoxDecoration(
            //         gradient: LinearGradient(
            //           begin: Alignment(-1.0, -0.94),
            //           end: Alignment(0.968, 1.0),
            //           colors: [Color(0xff2c51a4), Color(0xff6b88e8)],
            //           stops: [0.0, 1.0],
            //         ),
            //         borderRadius: BorderRadius.only(
            //           topLeft: Radius.circular(5.0),
            //           topRight: Radius.circular(5.0),
            //           bottomRight: Radius.circular(5.0),
            //           bottomLeft: Radius.circular(5.0),
            //         ),
            //         color: Colors.blue),
            //     child: const Center(
            //       child: Padding(
            //         padding: EdgeInsets.only(left: 140.0),
            //         child: Text(
            //           'Soori IMS Warehouse',
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 14),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
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
                      kHeightVeryBig,
                      kHeightVeryBig,
                      kHeightVeryBig,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _poButtonDesign(Icons.arrow_drop_up, StringConst.chalanreturn,
                              goToPage: () => goToPage(context, ChalanReturnPage())),
                          kHeightVeryBig,
                          _poButtonDesign(Icons.arrow_drop_down, StringConst.chalanReturndrop,
                              goToPage: () => goToPage(context, ChalanReturnDropPage())),
                        ],
                      ),

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
          height: 70,
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
}
