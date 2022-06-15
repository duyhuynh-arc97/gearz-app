import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/additional_contact_controller.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/order_controller.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/screens/additional_screens/cancellation_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/modify_contact_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/edit_profile_screen.dart';
import 'package:itproject_gadget_store/screens/start/start_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/to_pay_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/to_receive_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/to_review_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserController _userController = Get.find();
  Color _cardColor = Color(hexColor("#f7f7f7"));
  double _appbarHeight = 0;

  AdditionalContactController _contactController = Get.find();
  OrderController _orderController = Get.find();

  _convertTime(DateTime time) {
    List _month = [
      "Jan",
      "Feb",
      "March",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    List _dayinweek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    var mon = _month[time.month - 1].toString();
    var dayinweek = _dayinweek[time.weekday - 1].toString();
    var day = time.day.toString();
    var year = time.year.toString();

    return dayinweek + ", " + mon + " " + day + " " + year;
  }

  late File _profilePic;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _profilePic = File("");
  }

  Future _pickImg(ImageSource source) async {
    try {
      final pickedimage = await ImagePicker().pickImage(source: source);
      setState(() {
        _profilePic = File(pickedimage!.path);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return Dialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300 * screenScale(context),
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20 * screenScale(context)),
                          child: Image.file(_profilePic,
                              width: double.infinity, fit: BoxFit.cover),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (await _uploadImg() == true) {
                                Get.snackbar(
                                  "Photo updated!",
                                  "Your profile picture has been updated. You can check in Your profile.",
                                  colorText: Colors.white,
                                  snackStyle: SnackStyle.FLOATING,
                                  barBlur: 30,
                                  backgroundColor: Colors.black45,
                                  isDismissible: true,
                                  duration: Duration(seconds: 3),
                                  dismissDirection: DismissDirection.horizontal,
                                );

                                setState(() {
                                  _isLoading = false;
                                });

                                Navigator.pop(context);
                                _userController.user.value.profilePic =
                                    _profilePic.path.split("/").last;
                                _userController.update();
                              } else {
                                setState(() {
                                  _isLoading = false;
                                  openCustomizedAlertDialog(
                                      context: context,
                                      title: "Something was wrong!",
                                      mainText:
                                          "Your profile picture could not be updated. Please try again.",
                                      additionalText: "",
                                      iconName: "error.png");
                                });
                              }
                            },
                            textColor: Colors.white,
                            splashColor: Colors.white24,
                            child: Row(
                              children: [
                                _isLoading == false
                                    ? Icon(
                                        Ionicons.checkmark_outline,
                                        size: 30 * screenScale(context),
                                      )
                                    : SizedBox(
                                        height: 20 * screenScale(context),
                                        width: 20 * screenScale(context),
                                        child: CircularProgressIndicator(
                                          strokeWidth:
                                              2.5 * screenScale(context),
                                          color: Colors.white,
                                        ),
                                      ),
                              ],
                            ),
                            elevation: 0,
                          ),
                          MaterialButton(
                            onPressed: () => Navigator.pop(context),
                            textColor: Colors.white,
                            splashColor: Colors.white24,
                            child: Row(
                              children: [
                                Icon(
                                  Ionicons.close_outline,
                                  size: 30 * screenScale(context),
                                ),
                              ],
                            ),
                            elevation: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        );
      });
    } on PlatformException catch (e) {
      print("Have a error: ${e}");
    }
  }

  _uploadImg() async {
    final url =
        Uri.parse("https://gearz-gadget.000webhostapp.com/upload_pic.php");
    var req = http.MultipartRequest('POST', url);
    var pic = await http.MultipartFile.fromPath("file", _profilePic.path);
    req.fields["userId"] = _userController.user.value.id.toString();
    req.files.add(pic);
    var res = await req.send();
    if (res.statusCode == 200) {
      print("success");
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [_customizedAppBar()];
              },
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10 * screenScale(context)),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10 * screenScale(context)),
                        decoration: BoxDecoration(
                            border: Border.all(color: _cardColor),
                            borderRadius: BorderRadius.all(
                                Radius.circular(20 * screenScale(context))),
                            color: _cardColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 5 * screenScale(context),
                                  right: 5 * screenScale(context)),
                              child: Text(
                                "Your orders",
                                style: TextStyle(
                                    fontSize: 16 * fontScale(context),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 15 * screenScale(context)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _toPayCard(),
                                _toRecieveCard(),
                                _toReviewCard(),
                                _cancellationCard(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10 * screenScale(context)),
                      _commonInfoField(
                          title: "Full name",
                          info: _userController.user.value.fullName),
                      SizedBox(height: 10 * screenScale(context)),
                      _commonInfoField(
                          title: "Email",
                          info: _userController.user.value.mail),
                      SizedBox(height: 10 * screenScale(context)),
                      _commonInfoField(
                          title: "Phone number",
                          info: _userController.user.value.phone),
                      SizedBox(height: 10 * screenScale(context)),
                      _commonInfoField(
                          title: "Join date",
                          info: _convertTime(
                              _userController.user.value.createdTime)),
                      SizedBox(height: 10 * screenScale(context)),
                      _commonInfoField(
                          title: "Address line",
                          info: _userController.user.value.addressLine),
                      SizedBox(height: 10 * screenScale(context)),
                      _commonInfoField(
                          title: "City",
                          info: _userController.user.value.city == null
                              ? ""
                              : _userController.user.value.city!.name),
                      SizedBox(height: 10 * screenScale(context)),
                      _commonInfoField(
                          title: "District",
                          info: _userController.user.value.district == null
                              ? ""
                              : _userController.user.value.district!.name),
                      SizedBox(height: 10 * screenScale(context)),
                      _commonInfoField(
                          title: "Ward",
                          info: _userController.user.value.ward == null
                              ? ""
                              : _userController.user.value.ward!.name),
                      SizedBox(height: 10 * screenScale(context)),
                      Container(
                        padding: EdgeInsets.all(10 * screenScale(context)),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10 * screenScale(context))),
                            color: Color(hexColor("#f7f7f7"))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 5 * screenScale(context),
                                      right: 5 * screenScale(context)),
                                  child: Text(
                                    "Additional contacts:",
                                    style: TextStyle(
                                        fontSize: 16 * fontScale(context),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                _contactController.contactList.length > 0
                                    ? SizedBox(
                                        height: 40 * screenScale(context),
                                        width: 150 * screenScale(context),
                                        child: MaterialButton(
                                          onPressed: () => Get.to(
                                              () => ModifyContactScreen()),
                                          textColor: Colors.black,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Iconsax.add_square,
                                                color: Colors.blue,
                                                size: 15 * screenScale(context),
                                              ),
                                              Text(
                                                " Add contact",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 14 *
                                                        fontScale(context)),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(
                                              5 * screenScale(context)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5 *
                                                      screenScale(context))),
                                          elevation: 0,
                                        ),
                                      )
                                    : Text(""),
                              ],
                            ),
                            SizedBox(height: 10 * screenScale(context)),
                            Obx(() {
                              if (_contactController.isLoading == false) {
                                if (_contactController.contactList.length ==
                                    0) {
                                  return Center(
                                    child: _navigateBtn(
                                        context: context,
                                        action: "Add contact",
                                        icon: Iconsax.add_square,
                                        path: ModifyContactScreen()),
                                  );
                                }
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(top: 0),
                                  itemBuilder: (context, index) => Slidable(
                                    endActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) =>
                                              Get.to(() => ModifyContactScreen(
                                                    contact: _contactController
                                                        .contactList[index],
                                                  )),
                                          backgroundColor: Colors.blue.shade400,
                                          foregroundColor: Colors.white,
                                          icon: Iconsax.edit,
                                          label: 'Edit',
                                        ),
                                        SlidableAction(
                                          onPressed: (context) {
                                            openCustomizedAlertDialog2(
                                                context: context,
                                                title: "Remove contact!",
                                                mainText:
                                                    "Are you sure that you want to ",
                                                additionalText: "this contact?",
                                                iconName: "error.png",
                                                importantText: "remove ",
                                                okAction: () {
                                                  _contactController
                                                      .removeContact(
                                                          userId:
                                                              _userController
                                                                  .user
                                                                  .value
                                                                  .id,
                                                          name:
                                                              _contactController
                                                                  .contactList[
                                                                      index]
                                                                  .name)
                                                      .then((value) => {
                                                            if (value ==
                                                                "successful")
                                                              {
                                                                Get.back(),
                                                                Get.snackbar(
                                                                  "Removed!",
                                                                  "You've just remove a contact. Double check in Your profile.",
                                                                  dismissDirection:
                                                                      DismissDirection
                                                                          .horizontal,
                                                                  colorText:
                                                                      Colors
                                                                          .white,
                                                                  snackStyle:
                                                                      SnackStyle
                                                                          .FLOATING,
                                                                  barBlur: 30,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black45,
                                                                  isDismissible:
                                                                      true,
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              3),
                                                                ),
                                                                setState(() {
                                                                  _contactController
                                                                      .contactList
                                                                      .removeAt(
                                                                          index);
                                                                }),
                                                              }
                                                            else
                                                              {print("nah")}
                                                          });
                                                });
                                          },
                                          backgroundColor: Colors.red.shade400,
                                          foregroundColor: Colors.white,
                                          icon: Iconsax.trash,
                                          label: 'Remove',
                                        ),
                                      ],
                                    ),
                                    child: _contactCard(index: index),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                          height: 10 * screenScale(context)),
                                  itemCount:
                                      _contactController.contactList.length,
                                );
                              } else {
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(top: 0),
                                  itemBuilder: (context, index) =>
                                      _shimmerCard(),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                          height: 10 * screenScale(context)),
                                  itemCount: 2,
                                );
                              }
                            })
                          ],
                        ),
                      ),
                      SizedBox(height: 10 * screenScale(context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [_editBtn(context), _logoutBtn(context)],
                      )
                    ],
                  ),
                ),
              )),
        ));
  }

  //Shimmer card
  Container _shimmerCard() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: Colors.white),
      padding: EdgeInsets.all(10 * screenScale(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.fromColors(
              child: Container(
                height: 24 * screenScale(context),
                width: 24 * screenScale(context),
                color: Colors.grey.shade200,
              ),
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade100),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Shimmer.fromColors(
                        child: Container(
                          height: 20 * screenScale(context),
                          width: 70 * screenScale(context),
                          color: Colors.grey.shade200,
                        ),
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade100),
                    SizedBox(width: 20 * screenScale(context)),
                    Shimmer.fromColors(
                        child: Container(
                          height: 20 * screenScale(context),
                          width: 70 * screenScale(context),
                          color: Colors.grey.shade200,
                        ),
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade100),
                  ],
                ),
                SizedBox(height: 5 * screenScale(context)),
                Shimmer.fromColors(
                    child: Container(
                      height: 45 * screenScale(context),
                      color: Colors.grey.shade200,
                    ),
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100),
              ],
            ),
          )
        ],
      ),
    );
  }

  //To card
  GestureDetector _toPayCard() {
    return GestureDetector(
      onTap: () => Get.to(() => ToPayScreen()),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius:
                BorderRadius.all(Radius.circular(10 * screenScale(context))),
            color: Colors.white),
        padding: EdgeInsets.all(10 * screenScale(context)),
        child: Column(
          children: [
            Obx(() {
              var _check = 0;
              if (_orderController.myOrders.length > 0) {
                if (_orderController.myOrders
                        .where((p0) => p0.status == "PAID")
                        .toList()
                        .length <
                    _orderController.myOrders.length) {
                  _check = 1;
                } else {
                  _check = 0;
                }
              } else {
                _check = 0;
              }

              if (_check != 0) {
                return Badge(
                  child: Icon(
                    Ionicons.wallet_outline,
                    color: Colors.blue,
                    size: 24 * screenScale(context),
                  ),
                );
              }
              return Icon(
                Ionicons.wallet_outline,
                color: Colors.blue,
                size: 24 * screenScale(context),
              );
            }),
            Text(
              "To pay",
              style: TextStyle(fontSize: 12 * fontScale(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  //To recieve card
  GestureDetector _toRecieveCard() {
    return GestureDetector(
      onTap: () => Get.to(() => ToReceiveScreen()),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius:
                BorderRadius.all(Radius.circular(10 * screenScale(context))),
            color: Colors.white),
        padding: EdgeInsets.all(10 * screenScale(context)),
        child: Column(
          children: [
            Obx(() {
              var _count = 0;
              for (var i in _orderController.myOrders) {
                if (i.finalTrack.status == "PACKAGED" ||
                    i.finalTrack.status == "PICKED" ||
                    i.finalTrack.status == "SHIPPING") {
                  _count++;
                }
              }
              if (_count > 0) {
                return Badge(
                  child: Icon(
                    Iconsax.truck,
                    color: Colors.blue,
                    size: 24 * screenScale(context),
                  ),
                );
              }
              return Icon(
                Iconsax.truck,
                color: Colors.blue,
                size: 24 * screenScale(context),
              );
            }),
            Text(
              "To receive",
              style: TextStyle(fontSize: 12 * fontScale(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  //cancellation card
  GestureDetector _cancellationCard() {
    return GestureDetector(
      onTap: () => Get.to(() => CancellationScreen()),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius:
                BorderRadius.all(Radius.circular(10 * screenScale(context))),
            color: Colors.white),
        padding: EdgeInsets.all(10 * screenScale(context)),
        child: Column(
          children: [
            Icon(
              Iconsax.card_remove,
              color: Colors.blue,
              size: 24 * screenScale(context),
            ),
            Text(
              "Cancellations",
              style: TextStyle(fontSize: 12 * fontScale(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  //To review card
  GestureDetector _toReviewCard() {
    return GestureDetector(
      onTap: () => Get.to(() => ToReviewScreen()),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius:
                BorderRadius.all(Radius.circular(10 * screenScale(context))),
            color: Colors.white),
        padding: EdgeInsets.all(10 * screenScale(context)),
        child: Column(
          children: [
            Obx(() {
              if (_orderController.unratedProducts.length > 0) {
                return Badge(
                  child: Icon(
                    Iconsax.message,
                    color: Colors.blue,
                    size: 24 * screenScale(context),
                  ),
                );
              }
              return Icon(
                Iconsax.message,
                color: Colors.blue,
                size: 24 * screenScale(context),
              );
            }),
            Text(
              "To review",
              style: TextStyle(fontSize: 12 * fontScale(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  //Navigation button
  SizedBox _navigateBtn(
      {required BuildContext context,
      required String action,
      required IconData icon,
      required Widget path}) {
    return SizedBox(
      height: 40 * screenScale(context),
      width: 150 * screenScale(context),
      child: MaterialButton(
        onPressed: () => Get.to(() => path),
        textColor: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue),
            SizedBox(width: 5 * screenScale(context)),
            Text(
              action,
              style: TextStyle(
                  color: Colors.blue, fontSize: 14 * fontScale(context)),
            ),
          ],
        ),
        padding: EdgeInsets.all(5 * screenScale(context)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5 * screenScale(context))),
        elevation: 0,
      ),
    );
  }

  //Logout button
  Widget _logoutBtn(BuildContext context) {
    return Container(
      height: 45 * screenScale(context),
      width: 180 * screenScale(context),
      child: ElevatedButton(
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("mail");
          Get.deleteAll();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => StartScreen(initPage: 1)));
          Get.snackbar("Log out!", "You just got out the store, see you soon.",
              colorText: Colors.white,
              snackStyle: SnackStyle.FLOATING,
              barBlur: 30,
              backgroundColor: Colors.black45,
              isDismissible: true,
              duration: Duration(seconds: 3),
              dismissDirection: DismissDirection.horizontal);
        },
        child: Text('Log out',
            style: TextStyle(
                fontSize: 17 * fontScale(context),
                fontWeight: FontWeight.w900,
                color: Color(hexColor("#346ec9")))),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Color(hexColor("#346ec9")),
                  width: 2 * screenScale(context)),
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          primary: Colors.white,
        ),
      ),
    );
  }

  //Edit profile button
  Widget _editBtn(BuildContext context) {
    return Container(
      height: 45 * screenScale(context),
      width: 180 * screenScale(context),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => EditProfileScreen(fromCartScreen: false));
        },
        child: Text('Edit profile',
            style: TextStyle(
                fontSize: 17 * fontScale(context),
                fontWeight: FontWeight.w900,
                color: Colors.white)),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          primary: Color(hexColor("#346ec9")),
        ),
      ),
    );
  }

  //Contact card
  Container _contactCard({required int index}) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius:
                BorderRadius.all(Radius.circular(10 * screenScale(context))),
            color: Colors.white),
        padding: EdgeInsets.all(10 * screenScale(context)),
        child: Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Iconsax.location5,
                size: 24 * screenScale(context),
                color: Colors.blue,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _contactController.contactList[index].name,
                          style: TextStyle(
                              fontSize: 16 * fontScale(context),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 20 * screenScale(context)),
                        Text(_contactController.contactList[index].phone),
                      ],
                    ),
                    Text(
                      _contactController.contactList[index].addressLine +
                          ", " +
                          _contactController.contactList[index].ward!.name +
                          ", " +
                          _contactController.contactList[index].district!.name +
                          ", " +
                          _contactController.contactList[index].city!.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14 * fontScale(context)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  //Customized appbar
  SliverAppBar _customizedAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      pinned: true,
      elevation: 0,
      expandedHeight: 280 * screenScale(context),
      flexibleSpace: LayoutBuilder(builder: (context, constraints) {
        _appbarHeight = constraints.biggest.height;
        return Obx(() => FlexibleSpaceBar(
              centerTitle: true,
              title: _appbarHeight < 100 * screenScale(context)
                  ? Text(
                      "Your profile",
                      style: TextStyle(color: Colors.black),
                    )
                  : null,
              background: Stack(
                children: [
                  SizedBox(
                    height: 450 * screenScale(context),
                    width: double.infinity,
                    child: Stack(
                      children: [
                        _userController.user.value.profilePic != ""
                            ? Image.network(
                                _userController.user.value.profilePic
                                            .split("/")
                                            .first ==
                                        "https:"
                                    ? _userController.user.value.profilePic
                                    : "https://gearz-gadget.000webhostapp.com/profile_pics/${_userController.user.value.profilePic}",
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Image.asset(
                                "assets/images/user.png",
                                fit: BoxFit.cover,
                                height: 450 * screenScale(context),
                                width: double.infinity,
                              ),
                        Positioned(
                            bottom: 10 * screenScale(context),
                            left: 10 * screenScale(context),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  10 * screenScale(context),
                                  5 * screenScale(context),
                                  10 * screenScale(context),
                                  5 * screenScale(context)),
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(
                                      10 * screenScale(context))),
                              child: Text(
                                _userController.user.value.fullName,
                                style: TextStyle(
                                    letterSpacing: 1.5 * fontScale(context),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20 * fontScale(context)),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 10 * screenScale(context),
                      right: 10 * screenScale(context),
                      child: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            textStyle: TextStyle(
                                fontSize: 15 * fontScale(context),
                                color: Colors.black,
                                fontFamily: 'OpenSans'),
                            onTap: () {
                              _pickImg(ImageSource.gallery);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.gallery,
                                  size: 20 * screenScale(context),
                                ),
                                SizedBox(width: 10 * screenScale(context)),
                                Text("Select photo"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            textStyle: TextStyle(
                                fontSize: 15 * fontScale(context),
                                color: Colors.black,
                                fontFamily: 'OpenSans'),
                            onTap: () {
                              _pickImg(ImageSource.camera);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Ionicons.camera_outline,
                                  size: 22 * screenScale(context),
                                ),
                                SizedBox(width: 10 * screenScale(context)),
                                Text("Camera"),
                              ],
                            ),
                          ),
                        ],
                        child: Container(
                          height: 40 * screenScale(context),
                          width: 40 * screenScale(context),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Ionicons.camera_outline,
                            size: 24 * screenScale(context),
                            color: Colors.white,
                          ),
                        ),
                      )),
                ],
              ),
            ));
      }),
    );
  }

  //Common information field
  Container _commonInfoField({required String title, required String info}) {
    return Container(
      padding: EdgeInsets.all(15 * screenScale(context)),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: Color(hexColor("#f7f7f7"))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${title}: ",
            style: TextStyle(
                fontSize: 16 * fontScale(context), fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10 * screenScale(context)),
          info != ""
              ? Text(
                  info,
                  style: TextStyle(fontSize: 15 * fontScale(context)),
                )
              : Text(
                  "-- No data --",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                      fontSize: 14 * fontScale(context)),
                ),
        ],
      ),
    );
  }
}
