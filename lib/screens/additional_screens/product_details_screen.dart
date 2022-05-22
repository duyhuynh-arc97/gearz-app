import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/cart_controller.dart';
import 'package:itproject_gadget_store/controllers/product_controller.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/controllers/wishlist_controller.dart';
import 'package:itproject_gadget_store/models/cart_item.dart';
import 'package:itproject_gadget_store/models/product.dart';
import 'package:itproject_gadget_store/models/product_images.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:itproject_gadget_store/models/wishlist.dart';
import 'package:itproject_gadget_store/screens/additional_screens/productbybrand_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/productbyctg_screen.dart';
import 'package:itproject_gadget_store/widgets/common_widgets.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _imgIndex = 0;
  bool _isLiked = false;
  bool _isAdded = false;
  double _appbarHeight = 0;
  bool _isLoading = false;
  int _quantity = 1;

  UserController _userController = Get.find();
  CartController _cartController = Get.find();
  WishlistController _wishlistController = Get.find();

  @override
  void initState() {
    super.initState();
    for (var data in _wishlistController.wishlistItems) {
      if (data.item.id == widget.product.id) {
        _isLiked = !_isLiked;
        break;
      }
    }

    for (var data in _cartController.cartItems) {
      if (data.item.id == widget.product.id) {
        _isAdded = !_isAdded;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: FutureBuilder(
        future: ProductController.getProductDetails(id: widget.product.id),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                backgroundColor: Colors.white, body: _shimmerBody(context));
          } else {
            List iList = [];
            iList.add(widget.product.mainImg);

            for (ProductImages i in snapshot.data.imgList) {
              iList.add(i.image);
            }

            return Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar: _bottomAppBar(context),
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [_customizedAppBar(context, iList)];
                },
                body: Padding(
                  padding: EdgeInsets.only(top: 15 * screenScale(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            15 * screenScale(context),
                            0,
                            15 * screenScale(context),
                            10 * screenScale(context)),
                        child: Text(
                          snapshot.data.name,
                          style: TextStyle(fontSize: 16 * fontScale(context)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 15 * screenScale(context),
                            left: 15 * screenScale(context)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _priceText(snapshot),
                            _ratingField(),
                          ],
                        ),
                      ),
                      SizedBox(height: 10 * screenScale(context)),
                      _brandField(snapshot),
                      SizedBox(height: 5 * screenScale(context)),
                      _categoryField(snapshot),
                      SizedBox(height: 5 * screenScale(context)),
                      _tagsField(snapshot),
                      SizedBox(height: 10 * screenScale(context)),
                      _subTabBar(),
                      _subTabViews(snapshot)
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  //Shimmer body
  Column _shimmerBody(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.all(
                      Radius.circular(15 * screenScale(context))),
                  color: Colors.grey.shade200),
              height: 450 * screenScale(context),
            ),
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100),
        Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                  child: Container(
                    height: 50 * screenScale(context),
                    color: Colors.grey.shade200,
                  ),
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100),
              SizedBox(height: 15 * screenScale(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                      child: Container(
                        height: 25 * screenScale(context),
                        width: 150 * screenScale(context),
                        color: Colors.grey.shade200,
                      ),
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100),
                  Shimmer.fromColors(
                      child: Container(
                        height: 25 * screenScale(context),
                        width: 100 * screenScale(context),
                        color: Colors.grey.shade200,
                      ),
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100),
                ],
              ),
              SizedBox(height: 15 * screenScale(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                      child: Container(
                        height: 20 * screenScale(context),
                        width: 70 * screenScale(context),
                        color: Colors.grey.shade200,
                      ),
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100),
                  Shimmer.fromColors(
                      child: Container(
                        height: 20 * screenScale(context),
                        width: 50 * screenScale(context),
                        color: Colors.grey.shade200,
                      ),
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100),
                ],
              ),
              SizedBox(height: 5 * screenScale(context)),
              Shimmer.fromColors(
                  child: Container(
                    height: 20 * screenScale(context),
                    width: 200 * screenScale(context),
                    color: Colors.grey.shade200,
                  ),
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100),
              SizedBox(height: 5 * screenScale(context)),
              Shimmer.fromColors(
                  child: Container(
                    height: 20 * screenScale(context),
                    color: Colors.grey.shade200,
                  ),
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100),
              SizedBox(height: 50 * screenScale(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                      child: Container(
                        height: 40 * screenScale(context),
                        width: 70 * screenScale(context),
                        color: Colors.grey.shade200,
                      ),
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100),
                  Shimmer.fromColors(
                      child: Container(
                        height: 40 * screenScale(context),
                        width: 70 * screenScale(context),
                        color: Colors.grey.shade200,
                      ),
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100),
                  Shimmer.fromColors(
                      child: Container(
                        height: 40 * screenScale(context),
                        width: 70 * screenScale(context),
                        color: Colors.grey.shade200,
                      ),
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100),
                ],
              ),
              SizedBox(height: 30 * screenScale(context)),
              Shimmer.fromColors(
                  child: Container(
                    height: 100 * screenScale(context),
                    color: Colors.grey.shade200,
                  ),
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100),
            ],
          ),
        ),
      ],
    );
  }

  //Bottom appbar
  BottomAppBar _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      elevation: 20 * screenScale(context),
      child: Container(
        padding: EdgeInsets.only(
            left: 10 * screenScale(context), right: 10 * screenScale(context)),
        height: 65 * screenScale(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150 * screenScale(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    height: 30 * screenScale(context),
                    minWidth: 30 * screenScale(context),
                    onPressed: () => setState(() {
                      _quantity++;
                    }),
                    color: Color(hexColor("#e3e3e3")),
                    textColor: Colors.black,
                    child: Icon(
                      Ionicons.add_outline,
                      size: 24 * screenScale(context),
                    ),
                    padding: EdgeInsets.all(5 * screenScale(context)),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5 * screenScale(context))),
                    elevation: 0,
                  ),
                  Text(
                    _quantity.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17 * fontScale(context),
                        fontWeight: FontWeight.bold),
                  ),
                  MaterialButton(
                    height: 30 * screenScale(context),
                    minWidth: 30 * screenScale(context),
                    onPressed: () {
                      if (_quantity > 1) {
                        setState(() {
                          _quantity--;
                        });
                      }
                    },
                    color: Color(hexColor("#e3e3e3")),
                    textColor: Colors.black,
                    child: Icon(
                      Ionicons.remove_outline,
                      size: 24 * screenScale(context),
                    ),
                    padding: EdgeInsets.all(5 * screenScale(context)),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5 * screenScale(context))),
                    elevation: 0,
                  ),
                ],
              ),
            ),
            Container(
              height: 45 * screenScale(context),
              width: 170 * screenScale(context),
              child: ElevatedButton(
                onPressed: _isAdded == false
                    ? () {
                        setState(() {
                          _isLoading = true;
                        });
                        _cartController
                            .addToCart(
                                userId: _userController.user.value.id,
                                productId: widget.product.id,
                                quantity: _quantity)
                            .then((value) {
                          if (value == "successful") {
                            setState(() {
                              _isAdded = !_isAdded;
                            });
                            Get.snackbar(
                              "Added to Your cart!",
                              "This product is successfully added. You can check in Your cart.",
                              colorText: Colors.white,
                              snackStyle: SnackStyle.FLOATING,
                              barBlur: 30,
                              backgroundColor: Colors.black45,
                              isDismissible: true,
                              duration: Duration(seconds: 3),
                              dismissDirection: DismissDirection.horizontal,
                            );
                            _cartController.cartItems.add(CartItem(
                                userId: _userController.user.value.id,
                                item: widget.product,
                                quantity: _quantity,
                                isChoosen: false));
                            setState(() {
                              _isLoading = false;
                            });
                          } else {
                            print("failed");
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        });
                      }
                    : () {
                        Get.snackbar(
                          "Already added!",
                          "This product has been already added . You can check in Your cart.",
                          colorText: Colors.white,
                          snackStyle: SnackStyle.FLOATING,
                          barBlur: 30,
                          backgroundColor: Colors.black45,
                          isDismissible: true,
                          duration: Duration(seconds: 3),
                          dismissDirection: DismissDirection.horizontal,
                        );
                      },
                child: _isLoading == false
                    ? Text('Add to cart',
                        style: TextStyle(
                            fontSize: 17 * fontScale(context),
                            fontWeight: FontWeight.w900,
                            color: Colors.white))
                    : loadingText("Please wait", context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(7 * screenScale(context))),
                  primary: Color(hexColor("#346ec9")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Appbar
  SliverAppBar _customizedAppBar(BuildContext context, List<dynamic> iList) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      pinned: true,
      elevation: 1 * screenScale(context),
      expandedHeight: 400 * screenScale(context),
      leading: Padding(
        padding: EdgeInsets.all(10 * screenScale(context)),
        child: MaterialButton(
          onPressed: () => Get.back(),
          color: Colors.white,
          textColor: Colors.black,
          child: Icon(
            Ionicons.chevron_back_outline,
            size: 24 * screenScale(context),
          ),
          padding: EdgeInsets.all(5 * screenScale(context)),
          shape: CircleBorder(),
          elevation: 0,
        ),
      ),
      actions: [
        Container(
          height: 40 * screenScale(context),
          width: 40 * screenScale(context),
          margin: EdgeInsets.only(right: 10 * screenScale(context)),
          alignment: Alignment.center,
          child: MaterialButton(
            onPressed: () {
              _wishlistController
                  .addToWishlist(
                      productId: widget.product.id,
                      userId: _userController.user.value.id)
                  .then((value) {
                if (value == "successful") {
                  Get.snackbar(
                    "Added to Your wishlist!",
                    "This product is successfully added. You can check in Your cart.",
                    colorText: Colors.white,
                    snackStyle: SnackStyle.FLOATING,
                    barBlur: 30,
                    backgroundColor: Colors.black45,
                    isDismissible: true,
                    duration: Duration(seconds: 3),
                    dismissDirection: DismissDirection.horizontal,
                  );
                  _wishlistController.wishlistItems.add(Wishlist(
                      item: widget.product,
                      userId: _userController.user.value.id));
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                } else if (value == "removed") {
                  Get.snackbar(
                    "Dislike!",
                    "You've just disliked this product. You can check in Your wishlist.",
                    colorText: Colors.white,
                    snackStyle: SnackStyle.FLOATING,
                    barBlur: 30,
                    backgroundColor: Colors.black45,
                    isDismissible: true,
                    duration: Duration(seconds: 3),
                    dismissDirection: DismissDirection.horizontal,
                  );
                  setState(() {
                    _wishlistController.wishlistItems.removeWhere(
                        (element) => element.item.id == widget.product.id);
                    _isLiked = false;
                  });
                }
              });
            },
            color: Colors.white,
            textColor: Colors.black,
            child: Obx(() {
              for (var i in _wishlistController.wishlistItems) {
                if (i.item.id == widget.product.id) {
                  return Icon(
                    Iconsax.heart5,
                    size: 24 * screenScale(context),
                    color: Colors.red,
                  );
                }
              }
              return Icon(
                Iconsax.heart,
                size: 24 * screenScale(context),
              );
            }),
            padding: EdgeInsets.all(5 * screenScale(context)),
            shape: CircleBorder(),
            elevation: 0,
          ),
        )
      ],
      flexibleSpace: LayoutBuilder(builder: (context, constraints) {
        _appbarHeight = constraints.biggest.height;
        return FlexibleSpaceBar(
          centerTitle: true,
          title: _appbarHeight < 100 * screenScale(context)
              ? Text(
                  "Product details",
                  style: TextStyle(
                      color: Colors.black, fontSize: 20 * fontScale(context)),
                )
              : null,
          background: Hero(
            tag: widget.product,
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: iList.length,
                  itemBuilder: (context, index, realIndex) {
                    return imgCard(path: iList[index], index: index);
                  },
                  options: CarouselOptions(
                    height: 480 * screenScale(context),
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _imgIndex = index;
                      });
                    },
                    enableInfiniteScroll: false,
                  ),
                ),
                imgIndicator(imgIndex: _imgIndex, imgList: iList)
              ],
            ),
          ),
        );
      }),
    );
  }

  //Small tabs in page
  Widget _subTabViews(AsyncSnapshot<dynamic> snapshot) {
    return Flexible(
      child: TabBarView(
        children: [
          ListView(
            padding: EdgeInsets.only(
                right: 6 * screenScale(context),
                left: 6 * screenScale(context)),
            children: [
              Html(data: snapshot.data.fullDesc, style: {
                "span": Style(fontSize: FontSize(16 * fontScale(context))),
                "h3 strong": Style(fontSize: FontSize(20 * fontScale(context))),
                "h2 strong": Style(fontSize: FontSize(20 * fontScale(context))),
              }),
            ],
          ),
          ListView.separated(
            padding: EdgeInsets.fromLTRB(15 * screenScale(context),
                25 * screenScale(context), 15 * screenScale(context), 0),
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      snapshot.data.specList[index].name + ": ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * screenScale(context)),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      snapshot.data.specList[index].value,
                      style: TextStyle(fontSize: 14 * fontScale(context)),
                    ),
                  )
                ],
              );
            },
            itemCount: snapshot.data.specList.length,
            separatorBuilder: (context, index) =>
                Divider(thickness: 1 * screenScale(context)),
          ),
          snapshot.data.reviews.length > 0
              ? ListView.separated(
                  padding: EdgeInsets.fromLTRB(15 * screenScale(context),
                      25 * screenScale(context), 15 * screenScale(context), 0),
                  itemCount: snapshot.data.reviews.length,
                  separatorBuilder: (context, index) => Divider(thickness: 1),
                  itemBuilder: (context, index) {
                    String _time = DateTime.parse(
                                snapshot.data.reviews[index]["review_time"])
                            .day
                            .toString() +
                        "/" +
                        DateTime.parse(
                                snapshot.data.reviews[index]["review_time"])
                            .month
                            .toString() +
                        '/' +
                        DateTime.parse(
                                snapshot.data.reviews[index]["review_time"])
                            .year
                            .toString();
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data.reviews[index]["customer"],
                            style: TextStyle(
                                fontSize: 15 * fontScale(context),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5 * screenScale(context)),
                          Row(
                            children: [
                              RatingBar.builder(
                                itemBuilder: (context, _) =>
                                    Icon(Iconsax.star1, color: Colors.amber),
                                onRatingUpdate: (value) {},
                                ignoreGestures: true,
                                initialRating: double.parse(
                                    snapshot.data.reviews[index]["rating"]),
                                itemSize: 15 * screenScale(context),
                                allowHalfRating: true,
                                unratedColor: Colors.grey.shade400,
                              ),
                              SizedBox(width: 10 * screenScale(context)),
                              Text(
                                _time,
                                style: TextStyle(
                                    fontSize: 14 * fontScale(context)),
                              )
                            ],
                          ),
                          SizedBox(height: 5 * screenScale(context)),
                          Text(
                            snapshot.data.reviews[index]["headline"] +
                                ". " +
                                snapshot.data.reviews[index]["comment"],
                            style: TextStyle(fontSize: 14 * fontScale(context)),
                          )
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300 * screenScale(context),
                        child: Text(
                          "There are no comments yet.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14 * fontScale(context)),
                        ),
                      ),
                      SizedBox(
                        height: 40 * screenScale(context),
                        width: 150 * screenScale(context),
                        child: Icon(
                          Iconsax.emoji_sad,
                          color: Colors.blue,
                          size: 30 * screenScale(context),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  //Small tabbar in page
  Widget _subTabBar() {
    return TabBar(
      indicator: UnderlineTabIndicator(
          insets: EdgeInsets.symmetric(
              vertical: 5 * screenScale(context),
              horizontal: 20 * screenScale(context)),
          borderSide: BorderSide(
            width: 3 * screenScale(context),
            color: Colors.blue,
          )),
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(
          fontSize: 15 * fontScale(context),
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans'),
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.black,
      tabs: [
        Tab(
          text: "Description",
        ),
        Tab(
          text: "Specification",
        ),
        Tab(
          text: "Comments",
        )
      ],
    );
  }

  //Tags text
  Widget _tagsField(AsyncSnapshot<dynamic> snapshot) {
    return Padding(
      padding: EdgeInsets.only(
          right: 15 * screenScale(context), left: 15 * screenScale(context)),
      child: Wrap(
        runSpacing: 5 * screenScale(context),
        spacing: 5 * screenScale(context),
        children: [
          Text(
            "Tags: ",
            style: TextStyle(fontSize: 14 * fontScale(context)),
          ),
          Container(
            padding: EdgeInsets.only(
                right: 5 * screenScale(context),
                left: 5 * screenScale(context)),
            decoration: BoxDecoration(
              color: Color(hexColor("#e3e3e3")),
              borderRadius:
                  BorderRadius.all(Radius.circular(3 * screenScale(context))),
              border: Border.all(color: Color(hexColor("#e3e3e3"))),
            ),
            child: Text(
              snapshot.data.tag.toString().toLowerCase(),
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14 * fontScale(context)),
            ),
          ),
          GestureDetector(
            onTap: () =>
                Get.to(() => ProductByBrandScreen(brand: snapshot.data.brand)),
            child: Container(
              padding: EdgeInsets.only(
                  right: 5 * screenScale(context),
                  left: 5 * screenScale(context)),
              decoration: BoxDecoration(
                color: Color(hexColor("#e3e3e3")),
                borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.all(color: Color(hexColor("#e3e3e3"))),
              ),
              child: Text(
                snapshot.data.brand.name.toString().toLowerCase(),
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14 * fontScale(context)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => ProductByCtgScreen(
                subcategory: snapshot.data.category,
                category: snapshot.data.category.parent)),
            child: Container(
              padding: EdgeInsets.only(
                  right: 5 * screenScale(context),
                  left: 5 * screenScale(context)),
              decoration: BoxDecoration(
                color: Color(hexColor("#e3e3e3")),
                borderRadius:
                    BorderRadius.all(Radius.circular(3 * screenScale(context))),
                border: Border.all(color: Color(hexColor("#e3e3e3"))),
              ),
              child: Text(
                snapshot.data.category.tag.toString().toLowerCase(),
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14 * fontScale(context)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() =>
                ProductByCtgScreen(category: snapshot.data.category.parent)),
            child: Container(
              padding: EdgeInsets.only(
                  right: 5 * screenScale(context),
                  left: 5 * screenScale(context)),
              decoration: BoxDecoration(
                color: Color(hexColor("#e3e3e3")),
                borderRadius:
                    BorderRadius.all(Radius.circular(3 * screenScale(context))),
                border: Border.all(color: Color(hexColor("#e3e3e3"))),
              ),
              child: Text(
                snapshot.data.category.parent.tag.toString().toLowerCase(),
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14 * fontScale(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Category text
  Widget _categoryField(AsyncSnapshot<dynamic> snapshot) {
    return Padding(
      padding: EdgeInsets.only(
          right: 15 * screenScale(context), left: 15 * screenScale(context)),
      child: Row(
        children: [
          Text(
            "Category: ",
            style: TextStyle(fontSize: 14 * fontScale(context)),
          ),
          Text(
            snapshot.data.category.name,
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14 * fontScale(context)),
          ),
        ],
      ),
    );
  }

  //Rating stars
  RatingBar _ratingField() {
    return RatingBar.builder(
      itemBuilder: (context, _) => Icon(Iconsax.star1, color: Colors.amber),
      onRatingUpdate: (value) {},
      ignoreGestures: true,
      initialRating: widget.product.rating,
      itemSize: 18 * screenScale(context),
      allowHalfRating: true,
      unratedColor: Colors.grey.shade400,
    );
  }

  //Brand text
  Widget _brandField(AsyncSnapshot<dynamic> snapshot) {
    return Padding(
      padding: EdgeInsets.only(
          right: 15 * screenScale(context), left: 15 * screenScale(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "Brand: ",
                style: TextStyle(fontSize: 14 * fontScale(context)),
              ),
              Text(
                snapshot.data.brand.name,
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14 * fontScale(context)),
              ),
            ],
          ),
          snapshot.data.inStock == 1
              ? Text(
                  "Instock",
                  style: TextStyle(
                      color: Colors.green,
                      fontStyle: FontStyle.italic,
                      fontSize: 14 * fontScale(context)),
                )
              : Text(
                  "Out of stock",
                  style: TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                      fontSize: 14 * fontScale(context)),
                )
        ],
      ),
    );
  }

  //Price text
  Widget _priceText(AsyncSnapshot<dynamic> snapshot) {
    return snapshot.data.discount != 0
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("\$",
                      style: TextStyle(
                          color: Color(hexColor("#ff408d")),
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale(context))),
                  Text(
                      (snapshot.data.price -
                              snapshot.data.price *
                                  snapshot.data.discount /
                                  100)
                          .toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 20 * fontScale(context),
                          fontWeight: FontWeight.bold,
                          color: Color(hexColor("#ff408d")))),
                ],
              ),
              SizedBox(width: 5 * screenScale(context)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("\$",
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          fontSize: 11 * fontScale(context))),
                  Text(snapshot.data.price.toString(),
                      style: TextStyle(
                          fontSize: 15 * fontScale(context),
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey.shade500)),
                ],
              ),
              SizedBox(width: 10),
              snapshot.data.discount != 0
                  ? Text("${snapshot.data.discount}% off",
                      style: TextStyle(
                          fontSize: 15 * fontScale(context),
                          color: Colors.green,
                          fontWeight: FontWeight.bold))
                  : SizedBox()
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("\$",
                  style: TextStyle(
                      color: Color(hexColor("#ff408d")),
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * fontScale(context))),
              Text(
                  isInt(snapshot.data.price)
                      ? snapshot.data.price.toStringAsFixed(0)
                      : snapshot.data.price.toString(),
                  style: TextStyle(
                      fontSize: 20 * fontScale(context),
                      fontWeight: FontWeight.bold,
                      color: Color(hexColor("#ff408d")))),
            ],
          );
  }

  //Image indicator number
  Positioned imgIndicator(
      {required List<dynamic> imgList, required int imgIndex}) {
    return Positioned(
      bottom: 20 * screenScale(context),
      right: 20 * screenScale(context),
      child: Container(
          padding: EdgeInsets.only(
              right: 10 * screenScale(context),
              left: 10 * screenScale(context)),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius:
                BorderRadius.all(Radius.circular(10 * screenScale(context))),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Text(
            "${imgIndex + 1}/${imgList.length}",
            style: TextStyle(
                color: Colors.white, fontSize: 14 * fontScale(context)),
          )),
    );
  }

  //Image card for slider
  Widget imgCard({required String path, required int index}) {
    return SizedBox(
      height: 450 * screenScale(context),
      width: double.infinity,
      child: index != 0
          ? Image.network(
              "https://gearz-gadget.000webhostapp.com/product_images/${widget.product.id}/extra-images/${path}",
              fit: BoxFit.cover,
            )
          : Image.network(
              path,
              fit: BoxFit.cover,
            ),
    );
  }
}
