import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:soori_warehouse/branch/model/branchModel.dart';
import 'package:soori_warehouse/branch/services/branchServices.dart';
import 'package:soori_warehouse/consts/buttons_const.dart';
import 'package:soori_warehouse/consts/images_const.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/string_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/data/model/branches_model.dart';
import 'package:soori_warehouse/data/network/network_helper.dart';
import 'package:soori_warehouse/ui/my_homepage.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // late LoginReturnModel userLogin;
  late BranchesModel branchesModel;
  String dropdownvalueUser = 'Select Branch';
  bool showSpinner = false;
  var username, password;
  bool obsecureTextState = true;
  IconData showPasswordIcon = Icons.remove_red_eye;
  final _loginFormKey = GlobalKey<FormState>();
  var dropdownValue = StringConst.selectBranch;
  var checkedValue = false;
  late http.Response response;
  late SharedPreferences prefs;
  int? _selecteduser;


  // late ArsProgressDialog progressDialog;
  List<String> dropDownBranches = [];
  var subDomain = '';
  @override
  void initState() {
    // TODO: implement initState
    // progressDialog = loadProgressBar(context);
    // loadBranches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff86a2d7),
                    Color(0xff3667d4),
                  ],
                ),
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,

            ),
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: kMarginPaddMedium,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    Text(
                      StringConst.loginWelcome,
                      style: kLoginTextStyle.copyWith(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      StringConst.loginText,
                      style: TextStyle(fontSize: 12,color: Colors.white),
                    ),
                    kHeightVeryBig,
                    kHeightMedium,
                    Form(

                      key: _loginFormKey,
                      child: Column(
                        children: [
                          // Container(
                          //
                          //   margin: EdgeInsets.all(4.0),
                          //   padding: EdgeInsets.all(4.0),
                          //   decoration: kFormBoxDecoration,
                          //   child: DropdownButton<String>(
                          //     dropdownColor: Colors.white,
                          //     hint: Text(StringConst.selectBranch,
                          //         style: TextStyle(color: Colors.white)),
                          //     value: dropdownValue,
                          //     elevation: 24,
                          //     isExpanded: true,
                          //     style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontSize: 12),
                          //     underline: Container(
                          //       height: 0,
                          //       color: Colors.blue,
                          //     ),
                          //     onChanged: (newValue) {
                          //       setState(() {
                          //         print("New Drop Down Value: $newValue");
                          //         dropdownValue = newValue!;
                          //       });
                          //     },
                          //     items: dropDownBranches
                          //         .map<DropdownMenuItem<String>>(
                          //             (String value) {
                          //       return DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(
                          //           value,
                          //           style: TextStyle(color: Colors.grey,fontSize: 14),
                          //         ),
                          //       );
                          //     }).toList(),
                          //     iconSize: 24.0,
                          //     icon: Icon(
                          //       Icons.arrow_drop_down_circle,
                          //       color: Colors.grey,
                          //     ),
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.all(4.0),
                            padding: EdgeInsets.all(4.0),
                            decoration: kFormBoxDecoration,
                            width: MediaQuery.of(context).size.width,

                            child: FutureBuilder(

                              future: fetchBranchFromUrl(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {

                                if(snapshot.hasError){

                                  return Text("Loading");
                                }
                                if (snapshot.hasData) {
                                  try {
                                    final List<Result> snapshotData = snapshot.data;
                                    return DropdownButton<Result>(
                                      elevation: 24,
                                      isExpanded: true,
                                      hint: Text("${dropdownvalueUser.isEmpty?"Select Branch":dropdownvalueUser}"),
                                      // value: snapshotData.first,
                                      iconSize: 24.0,
                                      icon: Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: Colors.grey,
                                      ),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.white,
                                      ),
                                      items: snapshotData
                                          .map<DropdownMenuItem<Result>>((Result items) {
                                        return DropdownMenuItem<Result>(
                                          value: items,
                                          child: Text(items.name.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (Result? newValue) {
                                        setState(
                                              () {
                                            dropdownvalueUser = newValue!.name.toString();
                                            _selecteduser = newValue.id;
                                            subDomain = newValue.subDomain.toString();
                                            log("--------------------------------"+_selecteduser.toString());
                                            log("--------------------------------"+subDomain.toString());
                                          },
                                        );
                                      },
                                    );
                                  } catch (e) {
                                    throw Exception(e);
                                  }
                                } else {
                                  return Text(snapshot.error.toString());
                                }
                              },
                            ),
                          ),
                          kHeightVeryBig,

                          TextFormField(
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Name';
                              }
                            },
                            cursorColor: Color(0xff3667d4),
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              username = value;
                            },
                            style: TextStyle(color: Colors.grey),
                            decoration: kFormFieldDecoration.copyWith(

                              hintText: StringConst.userName,
                              prefixIcon: const Icon(
                                Icons.person_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          kHeightVeryBig,
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Password';
                              }
                            },
                            style: TextStyle(color: Colors.grey),
                            obscureText: obsecureTextState,
                            cursorColor: Color(0xff3667d4),
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: kFormFieldDecoration.copyWith(
                                hintText: StringConst.password,
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (obsecureTextState != false) {
                                        obsecureTextState = true;
                                        showPasswordIcon = Icons.remove_red_eye;
                                      } else {
                                        obsecureTextState = true;
                                        showPasswordIcon =
                                            Icons.remove_red_eye_outlined;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    showPasswordIcon,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    kHeightSmall,
                    Container(
                      color: Colors.transparent,
                      child: CheckboxListTile(
                        title: Text(
                          StringConst.rememberMe,
                          style: kTextStyleWhite.copyWith(fontSize: 16.0),
                        ),
                        value: checkedValue,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                    kHeightMedium,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(

                        primary: Colors.white,
                      ),

                        onPressed: ()=>login(),
                        child: Text("Login",style: TextStyle(color: Color(0xff3667d4),fontSize: 14,fontWeight: FontWeight.bold),)
                    ),
                    kHeightMedium,
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
  Future<void> login() async {
    List<String> getCodeName =[];
    List<String> getSuperUser = [];
    log("http://${subDomain}/api/v1/login");
    var response = await http.post(
      Uri.parse('https://${subDomain}/api/v1/user-app/login'),
      body: ({
        'user_name': username,
        'password': password,
      }),
    );
log(response.body);
log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sharedPreferences.setString("access_token",
          json.decode(response.body)['tokens']['access'] ?? '#');
      sharedPreferences.setString("refresh_token",
          json.decode(response.body)['tokens']['refresh'] ?? '#');
      sharedPreferences.setString("user_name",
          json.decode(response.body)['user_name'] ?? '#');
      sharedPreferences.setString("subDomain" , subDomain);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    } else {
      Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }


/*  addUserCredentialsToSF(uName, uid, bearerToken, userRole, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.setString('BearerAuthToken', bearerToken);
    prefs.setString('UserID', uid);
    prefs.setString('Username', uName);
    prefs.setString('UserRole', userRole);
    prefs.setBool('is_verified', true);
    prefs.setString('UserEmail', email);

    var firebaseToken;

    bearerToken = 'Bearer $bearerToken';
    print('Token : $bearerToken');
    print('Uid : $uid');
    print('Firebase Token : $firebaseToken');

    http.Response response = await NetworkHelper('token')
        .sendDeviceToken(bearerToken, uid, firebaseToken);

    print('LoginPage Response :${response.body.toString()}');
  }*/

  // Future loadBranches() async {
  //   response = await http.get(Uri.parse(StringConst.branchUrl));
  //   printResponseCode(response);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     List<dynamic> branches = jsonDecode(response.body.toString());
  //     dropDownBranches.clear();
  //     dropDownBranches.add(StringConst.selectBranch);
  //     subDomain = branches.first["sub_domain"];
  //     if (!subDomain.contains("http")) {
  //       // subDomain = 'http://' + subDomain;
  //       subDomain = 'http://' + subDomain;
  //     }
  //     for (var branch in branches) {
  //       dropDownBranches.add(branch["name"]);
  //     }
  //     setState(() {});
  //   } else {
  //     displayToast(msg: 'Something went wrong, Please Open The App Again');
  //   }
  // }

  Future newUserLogin(username, password, dropdownValue) async {
    String finalUrl = prefs.getString(StringConst.subDomain).toString();

    response = await NetworkHelper('${subDomain}/api/v1/user-app/login')
        .userLogin(username, password);

    printResponseCode(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sharedPreferences.setString("access_token",
          json.decode(response.body)['tokens']['access'] ?? '#');
      sharedPreferences.setString("refresh_token",
          json.decode(response.body)['tokens']['refresh'] ?? '#');
      sharedPreferences.setString("user_name",
          json.decode(response.body)['user_name'] ?? '#');

      Map<String, dynamic> loginDetails = jsonDecode(response.body.toString());

      String userAccessToken = loginDetails['tokens']['access'];
      prefs.setString(StringConst.bearerAuthToken, userAccessToken);

      replacePage(HomePage(), context);
    } else {

      // displayToast(msg: 'Something went wrong, Please Try Again');
    }
  }

  submitUserDetails() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    log(response.body);
    // prefs.setString(StringConst.subDomain, subDomain);
    // prefs.setString(StringConst.subDomain, subDomain);

    if (_loginFormKey.currentState!.validate()) {
       {
        newUserLogin(
          username,
          password,
          dropdownValue,
        );

        if (checkedValue == true) {
          prefs.setString(StringConst.userName, username);
          prefs.setString(StringConst.password, password);
        }
      }
    }
  }
}
