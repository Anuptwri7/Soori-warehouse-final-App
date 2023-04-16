import 'package:flutter/material.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/chalanReturnPage.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import '../Chalan/Chalan Return/chalanReturnDrop/chalanReturnDropPage.dart';
import 'SaleReturn/saleReturnPage.dart';
import 'SalesReturnDrop/saleReturnDropPage.dart';


class SalesMainUI extends StatefulWidget {
  @override
  State<SalesMainUI> createState() => _SalesMainUIState();
}

class _SalesMainUIState extends State<SalesMainUI> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: Text("Sales"),
        backgroundColor: Colors.indigo,
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
                      kHeightVeryBig,
                      kHeightVeryBig,
                      kHeightVeryBig,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _poButtonDesign(Icons.arrow_drop_up, StringConst.salereturn,
                              goToPage: () => goToPage(context, SaleReturnPage())),
                          kHeightVeryBig,
                          _poButtonDesign(Icons.arrow_drop_down, StringConst.salereturndrop,
                              goToPage: () => goToPage(context, SaleReturnDropPage())),
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
