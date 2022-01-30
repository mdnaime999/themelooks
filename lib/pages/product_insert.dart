import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import '../class/fields_class.dart';

class SecendPage extends StatefulWidget {
  const SecendPage({Key? key}) : super(key: key);

  @override
  _SecendPageState createState() => _SecendPageState();
}

class _SecendPageState extends State<SecendPage> {
  final tcolor = Color(int.parse(dotenv.get('tcolor')));
  final apiurl = dotenv.env['apiurl'];
  Dio dio = Dio();

  List<PlatformFile> imageFile = [];

  // color
  List? rowColors;
  List<DropdownMenuItem<int>>? colorsDropList;
  int? selectedColors;
  // size
  List? rowSizes;
  List<DropdownMenuItem<int>>? sizesDropList = [];
  int? selectedSizes;
  // price
  TextEditingController price = TextEditingController();
  // Product
  TextEditingController pname = TextEditingController();
  TextEditingController pdes = TextEditingController();
  List<Map<dynamic, dynamic>> productDetails = [];

  @override
  void initState() {
    super.initState();
    initColorsList();
    initSizesList();
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
    // print(pColors);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tcolor,
        title: const Text("Product Uplode Page"),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: tcolor,
            ),
            icon: Icon(
              Icons.save,
              size: 15.sp,
            ),
            label: Text("Saved"),
            onPressed: () {
              saveProduct();
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              children: [
                InputTextField(
                  title: "Product Name",
                  fieldtext: "Type product name",
                  cont: pname,
                ),
                InputTextField(
                  title: "Description",
                  fieldtext: "Product Description",
                  cont: pdes,
                  multi: true,
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 100.w,
                  // padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          "Selected " + imageFile.length.toString() + " File",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: tcolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.w),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 5.w),
                        ),
                        child: Text("Upload Image"),
                        onPressed: () async {
                          await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png', 'gif'],
                          ).then((result) {
                            setState(() {
                              imageFile.clear();
                            });
                            if (result != null) {
                              List files = (result.files).toList();
                              for (var item in files) {
                                // 2 mb = 2097152 b
                                if (item.size < 2097152) {
                                  setState(() {
                                    imageFile.add(item);
                                  });
                                } else {
                                  flushbar(
                                      "Failed!",
                                      item.name + "/ file size too large....",
                                      Colors.red);
                                }
                              }
                            } else {
                              flushbar("Failed!", "File Selected Failed",
                                  Colors.red);
                            }
                          });

                          // if (result != null) {
                          //   // PlatformFile file = result.files.single;
                          //   List files = (result.files).toList();

                          //   for (var item in files) {
                          //     // 2 mb = 2097152 b
                          //     if (item.size < 2097152) {
                          //       if(){

                          //       }
                          //       imageFile.add(item);
                          //     } else {
                          //       flushbar(
                          //           "Failed!",
                          //           item.name + "/ file size too large....",
                          //           Colors.red);
                          //     }
                          //   }
                          // } else {
                          //   flushbar(
                          //       "Failed!", "File Selected Failed", Colors.red);
                          // }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                imageFile.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 5.w,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: imageFile.length,
                        itemBuilder: (context, index) {
                          var viewImage =
                              File(imageFile[index].path.toString());
                          return Image.file(viewImage);
                          // return Text(index.toString());
                        },
                      )
                    : Text("No images"),
                //                                                        Color
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    "Product Details",
                    style: TextStyle(
                      color: tcolor,
                      fontSize: 15.sp,
                    ),
                  ),
                  trailing: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: tcolor,
                    ),
                    icon: Icon(
                      Icons.add,
                      size: 15.sp,
                    ),
                    label: Text("Add"),
                    onPressed: () {
                      addProductDetails();
                    },
                  ),
                ),
                Divider(height: 1.h, color: tcolor),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: productDetails.length,
                  itemBuilder: (context, index) {
                    var colorName =
                        findName(rowColors, productDetails[index]['color_id']);
                    var sizeName =
                        findName(rowSizes, productDetails[index]['size_id']);
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                colorName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: tcolor,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                sizeName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: tcolor,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                productDetails[index]['price'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: tcolor,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 15.sp,
                              color: Colors.red,
                            ),
                            // tooltip: productDetails[index]['product_id'],
                            onPressed: () {
                              deleteOpt(
                                "Are you sure delete ",
                                () {
                                  for (var colors in productDetails) {
                                    if (colors.containsKey("id")) {
                                      if (colors["id"] ==
                                          productDetails[index]['id']) {
                                        setState(() {
                                          colors['st'] = false;
                                        });
                                      }
                                    }
                                  }
                                  setState(() {
                                    productDetails.removeAt(index);
                                  });

                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //                                                                      Color fun
  void addProductDetails() {
    showAnimatedDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState1) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.symmetric(horizontal: 5.w),
            backgroundColor: Colors.transparent,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100.w,
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: tcolor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.w),
                        topRight: Radius.circular(5.w),
                      ),
                    ),
                    child: Text(
                      "Product Details",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
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
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: tcolor, fontSize: 13.sp),
                        hint: Text(
                          "Select Color",
                          overflow: TextOverflow.ellipsis,
                        ),
                        items: colorsDropList,
                        value: selectedColors,
                        onChanged: (value) async {
                          setState(() {
                            selectedColors = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
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
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: tcolor, fontSize: 13.sp),
                        hint: Text(
                          "Select Size",
                          overflow: TextOverflow.ellipsis,
                        ),
                        items: sizesDropList,
                        value: selectedSizes,
                        onChanged: (value) async {
                          setState(() {
                            selectedSizes = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 2.h),
                      child: InputTextField(
                        // title: "Price",
                        fieldtext: "Type product Price",
                        cont: price,
                      ),
                    ),
                  ),
                  Container(
                    width: 100.w,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.w),
                        bottomRight: Radius.circular(5.w),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: tcolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.w),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 5.w),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(),
                          ),
                          onPressed: () {
                            // ignore: unnecessary_new, prefer_collection_literals
                            Map data = new Map();
                            data['color_id'] = selectedColors;
                            data['size_id'] = selectedSizes;
                            data['price'] = price.text;
                            setState(() {
                              productDetails.add(data);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(width: 3.w),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.w),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 5.w),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.bounceInOut,
      duration: Duration(milliseconds: 500),
    );
  }

  //                                                                      Save Product Function
  void saveProduct() async {
    var formData = FormData.fromMap({
      'name': pname.text,
      'description': pdes.text,
      'product_details': jsonEncode(productDetails),
    });
    for (var item in imageFile) {
      formData.files.addAll([
        MapEntry("images", await MultipartFile.fromFile(item.path.toString())),
      ]);
    }

    await dio
        .post(apiurl.toString() + "product-insert", data: formData)
        .then((value) {
      if (value.statusCode == 200) {
        print(value.data);
      }
    });
  }

  void imageUplode(id, imageFile) async {
    var formData = FormData();
    for (var item in imageFile) {
      formData.files.addAll([
        MapEntry("images", await MultipartFile.fromFile(item.path.toString())),
      ]);
    }
    await dio
        .post(apiurl.toString() + "product-insert-image", data: formData)
        .then((imgvalue) {
      if (imgvalue.statusCode == 200) {
        print(imgvalue.data);
      }
    });

    // for (var item in imageFile) {
    //   Future<MultipartFile> mf = MultipartFile.fromFile(item.path.toString(),
    //       filename: item.name, contentType: MediaType('image', 'jpg'));
    //   var formData = FormData.fromMap({'images': await mf});
    //   await dio
    //       .post(apiurl.toString() + "product-insert-image", data: formData)
    //       .then((imgvalue) {
    //     if (imgvalue.statusCode == 200) {
    //       print(imgvalue.data);
    //     }
    //   });
    // }
  }

  void deleteOpt(String msg, void Function()? deleteAction) {
    showAnimatedDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState5) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.symmetric(horizontal: 5.w),
            backgroundColor: Colors.transparent,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100.w,
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: tcolor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.w),
                        topRight: Radius.circular(5.w),
                      ),
                    ),
                    child: Text(
                      "Confirmation",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 100.w,
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 50.sp,
                        ),
                        Text(msg),
                      ],
                    ),
                  ),
                  Container(
                    width: 100.w,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.w),
                        bottomRight: Radius.circular(5.w),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.w),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 5.w),
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(),
                          ),
                          onPressed: deleteAction,
                        ),
                        SizedBox(width: 3.w),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1.w),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 5.w),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.bounceInOut,
      duration: Duration(milliseconds: 500),
    );
  }

  findName(data, id) {
    for (var map in data) {
      if (map.containsKey("id")) {
        if (map["id"] == id) {
          return map['name'];
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
