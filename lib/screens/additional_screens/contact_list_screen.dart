import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/additional_contact_controller.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/models/additional_contact.dart';

import 'modify_contact_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  AdditionalContactController _contactController = Get.find();
  UserController _userController = Get.find();
  List<AdditionalContact> contactList = [];

  @override
  void initState() {
    super.initState();
    contactList = _contactController.contactList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Additional contacts",
          style:
              TextStyle(color: Colors.black, fontSize: 20 * fontScale(context)),
        ),
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Ionicons.chevron_back_outline,
              color: Colors.black,
              size: 24 * screenScale(context),
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (_contactController.contactList.length == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300 * screenScale(context),
                  child: Text(
                    "Your have no additional contact. \n Add some additional contacts so we can deliver to you in case you're not at home.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey, fontSize: 14 * fontScale(context)),
                  ),
                ),
                SizedBox(
                  height: 40 * screenScale(context),
                  width: 150 * screenScale(context),
                  child: MaterialButton(
                    onPressed: () => Get.to(() => ModifyContactScreen()),
                    textColor: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.add_square,
                          color: Colors.blue,
                          size: 24 * screenScale(context),
                        ),
                        Text(
                          " Add contact",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14 * fontScale(context)),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(5 * screenScale(context)),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5 * screenScale(context))),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.only(
              right: 10 * screenScale(context),
              left: 10 * screenScale(context)),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 10 * screenScale(context)),
                itemBuilder: (context, index) => Slidable(
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              Get.to(() => ModifyContactScreen(
                                    contact:
                                        _contactController.contactList[index],
                                  )),
                          backgroundColor: Colors.blue.shade400,
                          foregroundColor: Colors.white,
                          icon: Iconsax.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            _contactController
                                .removeContact(
                                    userId: _userController.user.value.id,
                                    name: _contactController
                                        .contactList[index].name)
                                .then((value) => {
                                      if (value == "successful")
                                        {
                                          Get.snackbar(
                                            "Removed!",
                                            "You've just remove a contact. Double check in Your profile.",
                                            dismissDirection:
                                                DismissDirection.horizontal,
                                            colorText: Colors.white,
                                            snackStyle: SnackStyle.FLOATING,
                                            barBlur: 30,
                                            backgroundColor: Colors.black45,
                                            isDismissible: true,
                                            duration: Duration(seconds: 3),
                                          ),
                                          setState(() {
                                            _contactController.contactList
                                                .removeAt(index);
                                          }),
                                        }
                                      else
                                        {print("nah")}
                                    });
                          },
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          icon: Iconsax.trash,
                          label: 'Remove',
                        ),
                      ],
                    ),
                    child: Obx(
                      () => GestureDetector(
                        onTap: () {
                          _contactController.updateDeliveryContact(
                              contact: AdditionalContact(
                                  userId: _userController.user.value.id,
                                  name: _contactController
                                      .contactList[index].name,
                                  addressLine: _contactController
                                      .contactList[index].addressLine,
                                  ward: _contactController
                                      .contactList[index].ward,
                                  district: _contactController
                                      .contactList[index].district,
                                  city: _contactController
                                      .contactList[index].city,
                                  phone: _contactController
                                      .contactList[index].phone,
                                  isDefault: 0));

                          Get.back();
                        },
                        child: _contactCard(
                            name: _contactController.contactList[index].name,
                            address: _contactController
                                    .contactList[index].addressLine +
                                ", " +
                                _contactController
                                    .contactList[index].ward!.name +
                                ", " +
                                _contactController
                                    .contactList[index].district!.name +
                                ", " +
                                _contactController
                                    .contactList[index].city!.name,
                            phone: _contactController.contactList[index].phone),
                      ),
                    )),
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: _contactController.contactList.length,
              ),
              GestureDetector(
                onTap: () {
                  _contactController.updateDeliveryContact(
                      contact: AdditionalContact(
                          userId: _userController.user.value.id,
                          name: _userController.user.value.fullName,
                          addressLine: _userController.user.value.addressLine,
                          ward: _userController.user.value.ward,
                          district: _userController.user.value.district,
                          city: _userController.user.value.city,
                          phone: _userController.user.value.phone,
                          isDefault: 0));

                  Get.back();
                },
                child: _contactCard(
                    name: _userController.user.value.fullName,
                    address: _userController.user.value.addressLine +
                        ", " +
                        _userController.user.value.ward!.name +
                        ", " +
                        _userController.user.value.district!.name +
                        ", " +
                        _userController.user.value.city!.name,
                    phone: _userController.user.value.phone),
              ),
              SizedBox(height: 10 * screenScale(context)),
              _navigateBtn(
                  context: context,
                  action: "Add contact",
                  icon: Iconsax.add_square,
                  path: ModifyContactScreen())
            ],
          ),
        );
      }),
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
            Icon(
              icon,
              color: Colors.blue,
              size: 24 * screenScale(context),
            ),
            SizedBox(width: 5 * screenScale(context)),
            Text(
              action,
              style: TextStyle(color: Colors.blue),
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

  //Address card
  Container _contactCard(
      {required String name, required String address, required String phone}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: Colors.white),
      padding: EdgeInsets.all(10 * screenScale(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Iconsax.location5,
            size: 24 * screenScale(context),
            color: Colors.blue,
          ),
          SizedBox(width: 10 * screenScale(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 16 * fontScale(context),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20 * screenScale(context)),
                    Text(
                      phone,
                      style: TextStyle(fontSize: 14 * fontScale(context)),
                    ),
                  ],
                ),
                Text(
                  address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14 * fontScale(context)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
