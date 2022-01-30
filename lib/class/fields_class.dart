// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TextIconField extends StatelessWidget {
  TextIconField(
      {this.title, this.icon, this.cont, this.multi = false, this.keybord});

  final String? title;
  final IconData? icon;
  final TextEditingController? cont;
  final bool? multi;
  final TextInputType? keybord;

  final tcolor = Color(int.parse(dotenv.get('tcolor')));
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(),
        borderRadius: BorderRadius.all(
          Radius.circular(2.w),
        ),
      ),
      child: TextFormField(
        controller: cont,
        cursorColor: tcolor,
        keyboardType: multi! ? TextInputType.multiline : keybord,
        maxLines: multi! ? 5 : 1,
        style: TextStyle(
          fontSize: 14.sp,
          color: tcolor,
        ),
        // keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: title,
          border: InputBorder.none,
          icon: multi!
              ? null
              : Icon(
                  icon,
                  color: tcolor,
                  size: 20.sp,
                ),
        ),
      ),
    );
  }
}

class InputTextField extends StatelessWidget {
  InputTextField({
    this.title,
    this.fieldtext,
    this.cont,
    this.multi = false,
    this.readOnly = false,
    this.keybord,
  });
  final String? title;
  final String? fieldtext;
  final TextEditingController? cont;
  final bool? multi;
  final bool? readOnly;
  final TextInputType? keybord;

  final tcolor = Color(int.parse(dotenv.get('tcolor')));
  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Text(
              title!,
              style: TextStyle(
                color: tcolor,
                fontSize: 15.sp,
              ),
            ),
          ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: tcolor),
            borderRadius: BorderRadius.all(
              Radius.circular(2.w),
            ),
          ),
          child: TextFormField(
            controller: cont,
            cursorColor: tcolor,
            keyboardType: multi! ? TextInputType.multiline : keybord,
            maxLines: multi! ? 5 : 1,
            readOnly: readOnly!,
            style: TextStyle(
              fontSize: 13.sp,
              color: tcolor,
            ),
            decoration: InputDecoration(
              hintText: fieldtext,
              border: InputBorder.none,
              // icon: Icon(Icons.badge_outlined, color: tcolor, size: 18.sp),
            ),
          ),
        ),
      ],
    );
  }
}

// class DateField extends StatelessWidget {
//   DateField({this.title, this.fieldtext, this.cont});
//   final String? title;
//   final String? fieldtext;
//   final TextEditingController? cont;
//   final tcolor = Color(int.parse(dotenv.get('tcolor')));
//   final format = DateFormat("yyyy-MM-dd");

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(2.w),
//           child: Text(
//             title!,
//             style: TextStyle(
//               color: tcolor,
//               fontSize: 15.sp,
//             ),
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 3.w),
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             border: Border.all(color: tcolor),
//             borderRadius: BorderRadius.all(
//               Radius.circular(2.w),
//             ),
//           ),
//           child: DateTimeField(
//             format: format,
//             controller: cont,
//             cursorColor: tcolor,
//             style: TextStyle(
//               fontSize: 13.sp,
//               color: tcolor,
//             ),
//             decoration: InputDecoration(
//               hintText: fieldtext,
//               border: InputBorder.none,
//               suffixIcon:
//                   Icon(Icons.calendar_today, color: tcolor, size: 16.sp),
//             ),
//             onShowPicker: (context, currentValue) {
//               return showDatePicker(
//                   context: context,
//                   firstDate: DateTime(1900),
//                   initialDate: currentValue ?? DateTime.now(),
//                   lastDate: DateTime(2100));
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

class DepDocField extends StatefulWidget {
  DepDocField({this.title, this.fieldtext, this.cont});
  final String? title;
  final String? fieldtext;
  final TextEditingController? cont;

  @override
  _DepDocFieldState createState() => _DepDocFieldState();
}

class _DepDocFieldState extends State<DepDocField> {
  final tcolor = Color(int.parse(dotenv.get('tcolor')));
  int? selectedDep;
  List<DropdownMenuItem<int>>? department;
  List? listUserType;

  @override
  void initState() {
    super.initState();
    listUserType = [
      {'name': 'Individual', 'id': 1},
      {'name': 'Company', 'id': 2}
    ];
    if (listUserType != null) {
      department = List.generate(
        listUserType!.length,
        (i) => DropdownMenuItem(
          value: listUserType![i]["id"],
          child: Text(listUserType![i]['name']),
        ),
      );
    }
    print(listUserType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(2.w),
          child: Text(
            widget.title != null ? widget.title! : "Input Label",
            style: TextStyle(
              color: tcolor,
              fontSize: 15.sp,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: tcolor),
            borderRadius: BorderRadius.all(
              Radius.circular(2.w),
            ),
          ),
          child: DropdownButtonFormField<int>(
            dropdownColor: Colors.teal[100],
            iconEnabledColor: tcolor,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: TextStyle(color: tcolor, fontSize: 13.sp),
            hint: Text(
              widget.fieldtext != null ? widget.fieldtext! : "Input Hint",
            ),
            items: department,
            value: selectedDep,
            onChanged: (value) async {
              setState(() {
                selectedDep = value;
              });
              // Map findproductDiteils = {
              //   "id": value.toString(),
              // };
              // var url = "http://admin.mrbakerbd.com/public/api/productdetail";
              // var resProductDiteils =
              //     await http.post(url, body: findproductDiteils);
              // if (resProductDiteils.body != null &&
              //     resProductDiteils.body != '[]') {
              //   setState(() {
              //     _productDiteile = jsonDecode(resProductDiteils.body);
              //   });
              // }
            },
          ),
        ),
      ],
    );
  }
}
