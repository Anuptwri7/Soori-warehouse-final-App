import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../consts/string_const.dart';
import '../model/notificationCount.dart';

class NotificationServices {
  Future fetchNotification() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String finalUrl = sharedPreferences.getString("subDomain").toString();

    final response = await http.get(
      Uri.parse('https://$finalUrl/${StringConst.allNotification}' ),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
      },
    );
    // log(response.body);
    try {
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future readAll() async {
    NotificationCountModel? notificationCountModel;

    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String finalUrl = sharedPreferences.getString("subDomain").toString();


    try {
      final response = await http.get(
          Uri.parse("https://$finalUrl/${StringConst.readAllNotification}"
          ),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
          });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        notificationCountModel = NotificationCountModel.fromJson(data);
      } else {
        log("Something went wrong");
      }
    } catch (e) {
      log(e.toString());
    }

    return notificationCountModel;
  }
}

Future OpenNotification(String id) async {
  log("This is OpenNotification  id :::$id");
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  String finalUrl = sharedPreferences.getString("subDomain").toString();

  final response = await http.post(
      Uri.parse('https://$finalUrl/${StringConst.notificationReceive}' ),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
      },
      body: json.encode({
        "id": id,
      }));

  try {
    if (response.statusCode == 201) {
      return response.body;
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future getCount(context) async {
  NotificationCountModel? notificationCountModel;

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  String finalUrl = sharedPreferences.getString("subDomain").toString();


  try {
    final response = await http.get(
        Uri.parse('https://$finalUrl/${StringConst.notificationCount}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
        });
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      notificationCountModel = NotificationCountModel.fromJson(data);
    } else {
      log("Something went wrong");
    }
  } catch (e) {
    log(e.toString());
  }

  return notificationCountModel;
}

// }
