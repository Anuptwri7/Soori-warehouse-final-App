import 'package:flutter/cupertino.dart';

class VerifiedController extends ChangeNotifier {
  List<String> serialId = [];
  List<int> index = [];

  updateSerialId({required List<String> newSerialId}) {
    serialId = newSerialId;
    notifyListeners();
  }

  updateIndex({required int pk}) {
    index.add(pk);
    notifyListeners();
  }
}
