import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';

goToPage(BuildContext context, dynamic myPage) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => myPage));
}

void replacePage(dynamic currentPage, context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => currentPage),
    (Route<dynamic> route) => false,
  );

  void replaceCurrentPage(dynamic currentPage, context) {
    Navigator.popUntil(
      context,
      currentPage,
    );
  }

  /*Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => currentPage));*/
}

void displayToast({String? msg}) {
  Fluttertoast.showToast(
      msg: msg!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:Color(0xff424143),
      fontSize: 16.0);
}

void displayToastSuccess({String? msg}) {
  Fluttertoast.showToast(
      msg: msg!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xff424143),
      fontSize: 16.0);
}

getMainUrl() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString(StringConst.subDomain).toString();
}

loadBearerToken() async {
  final prefs = await SharedPreferences.getInstance();
  String accessToken = prefs.getString('BearerAuthToken') ?? '';
  String bearerToken = 'Bearer ' + accessToken;
  return bearerToken;
}

printResponse(response) {
  print("Response : ${jsonDecode(response.body.toString())}");
}

printResponseCode(response) {
  print("Response Code: ${response.statusCode}");
}

dropdownIcon() {
  return const Icon(
    Icons.arrow_drop_down_circle,
    color: Colors.black54,
  );
}

hideDropDownLine() {
  return Container(
    height: 0,
    color: Colors.white,
  );
}

ProgressDialog initProgressDialog(context) {
  return ProgressDialog(context: context);
}

/*Show More or Less Text*/
showMorePickUpLocations(String textToDisplay) {
  return ReadMoreText(
    textToDisplay,
    trimLines: 3,
    colorClickableText: Colors.pink,
    trimMode: TrimMode.Line,
    trimCollapsedText: 'Show more',
    trimExpandedText: 'Show less',
    style: kTextBlackSmall,
    moreStyle: kTextBlackSmall.copyWith(fontWeight: FontWeight.bold),
    lessStyle: kTextBlackSmall.copyWith(fontWeight: FontWeight.bold),
  );
}

smallShowMorePickUpLocations(String textToDisplay) {
  return ReadMoreText(
    textToDisplay,
    trimLines: 3,
    colorClickableText: Colors.pink,
    trimMode: TrimMode.Line,
    trimCollapsedText: 'Show more',
    delimiterStyle: kTextBlackSmall.copyWith(
      fontWeight: FontWeight.bold,
    ),
    trimExpandedText: 'Show less',
    style: kTextBlackSmall,
    moreStyle:
        kTextBlackSmall.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),
    lessStyle:
        kTextBlackSmall.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),
  );
}

/*Show More or Less Text*/
showMoreBatchNo(String textToDisplay) {
  return ReadMoreText(
    textToDisplay,
    trimLines: 1,
    colorClickableText: Colors.pink,
    trimMode: TrimMode.Line,
    trimCollapsedText: 'Show more',
    trimExpandedText: 'Show less',
    style: kTextBlackSmall,
    moreStyle: kTextBlackSmall.copyWith(fontWeight: FontWeight.bold),
    lessStyle: kTextBlackSmall.copyWith(fontWeight: FontWeight.bold),
  );
}

smallShowMoreBatchNo(String textToDisplay) {
  return ReadMoreText(
    textToDisplay,
    trimLines: 2,
    colorClickableText: Colors.pink,
    trimMode: TrimMode.Line,
    trimCollapsedText: 'Show more',
    delimiterStyle: kTextBlackSmall.copyWith(
      fontWeight: FontWeight.bold,
    ),
    trimExpandedText: 'Show less',
    style: kTextBlackSmall,
    moreStyle:
        kTextBlackSmall.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),
    lessStyle:
        kTextBlackSmall.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),
  );
}
