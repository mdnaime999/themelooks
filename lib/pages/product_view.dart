import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../configuration/configuration.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final tcolor = Color(int.parse(dotenv.get('tcolor')));
  final apiurl = dotenv.env['apiurl'];
  var _products;

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  Future<void> getProduct() async {
    Uri api = Uri.parse(apiurl.toString() + "products");
    await http.get(api).then((value) {
      if (value.statusCode == 200) {
        var products = jsonDecode(value.body);
        setState(() {
          _products = products;
        });
      } else if (value.statusCode == 404) {
        var msg = jsonDecode(value.body);
        EasyLoading.showError(msg);
      } else {
        EasyLoading.showError('Sizes Loading Failed!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tcolor,
        title: const Text("Product Uplode Page"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/product_insert");
            },
            icon: Icon(Icons.menu),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 1.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                    ),
                    hintText: 'Search pet',
                    hintStyle:
                        TextStyle(letterSpacing: 1, color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: Icon(Icons.tune_sharp, color: Colors.grey[400]),
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                height: 18.h,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: shadowList,
                              ),
                              child: Image(
                                image:
                                    AssetImage(categories[index]['imagePath']),
                                height: 50,
                                width: 50,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              categories[index]['name'],
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 1.h,
              ),
              _products != null
                  ? ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount: _products.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("/singal_product",
                                arguments: _products[index]);
                          },
                          child: Container(
                            height: 25.h,
                            width: 100.w,
                            margin: EdgeInsets.all(5.w),
                            child: Row(
                              children: [
                                Container(
                                  height: 30.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: (index % 2 == 0)
                                        ? Colors.blueGrey[200]
                                        : Colors.orangeAccent[200],
                                    // image: DecorationImage(
                                    //   image: NetworkImage(_products[index]['images']
                                    //       [0]['path_image']),
                                    // ),

                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: shadowList,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.sp),
                                    child: Hero(
                                      tag: 'pro${_products[index]['id']}',
                                      child: Image.network(
                                        _products[index]['images'][0]
                                            ['path_image'],
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50.w,
                                  height: 30.h,
                                  margin:
                                      EdgeInsets.only(top: 3.h, bottom: 3.h),
                                  padding: EdgeInsets.all(10.sp),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                    boxShadow: shadowList,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          _products[index]['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp,
                                            color: Colors.grey[600],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        'Price : ' +
                                            _products[index]['details'][0]
                                                    ['price']
                                                .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          _products[index]['description'],
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.grey[400],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void flushbar(title, message, color) {
    Flushbar(
      backgroundColor: color,
      borderRadius: BorderRadius.circular(10),
      maxWidth: 90.w,
      margin: EdgeInsets.only(bottom: 30),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      title: title,
      message: message,
      duration: Duration(seconds: 5),
    ).show(context);
  }
}
