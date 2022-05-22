import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/product_controller.dart';
import 'package:itproject_gadget_store/controllers/search.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/models/product.dart';
import 'package:itproject_gadget_store/screens/additional_screens/all_product_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/product_details_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/productbybanner_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/productbybrand_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/productbyctg_screen.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  Color _boxColor = Color(hexColor("#e3e3e3"));
  Color _cardColor = Color(hexColor("#f7f7f7"));
  Color _priceColor = Color(hexColor("#ff408d"));
  Color _bfdPriceColor = Colors.grey.shade500;

  ProductController _productController = Get.find();
  UserController _userController = Get.find();

  List _banner = [
    {
      "link":
          "https://cdn.alzashop.com/Foto/ImgGalery/Image/nintendo-switch-large.jpg",
      "caption": "Impressive Consoles"
    },
    {
      "link": "https://cdn.tgdd.vn/Files/2020/08/07/1277804/scar_800x450.jpg",
      "caption": "Modern\nGaming Monsters"
    },
    {
      "link":
          "https://i.pinimg.com/originals/dc/8f/91/dc8f9114aa983b9ff62e5439e59c389f.jpg",
      "caption": "Powerful Hardwares"
    },
    {
      "link":
          "https://www.cnet.com/a/img/tGXi1_LEJGrwtCvezfXqQ9xGxww=/940x0/2019/05/29/b6e1b398-a645-49e6-a60e-aa5fbf2c95ad/img-20190529-114728.jpg",
      "caption": "Stylish Laptops"
    },
    {
      "link":
          "https://www.reviewgeek.com/p/uploads/2021/10/3fdf84bb.jpg?width=1200",
      "caption": "And more..."
    }
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150 * screenScale(context),
          padding: EdgeInsets.fromLTRB(
              15 * screenScale(context),
              40 * screenScale(context),
              15 * screenScale(context),
              15 * screenScale(context)),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hi, ${_userController.user.value.fullName}!",
                    style: TextStyle(
                        fontSize: 18 * fontScale(context),
                        color: Color(hexColor("#004ab3")),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  Obx(
                    () => CircleAvatar(
                      radius: 20 * screenScale(context),
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: AssetImage("assets/images/user.png"),
                      foregroundImage: _userController.user.value.profilePic !=
                              ""
                          ? NetworkImage(_userController.user.value.profilePic
                                      .split("/")
                                      .first ==
                                  "https:"
                              ? _userController.user.value.profilePic
                              : "https://gearz-gadget.000webhostapp.com/profilepics/${_userController.user.value.profilePic}")
                          : null,
                    ),
                  )
                ],
              ),
              _searchBar(context),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10 * screenScale(context), 0,
                10 * screenScale(context), 10 * screenScale(context)),
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: _banner.length,
                  itemBuilder: (context, index, realIndex) {
                    if (index == 0) {}
                    return GestureDetector(
                        onTap: () => Get.to(
                            () => ProductByBannerScreen(fromBanner: index)),
                        child: _imgCard(
                            path: _banner[index]["link"],
                            cap: _banner[index]["caption"]));
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    height: 200 * screenScale(context),
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                  ),
                ),
                SizedBox(height: 15 * screenScale(context)),
                Container(
                  padding: EdgeInsets.only(
                      top: 10 * screenScale(context),
                      bottom: 10 * screenScale(context)),
                  decoration: BoxDecoration(
                      border: Border.all(color: _boxColor),
                      borderRadius: BorderRadius.all(
                          Radius.circular(20 * screenScale(context))),
                      color: _boxColor),
                  child: Column(
                    children: [
                      _headingLine(name: "Categories"),
                      SizedBox(height: 15 * screenScale(context)),
                      SizedBox(
                        height: 120 * screenScale(context),
                        child: Obx(
                          () => _productController.isLoadingC != true
                              ? ListView.separated(
                                  padding: EdgeInsets.only(
                                      right: 10 * screenScale(context),
                                      left: 10 * screenScale(context)),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Get.to(() =>
                                          ProductByCtgScreen(
                                              category: _productController
                                                  .categoryList
                                                  .where(
                                                      (p0) => p0.parent == null)
                                                  .toList()[index])),
                                      child: _categoryCard(
                                          name: _productController.categoryList
                                              .where((p0) => p0.parent == null)
                                              .toList()[index]
                                              .name,
                                          imgUrl: _productController
                                              .categoryList
                                              .where((p0) => p0.parent == null)
                                              .toList()[index]
                                              .image),
                                    );
                                  },
                                  itemCount: _productController.categoryList
                                      .where((p0) => p0.parent == null)
                                      .toList()
                                      .length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                          width: 10 * screenScale(context)),
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.only(
                                      right: 10 * screenScale(context),
                                      left: 10 * screenScale(context)),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Shimmer.fromColors(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: Colors.grey.shade200),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15 *
                                                      screenScale(context))),
                                              color: Colors.grey.shade200),
                                          height: 120 * screenScale(context),
                                          width: 180 * screenScale(context),
                                        ),
                                        baseColor: Colors.grey.shade200,
                                        highlightColor: Colors.grey.shade100);
                                  },
                                  itemCount: 3,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                          width: 10 * screenScale(context)),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15 * screenScale(context)),
                Container(
                  padding: EdgeInsets.only(
                      top: 10 * screenScale(context),
                      bottom: 10 * screenScale(context)),
                  decoration: BoxDecoration(
                      border: Border.all(color: _boxColor),
                      borderRadius: BorderRadius.all(
                          Radius.circular(20 * screenScale(context))),
                      color: _boxColor),
                  child: Column(
                    children: [
                      _headingLine(name: "Brands"),
                      SizedBox(height: 15 * screenScale(context)),
                      SizedBox(
                        height: 60 * screenScale(context),
                        child: Obx(
                          () => _productController.isLoadingB != true
                              ? ListView.separated(
                                  padding: EdgeInsets.only(
                                      right: 10 * screenScale(context),
                                      left: 10 * screenScale(context)),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Get.to(() =>
                                          ProductByBrandScreen(
                                              brand: _productController
                                                  .brandList[index])),
                                      child: _brandCard(
                                          imgUrl: _productController
                                              .brandList[index].logo),
                                    );
                                  },
                                  itemCount:
                                      _productController.brandList.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                          width: 10 * screenScale(context)),
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.only(
                                      right: 10 * screenScale(context),
                                      left: 10 * screenScale(context)),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Shimmer.fromColors(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: Colors.grey.shade200),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10 *
                                                      screenScale(context))),
                                              color: Colors.grey.shade200),
                                          height: 60 * screenScale(context),
                                          width: 117 * screenScale(context),
                                        ),
                                        baseColor: Colors.grey.shade200,
                                        highlightColor: Colors.grey.shade100);
                                  },
                                  itemCount: 4,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                          width: 10 * screenScale(context)),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15 * screenScale(context)),
                Container(
                  padding: EdgeInsets.only(
                      top: 10 * screenScale(context),
                      bottom: 10 * screenScale(context)),
                  decoration: BoxDecoration(
                      border: Border.all(color: _boxColor),
                      borderRadius: BorderRadius.all(
                          Radius.circular(20 * screenScale(context))),
                      color: _boxColor),
                  child: Column(
                    children: [
                      _headingLine(
                          name: "Most popular",
                          path: AllProductScreen(
                            isFrom: "MP",
                          ),
                          more10: _productController.popularProductList.length >
                              10),
                      SizedBox(height: 15 * screenScale(context)),
                      SizedBox(
                        height: 245 * screenScale(context),
                        child: Obx(
                          () => _productController.isLoadingP != true
                              ? ListView.separated(
                                  padding: EdgeInsets.only(
                                      right: 10 * screenScale(context),
                                      left: 10 * screenScale(context)),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailsScreen(
                                                      product: _productController
                                                              .popularProductList[
                                                          index]))),
                                      child: _productCard(
                                        product: _productController
                                            .popularProductList[index],
                                        tag: _productController
                                            .popularProductList[index].name,
                                      ),
                                    );
                                  },
                                  itemCount: _productController
                                              .popularProductList.length >
                                          10
                                      ? 10
                                      : _productController
                                          .popularProductList.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                          width: 10 * screenScale(context)),
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.only(
                                      right: 10 * screenScale(context),
                                      left: 10 * screenScale(context)),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Shimmer.fromColors(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: Colors.grey.shade200),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10 *
                                                      screenScale(context))),
                                              color: Colors.grey.shade200),
                                          height: 238 * screenScale(context),
                                          width: 180 * screenScale(context),
                                        ),
                                        baseColor: Colors.grey.shade200,
                                        highlightColor: Colors.grey.shade100);
                                  },
                                  itemCount: 2,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                          width: 10 * screenScale(context)),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15 * screenScale(context)),
                Container(
                  padding: EdgeInsets.only(top: 10 * screenScale(context)),
                  decoration: BoxDecoration(
                      border: Border.all(color: _boxColor),
                      borderRadius: BorderRadius.all(
                          Radius.circular(20 * screenScale(context))),
                      color: _boxColor),
                  child: Column(
                    children: [
                      _headingLine(
                          name: "All in store",
                          path: AllProductScreen(
                            isFrom: "AP",
                          ),
                          more10: true),
                      SizedBox(height: 5 * screenScale(context)),
                      Obx(() => _productController.isLoadingP == false
                          ? GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10 * screenScale(context),
                                mainAxisSpacing: 10 * screenScale(context),
                                mainAxisExtent: 245 * screenScale(context),
                              ),
                              shrinkWrap: true,
                              padding:
                                  EdgeInsets.all(10 * screenScale(context)),
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsScreen(
                                                product: _productController
                                                    .productList[index],
                                              ))),
                                  child: _productCard(
                                      product:
                                          _productController.productList[index],
                                      tag: _productController
                                          .productList[index]),
                                );
                              },
                              itemCount: 16,
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10 * screenScale(context),
                                mainAxisSpacing: 10 * screenScale(context),
                                mainAxisExtent: 245 * screenScale(context),
                              ),
                              shrinkWrap: true,
                              padding:
                                  EdgeInsets.all(10 * screenScale(context)),
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade200),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  15 * screenScale(context))),
                                          color: Colors.grey.shade200),
                                      height: 238 * screenScale(context),
                                      width: 180 * screenScale(context),
                                    ),
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.grey.shade100);
                              },
                              itemCount: 6,
                            ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  //Image card for slider
  Widget _imgCard({required String path, required String cap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20 * screenScale(context)),
      child: Stack(
        children: [
          Container(
            color: Colors.black,
            height: 200 * screenScale(context),
            width: 400 * screenScale(context),
            child: Opacity(
              opacity: 0.7,
              child: Image.network(
                path,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 30 * screenScale(context),
            left: 30 * screenScale(context),
            child: SizedBox(
              width: 250 * screenScale(context),
              child: Text(
                cap,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25 * fontScale(context),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  //Card for most popular products
  Widget _productCard({required Product product, required Object tag}) {
    return Container(
      height: 238 * screenScale(context),
      width: 180 * screenScale(context),
      decoration: BoxDecoration(
          border: Border.all(color: _boxColor),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: _cardColor),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10 * screenScale(context)),
            child: Container(
                color: Colors.white,
                width: 185 * screenScale(context),
                height: 130 * screenScale(context),
                child: Hero(
                  tag: tag,
                  child: Image.network(
                    product.mainImg,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          SizedBox(
            height: 108 * screenScale(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      10 * screenScale(context),
                      5 * screenScale(context),
                      10 * screenScale(context),
                      5 * screenScale(context)),
                  child: Text(
                    product.name,
                    maxLines: 2,
                    style: TextStyle(fontSize: 14 * fontScale(context)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10 * screenScale(context), 0,
                          10 * screenScale(context), 5 * screenScale(context)),
                      child: product.discount != 0
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("\$",
                                        style: TextStyle(
                                            fontSize: 11 * fontScale(context),
                                            color: _priceColor,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        (product.price -
                                                product.price *
                                                    product.discount /
                                                    100)
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 15 * fontScale(context),
                                            fontWeight: FontWeight.bold,
                                            color: _priceColor)),
                                  ],
                                ),
                                SizedBox(width: 5 * screenScale(context)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("\$",
                                        style: TextStyle(
                                            color: _bfdPriceColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11 * fontScale(context))),
                                    Text(product.price.toString(),
                                        style: TextStyle(
                                            fontSize: 15 * fontScale(context),
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: _bfdPriceColor)),
                                  ],
                                )
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\$",
                                    style: TextStyle(
                                        fontSize: 11 * fontScale(context),
                                        color: _priceColor,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    isInt(product.price)
                                        ? product.price.toStringAsFixed(0)
                                        : product.price.toString(),
                                    style: TextStyle(
                                        fontSize: 15 * fontScale(context),
                                        fontWeight: FontWeight.bold,
                                        color: _priceColor)),
                              ],
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(7 * screenScale(context), 0,
                          10 * screenScale(context), 10 * screenScale(context)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBar.builder(
                            itemBuilder: (context, _) =>
                                Icon(Iconsax.star1, color: Colors.amber),
                            onRatingUpdate: (value) {},
                            ignoreGestures: true,
                            initialRating: product.rating,
                            itemSize: 15 * screenScale(context),
                            allowHalfRating: true,
                            unratedColor: Colors.grey.shade400,
                          ),
                          product.discount != 0
                              ? Text("${product.discount}% off",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14 * fontScale(context)))
                              : Text(""),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Search bar
  SizedBox _searchBar(BuildContext context) {
    return SizedBox(
      height: 45 * screenScale(context),
      child: TextField(
        keyboardType: TextInputType.name,
        style: TextStyle(
          fontSize: 15 * fontScale(context),
        ),
        readOnly: true,
        onTap: () {
          showSearch(context: context, delegate: AppSearchBar());
        },
        decoration: InputDecoration(
          isDense: true,
          fillColor: _boxColor,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(10 * screenScale(context))),
            borderSide: BorderSide(
              color: _boxColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(10 * screenScale(context))),
            borderSide: BorderSide(
              color: _boxColor,
            ),
          ),
          contentPadding: EdgeInsets.only(top: 10 * screenScale(context)),
          hintText: 'What are you looking for?',
          prefixIcon: Icon(Ionicons.search_outline,
              size: 24 * screenScale(context),
              color: Color(hexColor("#7a7a7a"))),
        ),
      ),
      width: double.infinity,
    );
  }

  //Card for each brand
  Widget _brandCard({required String imgUrl}) {
    return Container(
      width: 117 * screenScale(context),
      height: 60 * screenScale(context),
      decoration: BoxDecoration(
          border: Border.all(color: _boxColor),
          borderRadius:
              BorderRadius.all(Radius.circular(10 * screenScale(context))),
          color: Colors.white),
      padding: EdgeInsets.all(10 * screenScale(context)),
      child: SvgPicture.network(imgUrl),
    );
  }

  //Heading line of each block
  Widget _headingLine({required String name, Widget? path, bool? more10}) {
    return Padding(
      padding: EdgeInsets.only(
          right: 15 * screenScale(context), left: 15 * screenScale(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            name,
            style: TextStyle(
                fontSize: 16 * fontScale(context), fontWeight: FontWeight.bold),
          ),
          path == null
              ? SizedBox()
              : more10 == true
                  ? GestureDetector(
                      onTap: () => Get.to(() => path),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "See more",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14 * fontScale(context)),
                          ),
                          Icon(
                            Ionicons.chevron_forward_outline,
                            size: 17 * screenScale(context),
                            color: Colors.blue,
                          )
                        ],
                      ),
                    )
                  : SizedBox()
        ],
      ),
    );
  }

  //Card for each category
  Widget _categoryCard({required String name, required String imgUrl}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: _boxColor),
          borderRadius:
              BorderRadius.all(Radius.circular(15 * screenScale(context))),
          color: _boxColor),
      width: 180 * screenScale(context),
      height: 120 * screenScale(context),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15 * screenScale(context)),
            child: Container(
              width: 180 * screenScale(context),
              height: 120 * screenScale(context),
              color: Colors.black,
              child: Opacity(
                opacity: 0.5,
                child: Image.network(imgUrl, fit: BoxFit.fill),
              ),
            ),
          ),
          Center(
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15 * fontScale(context),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
