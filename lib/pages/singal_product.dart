import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../configuration/configuration.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class SingalProduct extends StatefulWidget {
  const SingalProduct({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  _SingalProductState createState() => _SingalProductState();
}

class _SingalProductState extends State<SingalProduct> {
  final tcolor = Color(int.parse(dotenv.get('tcolor')));
  final apiurl = dotenv.env['apiurl'];

  // color
  List? rowColors;
  List<DropdownMenuItem<int>>? colorsDropList;
  int? selectedColor;
  // size
  List? rowSizes;
  List<DropdownMenuItem<int>>? sizesDropList;
  int? selectedSize;

  int? selectedPrice;
  TextEditingController selectedQty = TextEditingController();

  @override
  void initState() {
    super.initState();
    initColorsList();
    initSizesList();
    setState(() {
      selectedPrice = widget.data['details'][0]['price'];
      selectedColor = widget.data['details'][0]['color_id']['id'];
      selectedSize = widget.data['details'][0]['size_id']['id'];
      selectedQty.text = '1';
    });
  }

  void initColorsList() async {
    Uri api = Uri.parse(apiurl.toString() + "productgetcolors");
    await http.get(api).then((value) {
      // print(value.statusCode);
      if (value.statusCode == 200) {
        var data = jsonDecode(value.body);
        setState(() {
          rowColors = data;
          colorsDropList = List.generate(
            data.length,
            (i) => DropdownMenuItem(
              value: data[i]["id"],
              child: Text(data[i]['name'], overflow: TextOverflow.ellipsis),
            ),
          );
        });
      } else if (value.statusCode == 404) {
        var msg = jsonDecode(value.body);
        EasyLoading.showError(msg);
      } else {
        EasyLoading.showError('Colors Loading Failed!');
      }
    });
  }

  void initSizesList() async {
    Uri api = Uri.parse(apiurl.toString() + "productgetsizes");
    await http.get(api).then((value) {
      // print(value.statusCode);
      if (value.statusCode == 200) {
        var data = jsonDecode(value.body);
        setState(() {
          rowSizes = data;
          sizesDropList = List.generate(
            data.length,
            (i) => DropdownMenuItem(
              value: data[i]["id"],
              child: Text(data[i]['name'], overflow: TextOverflow.ellipsis),
            ),
          );
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
      // appBar: AppBar(
      //   backgroundColor: tcolor,
      //   title: const Text("Product Uplode Page"),
      // ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 50.h,
                  color: (widget.data['id'] % 2 == 0)
                      ? Colors.blueGrey[200]
                      : Colors.orangeAccent[200],
                  child: Hero(
                    tag: 'pro${widget.data['id']}',
                    child: Image.network(
                      widget.data['images'][0]['path_image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 13.h, 0, 10.h),
                    // height: 25.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          trailing: SizedBox(
                            width: 50.w,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    int qty = int.parse(selectedQty.text);
                                    setState(() {
                                      if (qty > 1) {
                                        selectedQty.text = (qty - 1).toString();
                                      }
                                    });
                                    qtyToPrice();
                                  },
                                  icon: Icon(Icons.remove),
                                ),
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.w),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: tcolor),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(2.w),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: selectedQty,
                                      keyboardType: TextInputType.number,
                                      cursorColor: tcolor,
                                      textAlign: TextAlign.center,
                                      readOnly: true,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: tcolor,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        if (value != '') {
                                          int val = int.parse(value);
                                          if (val < 1) {
                                            setState(() {
                                              selectedQty.text = '1';
                                            });
                                          }
                                          qtyToPrice();
                                        } else {
                                          flushbar("Worning!",
                                              "Quantity is empty", Colors.red);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    int qty = int.parse(selectedQty.text);
                                    setState(() {
                                      selectedQty.text = (qty + 1).toString();
                                    });
                                    qtyToPrice();
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Text(
                            widget.data['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          margin: EdgeInsets.only(top: 2.h),
                          child: Text(
                            "Description",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Divider(
                            color: tcolor,
                            thickness: 1.sp,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Text(
                            widget.data['description'],
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 4.h),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 100.h,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 20.h,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    boxShadow: shadowList,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedPrice != null
                              ? 'Price : ' + selectedPrice.toString() + ' ৳'
                              : 'Price : 0 ৳',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: tcolor,
                            fontSize: 15.sp,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 2.h),
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2.w),
                                  ),
                                ),
                                child: DropdownButtonFormField<int>(
                                  dropdownColor: Colors.teal[100],
                                  iconEnabledColor: tcolor,
                                  isExpanded: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style:
                                      TextStyle(color: tcolor, fontSize: 13.sp),
                                  hint: Text(
                                    "Select Color",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  items: colorsDropList,
                                  value: selectedColor,
                                  onChanged: (value) async {
                                    setState(() {
                                      selectedColor = value;
                                    });
                                    colorToPrice();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 2.h),
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2.w),
                                  ),
                                ),
                                child: DropdownButtonFormField<int>(
                                  dropdownColor: Colors.teal[100],
                                  iconEnabledColor: tcolor,
                                  isExpanded: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style:
                                      TextStyle(color: tcolor, fontSize: 13.sp),
                                  hint: Text(
                                    "Select Size",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  items: sizesDropList,
                                  value: selectedSize,
                                  onChanged: (value) async {
                                    setState(() {
                                      selectedSize = value;
                                    });
                                    sizeToPrice();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void colorToPrice() {
    for (var map in widget.data['details']) {
      if (map["color_id"].containsKey("id")) {
        if (map["color_id"]['id'] == selectedColor) {
          setState(() {
            selectedPrice = map['price'];
            selectedSize = map['size_id']['id'];
          });
        }
      }
    }
  }

  void sizeToPrice() {
    for (var map in widget.data['details']) {
      if (map["size_id"].containsKey("id")) {
        if (map["size_id"]['id'] == selectedSize) {
          setState(() {
            selectedPrice = map['price'];
            selectedColor = map['color_id']['id'];
          });
        }
      }
    }
  }

  void qtyToPrice() {
    if (selectedQty.text != '') {
      int qty = int.parse(selectedQty.text);
      for (var map in widget.data['details']) {
        if (map.containsKey("id")) {
          if (map["color_id"]['id'] == selectedColor &&
              map["size_id"]['id'] == selectedSize) {
            selectedPrice = (map['price'] * qty);
          }
        }
      }
    }
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
