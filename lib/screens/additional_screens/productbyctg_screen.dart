import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/product_controller.dart';
import 'package:itproject_gadget_store/controllers/search.dart';
import 'package:itproject_gadget_store/models/category.dart';
import 'package:itproject_gadget_store/models/product.dart';
import 'package:itproject_gadget_store/screens/additional_screens/product_details_screen.dart';

class ProductByCtgScreen extends StatefulWidget {
  final Category category;
  final Category? subcategory;
  const ProductByCtgScreen({Key? key, required this.category, this.subcategory})
      : super(key: key);

  @override
  _ProductByCtgScreenState createState() => _ProductByCtgScreenState();
}

class _ProductByCtgScreenState extends State<ProductByCtgScreen>
    with SingleTickerProviderStateMixin {
  Color _boxColor = Color(hexColor("#e3e3e3"));
  Color _cardColor = Color(hexColor("#f7f7f7"));
  Color _priceColor = Color(hexColor("#ff408d"));
  Color _bfdPriceColor = Colors.grey.shade500;

  ProductController _productController = Get.find();
  List<Category> _childCtgList = [];
  var _color1, _color2, _color3 = Colors.black;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _childCtgList = _productController.categoryList
        .where((p0) => p0.parent != null && p0.parent!.id == widget.category.id)
        .toList();
    _tabController = TabController(length: _childCtgList.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    if (widget.subcategory != null) {
      _tabController.index = _childCtgList
          .lastIndexWhere((element) => element.id == widget.subcategory!.id);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  //Generate product list
  List<Product> _productsByCtg(int id) {
    return _productController.productList
        .where((p0) => p0.categoryId == id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _customizedAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(_childCtgList.length, (i) {
          if (_productsByCtg(_childCtgList[i].id).length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300 * screenScale(context),
                    child: Text(
                      "We haven't added any products for this category. Sorry for the inconvenience.",
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
            );
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10 * screenScale(context),
              mainAxisSpacing: 10 * screenScale(context),
              mainAxisExtent: 248 * screenScale(context),
            ),
            shrinkWrap: true,
            padding: EdgeInsets.all(10 * screenScale(context)),
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              var _plist = _productsByCtg(_childCtgList[i].id);
              if (_color1 == Colors.blue) {
                _plist.sort((a, b) => a.name.compareTo(b.name));
              }
              if (_color2 == Colors.blue) {
                _plist.sort((a, b) => a.price.compareTo(b.price));
              }
              if (_color3 == Colors.blue) {
                _plist.sort((a, b) => b.price.compareTo(a.price));
              }

              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                              product: _plist[index],
                            ))),
                child: _productCard(product: _plist[index]),
              );
            },
            itemCount: _productsByCtg(_childCtgList[i].id).length,
          );
        }),
      ),
    );
  }

  //Customized appbar
  AppBar _customizedAppBar() {
    return AppBar(
      actions: [
        GestureDetector(
          onTap: () => showSearch(
              context: context,
              delegate: AppSearchBar(categoryId: widget.category.id)),
          child: Padding(
            padding: EdgeInsets.only(right: 15 * screenScale(context)),
            child: Icon(
              Ionicons.search_outline,
              color: Colors.black,
              size: 24 * screenScale(context),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20 * screenScale(context)),
          child: PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: Text(
                        "Sort by Name",
                        style: TextStyle(
                            color: _color1, fontSize: 15 * fontScale(context)),
                      ),
                      onTap: () {
                        setState(() {
                          _color1 = Colors.blue;
                          _color2 = Colors.black;
                          _color3 = Colors.black;
                        });
                      },
                    ),
                    PopupMenuItem(
                      child: Text(
                        "Sort by Price ascending",
                        style: TextStyle(
                            color: _color2, fontSize: 15 * fontScale(context)),
                      ),
                      onTap: () {
                        setState(() {
                          _color1 = Colors.black;
                          _color2 = Colors.blue;
                          _color3 = Colors.black;
                        });
                      },
                    ),
                    PopupMenuItem(
                      child: Text(
                        "Sort by Price descending",
                        style: TextStyle(
                            color: _color3, fontSize: 15 * fontScale(context)),
                      ),
                      onTap: () {
                        setState(() {
                          _color1 = Colors.black;
                          _color2 = Colors.black;
                          _color3 = Colors.blue;
                        });
                      },
                    )
                  ],
              child: Icon(
                Ionicons.options_outline,
                color: Colors.black,
                size: 24 * screenScale(context),
              )),
        )
      ],
      elevation: 0,
      title: Text(
        widget.category.name,
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
      bottom: PreferredSize(
        child: TabBar(
          controller: _tabController,
          indicator: UnderlineTabIndicator(
              insets: EdgeInsets.symmetric(
                  vertical: 5 * screenScale(context),
                  horizontal: 20 * screenScale(context)),
              borderSide: BorderSide(
                width: 3 * screenScale(context),
                color: Colors.blue,
              )),
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(
              fontSize: 15 * fontScale(context),
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          tabs: List.generate(
              _childCtgList.length,
              (index) => Tab(
                    text: _childCtgList[index].name,
                  )),
        ),
        preferredSize: Size.fromHeight(50),
      ),
    );
  }

  //Card for most popular products
  Widget _productCard({required Product product}) {
    return Container(
      height: 245 * screenScale(context),
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
                width: 190 * screenScale(context),
                height: 140 * screenScale(context),
                child: Hero(
                  tag: product,
                  child: Image.network(
                    product.mainImg,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          SizedBox(
            height: 105 * screenScale(context),
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
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14 * fontScale(context)),
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
}
