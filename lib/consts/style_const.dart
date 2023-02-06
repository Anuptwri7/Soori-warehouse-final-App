import 'package:flutter/material.dart';

const kTextStyleWhite = TextStyle(fontSize: 19.0, color: Colors.white);
const kTextStyleBlack = TextStyle(fontSize: 16.0, color: Colors.black);
const kTextStyleSmall = TextStyle(fontSize: 16.0, color: Colors.white);
const kTextBlackSmall = TextStyle(fontSize: 16.0, color: Colors.black);
const kHintTextStyle = TextStyle(color: Colors.black54, fontSize: 19.0);

const kHeightVeryBig = SizedBox(
  height: 15,
);
const kHeightBig = SizedBox(
  height: 24,
);
const kHeightMedium = SizedBox(
  height: 16,
);
const kHeightSmall = SizedBox(
  height: 8,
);
const kHeightVerySmall = SizedBox(
  height: 4,
);

/*Card Designes*/
const kCardElevation = 8.0;
var kCardRoundedShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));

const kMarginPaddMedium = EdgeInsets.all(16.0);
const kMarginPaddSmall = EdgeInsets.all(8.0);

const kLabelStyle = TextStyle(color: Colors.white, fontSize: 16.0);

const kLoginTextStyle = TextStyle(
  color: kTopGradient,
  fontSize: 48.0,
  fontWeight: FontWeight.bold,
);

const kTopGradient = Color(0xFF295A77);
const kBottomGradient = Color(0xFF51B4EE);
const kAppBarColor = Color(0xFF5DB9EF);
const kBottomGradientTwo = Color(0xFF00000029);
const kBottomGradientThree = Color(0x00948E8E);

const kFormFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  labelStyle: TextStyle(color: Colors.grey,fontSize: 14),
  hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
  hintText: 'Enter a Value',
  contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
  border: OutlineInputBorder(

    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

const kFormFieldDecorationBlack = InputDecoration(

  labelStyle: kTextStyleBlack,
  hintStyle: kTextStyleBlack,
  hintText: 'Enter a Value',
  contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black54, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

var kFormBoxDecoration = BoxDecoration(

  border: Border.all(color: Colors.white, width: 3.0),
  borderRadius: BorderRadius.all(Radius.circular(8.0)),
  color: Colors.white
);

var kSerialFormDecoration = BoxDecoration(
  border: Border.all(
    color: Colors.black,
  ),
  shape: BoxShape.rectangle,
  borderRadius: BorderRadius.all(Radius.circular(8.0)),
);

const kopenScannerDecoration = InputDecoration(
  // labelStyle: kHintTextStyle,
  hintStyle: kHintTextStyle,
  contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);
