import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/Model/chalanNo.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/Model/customerModel.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/Services/chalanNoAPI.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/Services/chalanReturnAPI.dart';
import 'package:soori_warehouse/Chalan/Chalan%20Return/chalanReturnDrop/Model/chalanReturnDropModel.dart';

import 'Model/ItemModel.dart';


TextEditingController firstName = TextEditingController();
TextEditingController discountName = TextEditingController();
TextEditingController discountRate = TextEditingController();
TextEditingController middleName = TextEditingController();
TextEditingController lastName = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController contactNumber = TextEditingController();
TextEditingController PanNumber = TextEditingController();
ScrollController scrollController = ScrollController();

class AddChalan extends StatefulWidget {
  const AddChalan({Key? key}) : super(key: key);

  @override
  _AddChalanState createState() => _AddChalanState();
}

class _AddChalanState extends State<AddChalan> {

  bool isVisible = false;
  bool isChecked = false;
  String? _selectedCustomer;
  String? _selectedCustomerName;
  int? _selectedItem;
  String? _seletedBatch;
  String? _selectedBatchNo ;

  bool? loading = false;

  String? _selectedItemName;
  double? _remainingQty;
  double? _remainingQtyBatch;
  double? _selectedItemCost;
  TextEditingController remarkscontroller = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController discountPercentageController = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  List<AddItemModel> allModelData = [];
  bool isVisibleAddCustomer=false;

  double grandTotal = 0.0, subTotal = 0.0, totalDiscount = 0.0, netAmount = 0.0;

  Calc() {
    for (int i = 0; i < allModelData.length; i++) {
      subTotal += allModelData[i].amount!;
      totalDiscount +=
          (allModelData[i].discount! * allModelData[i].amount!) / 100;
      netAmount = (subTotal - totalDiscount);
      grandTotal = netAmount;
      // log("${qtyController.")
      double a = double.parse(qtyController.text);
      log("$a");
      log("${a.runtimeType}");
    }
  }

