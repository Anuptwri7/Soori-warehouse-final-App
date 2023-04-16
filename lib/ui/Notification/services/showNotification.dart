import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;


Future notificationBackground() async {
  final response =
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'key=AAAAwyMkRNY:APA91bGJ2eyg5pzPP_1ezreQGN2I1Nj0_D3z073C3ji-moO86gArSYecYEoGuZcluzynqxp6N4gvpC9j-Q4zfM4w0KFZMnjtfM-kTd8mOP6djS4IEDutOY814yPun_DT25_LnAmsV6bJ'
          },
          body: json.encode({
            "registration_ids": [
              "eHRP4ABQRM2Rh6YaNlzC6f:APA91bFTDoMjLuEG07viZVLY0gP44wK4wFRigNwEkO7829hlQajEB20C6jRil3Uon2ZB-W_XGP27XqrJq15fcr84ZqiRceNfU9vBi6K0XwFAd6Ye-dMm6a1IGdxeXER9NG0RkXJfcw61"
            ],
            "notification": {
              "body": "Customer Create",
              "title": "notification",
              "sound": true
            }
          }));

  try {
    if (response.statusCode == 200) {
      return response.body;
    }
  } catch (e) {
    throw Exception(e);
  }
}


