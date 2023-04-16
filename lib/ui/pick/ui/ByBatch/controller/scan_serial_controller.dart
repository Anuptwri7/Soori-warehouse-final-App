import 'package:flutter/cupertino.dart';

class SerialController with ChangeNotifier {
  List<String> serialCode = [];
  List<String> serialId = [];
  var customer_packing_types = [];
  List<String> scannnedPK = [];

  updateSerialCode({required List<String> newSerialCode}) {
    serialCode = newSerialCode;
    notifyListeners();
  }

  updateSerialId({required List<String> newSerialId}) {
    serialId = newSerialId;
    notifyListeners();
  }

  updatePackId(
      {required String Id,
      required List<dynamic> sale_packing_type_detail_code}) {
    customer_packing_types.add({
      "packing_type_code": Id,
      "sale_packing_type_detail_code": sale_packing_type_detail_code
    });

    notifyListeners();
  }

  updateIndex({required String pk}) {
    scannnedPK.add(pk);
    notifyListeners();
  }
}