  @override
  void setState(VoidCallback fn) {

    // TODO: implement setState
    super.setState(fn);
    loading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  DateTime? picked;
  ChalanServices chalanServices =ChalanServices();
  ChalanNoServices chalanNoServices = ChalanNoServices();
  int selectedId = 0;
  String discountInitial = "10.00";
  int discountId = 0;
  int itemId = 0;


  @override
  void initState() {
    chalanServices
        .fetchCustomerFromUrl();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeff3ff),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.0, -0.94),
                    end: Alignment(0.968, 1.0),
                    colors: [Color(0xff2557D2), Color(0xff6b88e8)],
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                  //   color: Color(0xff2557D2)
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Create Chalan Return',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),


              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f7ff),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xfff5f7ff),
                      offset: Offset(5, 8),
                      spreadRadius: 5,
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Customer Name",
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Container(
                                    height: 50,
                                    width: 240,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        // border:Border.all(color:Color(0xff2C51A4).withOpacity(0.8) ) ,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: Offset(4, 4),
                                          )
                                        ]),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 0, top: 2),
                                    child: FutureBuilder(
                                      future: chalanServices
                                          .fetchCustomerFromUrl(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.data == null) {
                                          return Container(child:Text("Loading..."));
                                        }
                                        if (snapshot.hasData) {
                                          try {
                                            final List<CustomerModel> snapshotData =
                                                snapshot.data;
                                            // customerServices.allCustomer = [];
                                            return SearchChoices.single(
                                              items: snapshotData
                                                  .map((CustomerModel value) {
                                                return (DropdownMenuItem(
                                                  child: Text(
                                                      "${value.firstName} ${value.lastName}",
                                                      style: const TextStyle(
                                                          fontSize: 14)),
                                                  value: value.firstName,
                                                  onTap: () {
                                                    // setState(() {
                                                    _selectedCustomer =
                                                        value.id;
                                                    _selectedCustomerName =
                                                        value.firstName;
                                                    log('selected Customer name : ${_selectedCustomerName.toString()}');
                                                    log('selected Customer id : ${_selectedCustomer.toString()}');

                                                    // });
                                                  },
                                                ));
                                              }).toList(),
                                              value: _selectedCustomerName,
                                              searchHint: "Select Customer",
                                              icon: const Visibility(
                                                visible: false,
                                                child:
                                                Icon(Icons.arrow_downward),
                                              ),
                                              onChanged: (CustomerModel? value) {},
                                              dialogBox: true,
                                              keyboardType: TextInputType.text,
                                              isExpanded: true,
                                              clearIcon: const Icon(
                                                Icons.close,
                                                size: 0,
                                              ),
                                              padding: 0,
                                              hint: const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 15, left: 5),
                                                child: Text(
                                                  "Select Customer",
                                                  style:
                                                  TextStyle(fontSize: 15),
                                                ),
                                              ),
                                              underline:
                                              DropdownButtonHideUnderline(
                                                  child: Container()),
                                            );
                                          } catch (e) {
                                            throw Exception(e);
                                          }
                                        } else {
                                          return Opacity(
                                            opacity: 0.8,
                                            child: Shimmer.fromColors(
                                                child: Container(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: const Text(
                                                      'Loading Customers .....',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black)),
                                                ),
                                                baseColor: Colors.black12,
                                                highlightColor: Colors.white),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Chalan No."),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 50,
                              width: 270,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(4, 4),
                                    ),
                                  ]),
                              child: FutureBuilder(
                                future: chalanNoServices.fetchChalanNoFromUrl(_selectedCustomer.toString()),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    try {
                                      final List<ResultsChanal> snapshotData =
                                          snapshot.data;
                                      // customerServices.allItems = [];
                                      return SearchChoices.single(
                                        items:
                                        snapshotData.map((ResultsChanal value) {

                                          return (DropdownMenuItem(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 5.0),
                                              child: Text(
                                                "${value.chalanNo.toString()}",
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                            value: value.chalanNo.toString(),
                                            onTap: () {
                                              setState(() {
                                                _seletedBatch = value.id;
                                                _selectedBatchNo = value.chalanNo.toString();
                                                // _remainingQtyBatch = value.chalanNo;

                                                log('selected item is Taxable or not : ${_seletedBatch.toString()}');
                                                log('selected item is Taxable or not : ${value.chalanNo.toString()}');
                                              });
                                            },
                                          ));
                                        }).toSet().toList(),
                                        value: _selectedBatchNo,
                                        clearIcon: const Icon(
                                          Icons.close,
                                          size: 0,
                                        ),
                                        icon: const Visibility(
                                          visible: false,
                                          child: Icon(Icons.arrow_downward),
                                        ),
                                        underline: DropdownButtonHideUnderline(
                                            child: Container()),
                                        padding: 0,
                                        hint: const Padding(
                                          padding:
                                          EdgeInsets.only(top: 15, left: 8),
                                          child: Text(
                                            "Select Chalan No.",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        searchHint: "Select Chalan No.",
                                        onChanged: (ResultsChanal? value) {},
                                        dialogBox: true,
                                        isExpanded: true,
                                      );
                                    } catch (e) {
                                      throw Exception(e);
                                    }
                                  } else {
                                    return Opacity(
                                        opacity: 0.8,
                                        child: Container(
                                          padding: const EdgeInsets.all(14.0),
                                          child: const Text(
                                              'Choose Customer',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black)),
                                        ));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Center(
                        child: SizedBox(
                          height: 35,
                          width: 80,
                          child: ElevatedButton(
                            onPressed: () async {
                              final SharedPreferences pref = await SharedPreferences.getInstance();
                              double quantiy = double.parse(qtyController.text);
                              // if (pricecontroller.text.isEmpty) {
                              //   Fluttertoast.showToast(
                              //       msg: "Enter the price",
                              //       backgroundColor: Colors.redAccent,
                              //       fontSize: 18);
                              // }
                              // if (dateController.text.isEmpty) {
                              //   Fluttertoast.showToast(
                              //       msg: "Enter the date",
                              //       backgroundColor: Colors.redAccent,
                              //       fontSize: 18);
                              // }
                              if (qtyController.text.isEmpty || qtyController.text.contains(".")) {
                                Fluttertoast.showToast(
                                    msg: "Enter the Quantity in correct format",
                                    backgroundColor: Colors.redAccent,
                                    fontSize: 18);
                              }
                              if (_remainingQty! < quantiy || _remainingQtyBatch! < quantiy) {
                                Fluttertoast.showToast(
                                    msg:
                                    "Quantity can not be greater than stock quantity",
                                    backgroundColor: Colors.redAccent,
                                    fontSize: 18);
                              } else {
                                if (discountPercentageController.text.isEmpty) {
                                  discountPercentageController.text = "0";
                                }
                                grandTotal = 0.0;
                                subTotal = 0.0;
                                totalDiscount = 0.0;
                                netAmount = 0.0;

                                setState(() {
                                  allModelData.add(
                                    AddItemModel(
                                      id: _selectedItem,
                                      name: _selectedItemName.toString(),
                                      quantity:
                                      double.parse(qtyController.text),
                                      price:pricecontroller.text.isEmpty?_selectedItemCost:double.parse(pricecontroller.text),
                                      discount: double.parse(
                                          discountPercentageController.text),
                                      remarks: remarkscontroller.text,

                                      discountAmt: pricecontroller.text.isEmpty?
                                      (double.parse(
                                          discountPercentageController
                                              .text) *
                                          (_selectedItemCost!*
                                              int.parse(qtyController.text)) /
                                          100)
                                          :(double.parse(
                                          discountPercentageController
                                              .text) *
                                          (double.parse(pricecontroller.text) *
                                              int.parse(qtyController.text)) /
                                          100),
                                      amount:pricecontroller.text.isEmpty?
                                      _selectedItemCost! *
                                          int.parse(qtyController.text)
                                          :
                                      double.parse(pricecontroller.text) *
                                          int.parse(qtyController.text),
                                      totalAfterDiscount: pricecontroller.text.isEmpty?(_selectedItemCost! *
                                          int.parse(qtyController.text) -
                                          (double.parse(
                                              discountPercentageController
                                                  .text) *
                                              (_selectedItemCost! *
                                                  int.parse(
                                                      qtyController.text)) /
                                              100)):(double.parse(
                                          pricecontroller.text) *
                                          int.parse(qtyController.text) -
                                          (double.parse(
                                              discountPercentageController
                                                  .text) *
                                              (double.parse(
                                                  pricecontroller.text) *
                                                  int.parse(
                                                      qtyController.text)) /
                                              100)),
                                    ),
                                  );
                                  Calc();

                                  allModelData.isEmpty
                                      ? isVisible = false
                                      : isVisible = true;

                                  log('allModelData.length :' +
                                      allModelData.length.toString());
                                });
                              }
                              _selectedBatchNo= "Select Batch";
                              _selectedItemName = "Select Item";
                              qtyController.clear();
                              _remainingQty! >= quantiy
                                  ? pricecontroller.clear()
                                  : null;
                              discountPercentageController.clear();
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xff5073d9)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                    //  side: BorderSide(color: Colors.red)
                                  ),
                                )),
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Visibility(
                        visible: isVisible,
                        child: Column(
                          children: [
                            DataTable(
                              columns: const [

                                DataColumn(
                                    label: SizedBox(
                                        width: 50, child: Text("Name"))),
                                DataColumn(
                                    label: SizedBox(
                                        width: 20, child: Text("Qty"))),
                                DataColumn(
                                    label: SizedBox(
                                        width: 50, child: Text("Amount"))),
                                DataColumn(
                                    label:
                                    SizedBox(width: 40, child: Text("Action"))),
                              ],
                              rows: [
                                for (int i = 0; i < allModelData.length; i++)
                                  DataRow(cells: [
                                    DataCell(SizedBox(
                                        child: Text(
                                          "${allModelData[i].name}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ))),
                                    DataCell(
                                        Text("${allModelData[i].quantity}")),
                                    DataCell(Text("${allModelData[i].amount}")),
                                    DataCell(
                                      GestureDetector(
                                        onTap:(){
                                          for(int i =0;i<allModelData.length;i++){
                                            setState(() {
                                              allModelData.remove(allModelData[i]);
                                              allModelData.remove(allModelData[i].price);
                                              allModelData.remove(allModelData[i].name);
                                              allModelData.remove(allModelData[i].quantity);
                                              allModelData.remove(allModelData[i].discount);

                                            });
                                          }
                                        },
                                        child: const FaIcon(
                                          FontAwesomeIcons
                                              .deleteLeft,
                                          size: 20,
                                          color: Colors
                                              .indigo,
                                        ),
                                      ),
                                    ),
                                  ])
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Visibility(
                                  visible: true,
                                  child: Center(
                                    child: SizedBox(
                                      height: 35,
                                      width: 80,
                                      child: ElevatedButton(
                                        onPressed: () async {

                                          setState(() {

                                            // AddProduct();
                                          });

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration: const Duration(seconds: 2),
                                            dismissDirection: DismissDirection.down,
                                            content: const Text(
                                              "Product Added Successfully",
                                              style: TextStyle(fontSize: 20),
                                            ),

                                            // margin: EdgeInsets.only(bottom: 70),
                                            padding: const EdgeInsets.all(10),
                                            elevation: 10,
                                            backgroundColor: Colors.blue,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(5)),
                                          ));

                                          // Navigator.pushReplacement(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         CustomerOrderListScreen(),
                                          //   ),
                                          // );
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color(0xff2658D3)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                //  side: BorderSide(color: Colors.red)
                                              ),
                                            )),
                                        child: const Text(
                                          "Save",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(
          const Duration(days: 0),
        ),
        lastDate: DateTime(2030),
        helpText: "Select Delivered Date");
    if (picked != null) {
      setState(() {
        dateController.text = '${picked!.year}-${picked!.month}-${picked!.day}';
      });
    }
  }
  // Future AddProduct() async {
  //
  //   final SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //   double grandTotal = 0.0,
  //       subTotal = 0.0,
  //       totalDiscount = 0.0,
  //       finaldiscount = 0.0,
  //       x = 0.0;
  //   var orderDetails = [];
  //   for (int i = 0; i < allModelData.length; i++) {
  //     subTotal += allModelData[i].amount!;
  //     totalDiscount +=
  //         (allModelData[i].discount! * allModelData[i].amount!) / 100;
  //     finaldiscount = (subTotal - totalDiscount);
  //     grandTotal += (finaldiscount - allModelData[i].amount!);
  //     x += allModelData[i].totalAfterDiscount!;
  //     log("grand toral hjgjhghjgjgh" + x.toString());
  //     orderDetails.add({
  //       "item": allModelData[i].id,
  //       "item_category": 8,
  //       "taxable": _taxable,
  //       "discountable": "true",
  //       "qty": allModelData[i].quantity,
  //       "purchase_cost": 0,
  //       "sale_cost": allModelData[i].price,
  //       "discount_rate": allModelData[i].discount,
  //       "discount_amount": allModelData[i].discountAmt,
  //       "tax_rate": _taxRate,
  //       "tax_amount": 0,
  //       "gross_amount": allModelData[i].amount,
  //       "net_amount": allModelData[i].totalAfterDiscount,
  //       "remarks": allModelData[i].remarks,
  //       "isNew": "true",
  //       "unique": "2ed54673-a7b4-489f-91a2-98abe79241ee",
  //       "cancelled": "false"
  //     });
  //   }
  //   log('subTotal' + subTotal.toString());
  //   log('totalDiscount' + totalDiscount.toString());
  //   log('grandTotal' + x.toString());
  //   final responseBody = {
  //     "status": 1,
  //     "customer": _selectedCustomer,
  //     "sub_total": subTotal,
  //     "total_discount": totalDiscount,
  //     "total_tax": 0,
  //     "grand_total": x,
  //     "remarks": "",
  //     "total_discountable_amount": subTotal,
  //     "total_taxable_amount": 0,
  //     "total_non_taxable_amount": x,
  //     "discount_scheme": '',
  //     "discount_rate": 0,
  //     "delivery_location": locationController.text,
  //     "delivery_date_ad": dateController.text == ""?null:dateController.text,
  //     "order_details": orderDetails,
  //   };
  //   log(json.encode(responseBody));
  //   final response = await http.post(
  //       Uri.parse(ApiConstant.baseUrl + ApiConstant.saveCustomerOrder),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
  //       },
  //       body: json.encode(responseBody));
  //   log(response.body);
  //   if (response.statusCode == 201) {
  //     qtyController.clear();
  //     pricecontroller.clear();
  //     discountPercentageController.clear();
  //     DataCell.empty;
  //   } else if (response.statusCode == 400) {
  //     Fluttertoast.showToast(msg: response.body.toString());
  //   }
  //
  //   return response;
  // }
  // Future AddProductByBatch() async {
  //
  //   final SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //
  //   double grandTotal = 0.0,
  //       subTotal = 0.0,
  //       totalDiscount = 0.0,
  //       finaldiscount = 0.0,
  //       x = 0.0;
  //   var orderDetails = [];
  //   for (int i = 0; i < allModelData.length; i++) {
  //     subTotal += allModelData[i].amount!;
  //     totalDiscount +=
  //         (allModelData[i].discount! * allModelData[i].amount!) / 100;
  //     finaldiscount = (subTotal - totalDiscount);
  //     grandTotal += (finaldiscount - allModelData[i].amount!);
  //     x += allModelData[i].totalAfterDiscount!;
  //     log("grand toral hjgjhghjgjgh" + x.toString());
  //     orderDetails.add({
  //       "item": allModelData[i].id,
  //       "item_category": 8,
  //       "taxable": _taxable,
  //       "discountable": "true",
  //       "qty": allModelData[i].quantity,
  //       "purchase_cost": 0,
  //       "sale_cost": allModelData[i].price,
  //       "discount_rate": allModelData[i].discount,
  //       "discount_amount": allModelData[i].discountAmt,
  //       "tax_rate": _taxRate,
  //       "tax_amount": 0,
  //       "gross_amount": allModelData[i].amount,
  //       "net_amount": allModelData[i].totalAfterDiscount,
  //       "remarks": allModelData[i].remarks,
  //       "isNew": "true",
  //       "unique": "2ed54673-a7b4-489f-91a2-98abe79241ee",
  //       "cancelled": "false",
  //       "purchase_detail":_seletedBatch,
  //     });
  //   }
  //   log('subTotal' + subTotal.toString());
  //   log('totalDiscount' + totalDiscount.toString());
  //   log('grandTotal' + x.toString());
  //   final responseBody = {
  //     "status": 1,
  //     "customer": _selectedCustomer,
  //     "sub_total": subTotal,
  //     "total_discount": totalDiscount,
  //     "total_tax": 0,
  //     "grand_total": x,
  //     "remarks": "",
  //     "total_discountable_amount": subTotal,
  //     "total_taxable_amount": 0,
  //     "total_non_taxable_amount": x,
  //     "discount_scheme": '',
  //     "discount_rate": 0,
  //     "delivery_location": locationController.text,
  //     "delivery_date_ad": dateController.text == ""?null:dateController.text,
  //     "order_details": orderDetails,
  //   };
  //   log(json.encode(responseBody));
  //   final response = await http.post(
  //       Uri.parse(ApiConstant.baseUrl+ApiConstant.saveCustomerOrderByBatch),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
  //       },
  //       //ApiConstant.baseUrl + ApiConstant.saveCustomerOrder
  //       body: json.encode(responseBody));
  //   log(response.body);
  //   if (response.statusCode == 201) {
  //     qtyController.clear();
  //     pricecontroller.clear();
  //     discountPercentageController.clear();
  //     DataCell.empty;
  //   } else if (response.statusCode == 400) {
  //     Fluttertoast.showToast(msg: response.body.toString());
  //   }
  //
  //   return response;
  // }
}



