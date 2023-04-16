import 'package:flutter/material.dart';
import 'package:soori_warehouse/consts/methods_const.dart';
import 'package:soori_warehouse/consts/style_const.dart';
import 'package:soori_warehouse/ui/audit/scan_audit_items.dart';

class POAudit extends StatefulWidget {
  const POAudit({Key? key}) : super(key: key);

  @override
  _POAuditState createState() => _POAuditState();
}

class _POAuditState extends State<POAudit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Scan Items'),
        backgroundColor: Color(0xff2c51a4),
      ),
      body: ListView(
        children: [
          kHeightBig,
          const Center(
            child: Text(
              'Scan Items',
              style: kTextStyleBlack,
            ),
          ),
          kHeightBig,
          Card(
            margin: kMarginPaddSmall,
            color: Colors.white,
            elevation: kCardElevation,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              padding: kMarginPaddSmall,
              child: Column(
                children: [
                  kHeightSmall,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            iconSize: 48,
                            color: Colors.lightBlue,
                            icon: const Icon(
                              Icons.qr_code,
                            ),
                            onPressed: () => scanAuditItems()),
                        _purchaseOrderIcons(
                          Icons.print,
                          Colors.black12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _purchaseOrderIcons(IconData iconImage, Color iconColor) {
    return IconButton(
      iconSize: 48,
      color: iconColor,
      icon: Icon(iconImage),
      onPressed: () {},
    );
  }

  scanAuditItems() {
    // goToPage(context, ScanAuditItems());
  }
}
