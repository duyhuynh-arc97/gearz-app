import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "There are no notifications.",
            style: TextStyle(
                color: Colors.grey, fontSize: 14 * fontScale(context)),
          ),
          Icon(
            Ionicons.notifications_off_outline,
            color: Colors.blue,
            size: 24 * screenScale(context),
          )
        ],
      ),
    );
  }
}
