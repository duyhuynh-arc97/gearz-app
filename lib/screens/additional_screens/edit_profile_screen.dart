import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/additional_contact_controller.dart';
import 'package:itproject_gadget_store/controllers/address_controller.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/auth.config.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/models/additional_contact.dart';
import 'package:itproject_gadget_store/models/city.dart';
import 'package:itproject_gadget_store/models/district.dart';
import 'package:itproject_gadget_store/models/user.dart';
import 'package:itproject_gadget_store/models/ward.dart';
import 'package:itproject_gadget_store/screens/recover_pass/otp_verify_screen.dart';
import 'package:itproject_gadget_store/widgets/common_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  final bool? fromCartScreen;
  const EditProfileScreen({Key? key, this.fromCartScreen}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _wardController;
  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserController _userController = Get.find();
  AddressController _addressAPIController = Get.find();
  AdditionalContactController _contactController = Get.find();

  List<District> _districts = [];
  List<Ward> _wards = [];

  late City? _selectedCity;
  late District? _selectedDtr;
  late Ward? _selectedWard;

  List<City> _foundCity = [];
  List<District> _foundDistrict = [];
  List<Ward> _foundWard = [];

  late EmailAuth _emailAuth;

  @override
  void initState() {
    super.initState();
    _emailAuth = new EmailAuth(sessionName: "GearZ");
    _emailAuth.config(remoteServerConfiguration);

    _selectedCity = _userController.user.value.city;
    _selectedDtr = _userController.user.value.district;
    _selectedWard = _userController.user.value.ward;

    _nameController =
        TextEditingController(text: _userController.user.value.fullName);
    _nameController.addListener(() {
      setState(() {});
    });

    _phoneController =
        TextEditingController(text: _userController.user.value.phone);
    _phoneController.addListener(() {
      setState(() {});
    });

    _addressController =
        TextEditingController(text: _userController.user.value.addressLine);
    _addressController.addListener(() {
      setState(() {});
    });

    _cityController = TextEditingController(
        text: _userController.user.value.city == null
            ? ""
            : _userController.user.value.city!.name);
    _cityController.addListener(() {
      setState(() {});
    });

    _districtController = TextEditingController(
        text: _userController.user.value.district == null
            ? ""
            : _userController.user.value.district!.name);
    _districtController.addListener(() {
      setState(() {});
    });

    _wardController = TextEditingController(
        text: _userController.user.value.ward == null
            ? ""
            : _userController.user.value.ward!.name);
    _wardController.addListener(() {
      setState(() {});
    });

    setState(() {
      _foundCity = _addressAPIController.cities;
      _foundDistrict = _districts;
      _foundWard = _wards;
    });
  }

  //Check valid phone and email in forgot-pass screen
  String? _phoneCheck(value) {
    if (value.toString().isEmpty) {
      return "Please fill in your phone number.";
    }
    if (RegExp(r'^-?[0-9]+$').hasMatch(value.toString().trim())) {
      if (!RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(value.toString().trim())) {
        return "Invalid phone number.";
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Ionicons.chevron_back_outline,
                color: Colors.black,
                size: 24 * screenScale(context),
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            this.widget.fromCartScreen == false
                ? "Edit profile"
                : "Add home contact",
            style: TextStyle(
                color: Colors.black, fontSize: 20 * fontScale(context)),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.fromLTRB(30 * screenScale(context), 0,
                    30 * screenScale(context), 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _nameField(),
                    _phoneField(),
                    _searchCity(),
                    _searchDistrict(),
                    _searchWard(),
                    _addressField(),
                    _updateBtn(),
                    widget.fromCartScreen == false
                        ? _changePassBtn(context)
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Search bar for city
  Widget _searchCity() {
    return Container(
      margin: EdgeInsets.only(top: 15 * screenScale(context)),
      child: TextFormField(
        controller: _cityController,
        style: TextStyle(fontSize: 16 * fontScale(context)),
        validator: MultiValidator(
            [RequiredValidator(errorText: "Please choose a city / province.")]),
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (context) => StatefulBuilder(builder: (context, setState) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Get.back(),
                child: DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  builder: (_, controller) => Container(
                    padding: EdgeInsets.fromLTRB(
                        10 * screenScale(context),
                        10 * screenScale(context),
                        10 * screenScale(context),
                        0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20 * screenScale(context)),
                      ),
                    ),
                    child: Column(
                      children: [
                        Divider(
                          thickness: 4 * screenScale(context),
                          color: Colors.grey.shade300,
                          endIndent: 170 * screenScale(context),
                          indent: 170 * screenScale(context),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15, top: 5),
                          child: Text("Select a city",
                              style: TextStyle(
                                  fontSize: 18 * fontScale(context),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 10 * screenScale(context)),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            style: TextStyle(fontSize: 16 * fontScale(context)),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      7 * screenScale(context))),
                              contentPadding: EdgeInsets.only(
                                  top: 10 * screenScale(context)),
                              hintText: 'Search',
                              prefixIcon: Icon(
                                Ionicons.search_outline,
                                size: 24 * screenScale(context),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _foundCity = _addressAPIController.cities
                                    .where((city) =>
                                        city.name.toLowerCase().contains(value))
                                    .toList();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: _foundCity.isNotEmpty
                              ? ListView.builder(
                                  itemCount: _foundCity.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(_foundCity[index].name,
                                          style: TextStyle(
                                              fontSize:
                                                  16 * screenScale(context))),
                                      onTap: () {
                                        setState(() {
                                          _selectedCity = _foundCity[index];
                                          _foundCity =
                                              _addressAPIController.cities;
                                        });
                                        this.setState(() {
                                          _cityController.text =
                                              _selectedCity!.name;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      top: 50 * screenScale(context)),
                                  child: Text("No data.",
                                      style: TextStyle(
                                          fontSize: 16 * fontScale(context))),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
        readOnly: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context)),
              borderSide: BorderSide(color: Colors.grey.shade500)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          contentPadding: EdgeInsets.only(
              top: 10 * screenScale(context), left: 10 * screenScale(context)),
          hintText: 'City / Province',
          suffixIconConstraints:
              BoxConstraints(maxWidth: 40 * screenScale(context)),
          suffixIcon: Container(
            width: 40 * screenScale(context),
            alignment: Alignment.center,
            child: Icon(
              Ionicons.chevron_down_outline,
              size: 24 * screenScale(context),
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  //Search bar for district
  Widget _searchDistrict() {
    return Container(
      margin: EdgeInsets.only(top: 15 * screenScale(context)),
      child: TextFormField(
        controller: _districtController,
        style: TextStyle(fontSize: 16 * fontScale(context)),
        validator: MultiValidator(
            [RequiredValidator(errorText: "Please choose a district.")]),
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (context) => StatefulBuilder(builder: (context, setState) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _foundDistrict = [];
                  Get.back();
                },
                child: DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  builder: (_, controller) => Container(
                    padding: EdgeInsets.fromLTRB(
                        10 * screenScale(context),
                        10 * screenScale(context),
                        10 * screenScale(context),
                        0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20 * screenScale(context)),
                      ),
                    ),
                    child: _selectedCity!.id == 0
                        ? Center(
                            child: Text(
                              "Please choose a city/province first.",
                              style: TextStyle(
                                  fontSize: 16 * screenScale(context)),
                            ),
                          )
                        : FutureBuilder(
                            future: _addressAPIController
                                .getDistricts(_selectedCity!.id),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.grey));
                              }
                              _districts = snapshot.data;
                              return Column(
                                children: [
                                  Divider(
                                    thickness: 4 * screenScale(context),
                                    color: Colors.grey.shade300,
                                    endIndent: 170 * screenScale(context),
                                    indent: 170 * screenScale(context),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 15 * screenScale(context),
                                        top: 5 * screenScale(context)),
                                    child: Text("Select a district",
                                        style: TextStyle(
                                            fontSize: 18 * fontScale(context),
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 10 * screenScale(context)),
                                    child: TextFormField(
                                      keyboardType: TextInputType.name,
                                      style: TextStyle(
                                          fontSize: 16 * fontScale(context)),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                7 * screenScale(context))),
                                        contentPadding: EdgeInsets.only(
                                            top: 10 * screenScale(context)),
                                        hintText: 'Search',
                                        prefixIcon: Icon(
                                            Ionicons.search_outline,
                                            size: 24 * screenScale(context)),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _foundDistrict = _districts
                                              .where((d) => d.name
                                                  .toLowerCase()
                                                  .contains(value))
                                              .toList();
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: _foundDistrict.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: _foundDistrict.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(
                                                    _foundDistrict[index].name,
                                                    style: TextStyle(
                                                        fontSize: 16 *
                                                            screenScale(
                                                                context))),
                                                onTap: () {
                                                  setState(() {
                                                    _selectedDtr =
                                                        _foundDistrict[index];
                                                    _foundDistrict = _districts;
                                                  });
                                                  this.setState(() {
                                                    _districtController.text =
                                                        _selectedDtr!.name;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          )
                                        : snapshot.data.length == 0
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: 50 *
                                                        screenScale(context)),
                                                child: Text(
                                                  "No data.",
                                                  style: TextStyle(
                                                      fontSize: 16 *
                                                          screenScale(context)),
                                                ),
                                              )
                                            : ListView.builder(
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(
                                                        snapshot
                                                            .data[index].name,
                                                        style: TextStyle(
                                                            fontSize: 16 *
                                                                screenScale(
                                                                    context))),
                                                    onTap: () {
                                                      setState(() {
                                                        _selectedDtr = snapshot
                                                            .data[index];
                                                      });
                                                      this.setState(() {
                                                        _districtController
                                                                .text =
                                                            _selectedDtr!.name;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  );
                                                },
                                              ),
                                  ),
                                ],
                              );
                            }),
                  ),
                ),
              );
            }),
          );
        },
        readOnly: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context)),
              borderSide: BorderSide(color: Colors.grey.shade500)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          contentPadding: EdgeInsets.only(
              top: 10 * screenScale(context), left: 10 * screenScale(context)),
          hintText: 'District',
          suffixIconConstraints:
              BoxConstraints(maxWidth: 40 * screenScale(context)),
          suffixIcon: Container(
            width: 40 * screenScale(context),
            alignment: Alignment.center,
            child: Icon(
              Ionicons.chevron_down_outline,
              size: 24 * screenScale(context),
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  //Search bar for district
  Widget _searchWard() {
    return Container(
      margin: EdgeInsets.only(top: 15 * screenScale(context)),
      child: TextFormField(
        controller: _wardController,
        style: TextStyle(fontSize: 16 * fontScale(context)),
        validator: MultiValidator(
            [RequiredValidator(errorText: "Please choose a ward / commune.")]),
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (context) => StatefulBuilder(builder: (context, setState) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _foundWard = [];
                  Get.back();
                },
                child: DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  builder: (_, controller) => Container(
                    padding: EdgeInsets.fromLTRB(
                        10 * screenScale(context),
                        10 * screenScale(context),
                        10 * screenScale(context),
                        0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20 * screenScale(context)),
                      ),
                    ),
                    child: _selectedDtr!.id == 0
                        ? Center(
                            child: Text(
                              "Please choose a district first.",
                              style: TextStyle(
                                  fontSize: 16 * screenScale(context)),
                            ),
                          )
                        : FutureBuilder(
                            future: _addressAPIController
                                .getWards(_selectedDtr!.id),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.grey));
                              }
                              _wards = snapshot.data;
                              return Column(
                                children: [
                                  Divider(
                                    thickness: 4 * screenScale(context),
                                    color: Colors.grey.shade300,
                                    endIndent: 170 * screenScale(context),
                                    indent: 170 * screenScale(context),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 15 * screenScale(context),
                                        top: 5 * screenScale(context)),
                                    child: Text("Select a ward",
                                        style: TextStyle(
                                            fontSize: 18 * fontScale(context),
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 10 * screenScale(context)),
                                    child: TextFormField(
                                      keyboardType: TextInputType.name,
                                      style: TextStyle(
                                          fontSize: 16 * fontScale(context)),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                7 * screenScale(context))),
                                        contentPadding: EdgeInsets.only(
                                            top: 10 * fontScale(context)),
                                        hintText: 'Search',
                                        prefixIcon: Icon(
                                          Ionicons.search_outline,
                                          size: 24 * screenScale(context),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _foundWard = _wards
                                              .where((w) => w.name
                                                  .toLowerCase()
                                                  .contains(value))
                                              .toList();
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: _foundWard.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: _foundWard.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(
                                                    _foundWard[index].name,
                                                    style: TextStyle(
                                                        fontSize: 16 *
                                                            screenScale(
                                                                context))),
                                                onTap: () {
                                                  setState(() {
                                                    _selectedWard =
                                                        _foundWard[index];
                                                    _foundWard = _wards;
                                                  });
                                                  this.setState(() {
                                                    _wardController.text =
                                                        _selectedWard!.name;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          )
                                        : snapshot.data.length == 0
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: 50 *
                                                        screenScale(context)),
                                                child: Text(
                                                  "No data.",
                                                  style: TextStyle(
                                                      fontSize: 16 *
                                                          screenScale(context)),
                                                ),
                                              )
                                            : ListView.builder(
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(
                                                        snapshot
                                                            .data[index].name,
                                                        style: TextStyle(
                                                            fontSize: 16 *
                                                                screenScale(
                                                                    context))),
                                                    onTap: () {
                                                      setState(() {
                                                        _selectedWard = snapshot
                                                            .data[index];
                                                        // _foundWard = _wards;
                                                      });
                                                      this.setState(() {
                                                        _wardController.text =
                                                            _selectedWard!.name;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  );
                                                },
                                              ),
                                  ),
                                ],
                              );
                            }),
                  ),
                ),
              );
            }),
          );
        },
        readOnly: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context)),
              borderSide: BorderSide(color: Colors.grey.shade500)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          contentPadding: EdgeInsets.only(
              top: 10 * screenScale(context), left: 10 * screenScale(context)),
          hintText: 'Ward / Commune',
          suffixIconConstraints:
              BoxConstraints(maxWidth: 40 * screenScale(context)),
          suffixIcon: Container(
            width: 40 * screenScale(context),
            alignment: Alignment.center,
            child: Icon(
              Ionicons.chevron_down_outline,
              size: 24 * screenScale(context),
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  //Name textfield
  Widget _nameField() {
    return Container(
      margin: EdgeInsets.only(top: 10 * screenScale(context)),
      child: TextFormField(
        autofocus: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _nameController,
        keyboardType: TextInputType.name,
        validator: MultiValidator([
          RequiredValidator(errorText: "Please fill in your full name."),
        ]),
        style: TextStyle(fontSize: 16 * fontScale(context)),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          contentPadding: EdgeInsets.only(
              top: 10 * screenScale(context), left: 10 * screenScale(context)),
          hintText: 'Full name',
          suffixIconConstraints: BoxConstraints(
              maxWidth: 40 * screenScale(context),
              maxHeight: 40 * screenScale(context)),
          suffixIcon: _nameController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: Icon(
                    Ionicons.close_outline,
                    size: 24 * screenScale(context),
                  ),
                  onPressed: () {
                    _nameController.clear();
                  },
                ),
          errorMaxLines: 2,
        ),
      ),
    );
  }

  //Address line textfield
  Widget _phoneField() {
    return Container(
      margin: EdgeInsets.only(top: 15 * screenScale(context)),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _phoneController,
        keyboardType: TextInputType.number,
        validator: _phoneCheck,
        style: TextStyle(fontSize: 16 * fontScale(context)),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          contentPadding: EdgeInsets.only(
              top: 10 * screenScale(context), left: 10 * screenScale(context)),
          hintText: 'Phone',
          suffixIconConstraints: BoxConstraints(
              maxWidth: 40 * screenScale(context),
              maxHeight: 40 * screenScale(context)),
          suffixIcon: _phoneController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: Icon(
                    Ionicons.close_outline,
                    size: 24 * screenScale(context),
                  ),
                  onPressed: () {
                    _phoneController.clear();
                  },
                ),
          prefixIcon: Container(
            child: Text("+84",
                style: TextStyle(fontSize: 16 * fontScale(context))),
            margin: EdgeInsets.only(
                top: 10 * screenScale(context),
                bottom: 10 * screenScale(context),
                right: 10 * screenScale(context)),
            width: 50 * screenScale(context),
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 2 * screenScale(context)),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.shade500),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Addressline textfield
  Widget _addressField() {
    return Container(
      margin: EdgeInsets.only(top: 15 * screenScale(context)),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _addressController,
        keyboardType: TextInputType.name,
        validator: MultiValidator([
          RequiredValidator(errorText: "Please fill in your address line."),
        ]),
        style: TextStyle(fontSize: 16 * fontScale(context)),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          contentPadding: EdgeInsets.only(
              top: 10 * screenScale(context), left: 10 * screenScale(context)),
          hintText: 'Address line',
          suffixIconConstraints: BoxConstraints(
              maxWidth: 40 * screenScale(context),
              maxHeight: 40 * screenScale(context)),
          suffixIcon: _addressController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: Icon(
                    Ionicons.close_outline,
                    size: 24 * screenScale(context),
                  ),
                  onPressed: () {
                    _addressController.clear();
                  },
                ),
        ),
      ),
    );
  }

  //Update button
  Widget _updateBtn() {
    return Container(
      height: 45 * screenScale(context),
      width: double.infinity,
      margin: EdgeInsets.only(
          top: 50 * screenScale(context), bottom: 10 * screenScale(context)),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            _userController
                .updateInfo(
                    inputUser: User(
                        id: _userController.user.value.id,
                        fullName: _nameController.text,
                        mail: _userController.user.value.mail,
                        password: _userController.user.value.password,
                        addressLine: _addressController.text,
                        phone: _phoneController.text,
                        enabled: 1,
                        city: _selectedCity,
                        district: _selectedDtr,
                        ward: _selectedWard,
                        createdTime: _userController.user.value.createdTime))
                .then((value) {
              if (value == true) {
                setState(() {
                  _isLoading = false;
                });

                int _count = 0;
                openSuccessMessageDialog(
                    context: context,
                    title: "Information was updated!",
                    mainText:
                        "Your new information has been updated. You can continue enjoying the app.",
                    additionalText: "",
                    iconName: "success.png",
                    action: () {
                      _contactController.updateDeliveryContact(
                          contact: AdditionalContact(
                              userId: _userController.user.value.id,
                              name: _nameController.text,
                              addressLine: _addressController.text,
                              ward: _selectedWard,
                              district: _selectedDtr,
                              city: _selectedCity,
                              phone: _phoneController.text,
                              isDefault: 0));
                      Navigator.popUntil(context, (route) {
                        return _count++ == 2;
                      });
                    });
              } else {
                print("smth wrong");
              }
            });
          } else {
            _isLoading == false;
            print("not good at all...");
          }
        },
        child: _isLoading == false
            ? Text(widget.fromCartScreen == false ? 'Update' : "Add",
                style: TextStyle(
                    fontSize: 17 * fontScale(context),
                    fontWeight: FontWeight.w900,
                    color: Colors.white))
            : loadingText("Please wait", context),
        style: ElevatedButton.styleFrom(
          primary: Color(hexColor("#346ec9")),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
        ),
      ),
    );
  }

  //Change password button
  Widget _changePassBtn(BuildContext context) {
    return Container(
      height: 45 * screenScale(context),
      width: double.infinity,
      margin: EdgeInsets.only(
          top: 5 * screenScale(context), bottom: 10 * screenScale(context)),
      child: ElevatedButton(
        onPressed: () {
          sendOTP(_emailAuth, _userController.user.value.mail);
          Get.to(() => OtpVerifyScreen(
                fromProfileScreen: true,
                fromStartScreen: false,
                fullName: _userController.user.value.fullName,
                mail: _userController.user.value.mail,
                password: _userController.user.value.password,
              ));
        },
        child: Text('Change password',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17 * fontScale(context),
                fontWeight: FontWeight.w900,
                color: Color(hexColor("#346ec9")))),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(hexColor("#346ec9")), width: 2),
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          primary: Colors.white,
        ),
      ),
    );
  }
}
