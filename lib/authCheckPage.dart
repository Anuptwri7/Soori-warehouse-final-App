
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/ui/login/login_screen.dart';
import 'package:soori_warehouse/ui/my_homepage.dart';

class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({Key? key}) : super(key: key);

  @override
  _AuthCheckPageState createState() => _AuthCheckPageState();
}

class _AuthCheckPageState extends State<AuthCheckPage> {

  @override
  void initState() {
    checkRefresh();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image(
            image: AssetImage("assets/images/logo.png"),
          ),
        ),
      ),

    );

  }
  Future<void> checkRefresh() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    log(pref.getString('refresh_token').toString());
    var response = await http.post(
      Uri.parse(StringConst.baseUrl + StringConst.refreshToken),
      body: ({
        'refresh': pref.getString('refresh_token').toString(),
      }),
    );
    // log(response.body);
    try {
      if (response.statusCode == 200) {
        pref.setString("access_token", json.decode(response.body)['access']);
      } else if (response.statusCode == 401) {
        pref.clear();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) =>LoginScreen()));
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

