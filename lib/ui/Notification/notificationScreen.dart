// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shimmer/shimmer.dart';
//
// import 'model/allNotification.dart';
// import 'services/notification_services.dart';
//
// class NotificationPage extends StatefulWidget {
//   const NotificationPage({Key? key}) : super(key: key);
//
//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage> {
//   NotificationServices notificationServices = NotificationServices();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.white,
//           title: const Text(
//             "All Notification",
//             style: TextStyle(
//                 color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: GestureDetector(
//                 onTap: () {
//                   notificationServices.readAll();
//                   // Navigator.pushReplacement(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //         builder: (context) => const MainScreen()));
//                 },
//                 child: const Text(
//                   "Mark all as read",
//                   style: TextStyle(fontSize: 15, color: Colors.black),
//                 ),
//               ),
//             ),
//           ]),
//       body: FutureBuilder(
//         future: notificationServices.fetchNotification(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasData) {
//             try {
//               final snapshotData = json.decode(snapshot.data);
//               AllNotificationModel allNotificationModel =
//                   AllNotificationModel.fromJson(snapshotData);
//
//               return ListView.builder(
//                   // scrollDirection: Axis.vertical,
//                   physics: const ScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: allNotificationModel.count,
//                   itemBuilder: (BuildContext context, int index) {
//                     return ListTile(
//                       leading:
//                           allNotificationModel.results![index].isRead == true
//                               ? const FaIcon(
//                                   FontAwesomeIcons.solidEnvelopeOpen,
//                                   color: Colors.green,
//                                 )
//                               : const FaIcon(
//                                   FontAwesomeIcons.solidEnvelope,
//                                   color: Colors.red,
//                                 ),
//                       title: Text(
//                           allNotificationModel.results![index].msg.toString()),
//                       subtitle: Text(allNotificationModel
//                           .results![index].createdDateAd
//                           .toString()),
//                       onTap: () => allNotificationModel.results![index].isRead ==
//                               false
//                           ? OpenNotification(
//                               allNotificationModel
//                                   .results![index].notificationId
//                                   .toString(),
//                             ).whenComplete(() =>
//                               allNotificationModel.results![index].notificationType == "customer-order"
//                                   ? Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               const CustomerOrderListScreen()))
//                                   : Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               const StockAnalysisPage())))
//                           : allNotificationModel.results![index].notificationType ==
//                                   "customer-order"
//                               ? Navigator.pushReplacement(
//                                   context, MaterialPageRoute(builder: (context) => const CustomerOrderListScreen()))
//                               : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StockAnalysisPage())),
//                     );
//                   });
//             } catch (e) {
//               throw Exception(e);
//             }
//           } else {
//             return Opacity(
//               opacity: 0.8,
//               child: Shimmer.fromColors(
//                   child: const SizedBox(
//                     child: Text(
//                       'Loading All Order .....',
//                       style: TextStyle(fontSize: 18, color: Colors.grey),
//                     ),
//                   ),
//                   baseColor: Colors.grey,
//                   highlightColor: Colors.white),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
