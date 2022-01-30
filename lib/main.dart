import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';
import 'package:themelooks/route_genertor.dart';

void main() async {
  Map<String, String> loadData = {
    "apiurl": "http://themelook.ransolutions.net/api/",
    "tcolor": "0xFF00323D"
  };
  await dotenv.load(fileName: "assets/.env", mergeWith: loadData);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final pageController = PageController(initialPage: 0);

  final tcolor = Color(int.parse(dotenv.get('tcolor')));

  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = tcolor
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskType = EasyLoadingMaskType.black
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..animationStyle = EasyLoadingAnimationStyle.scale;
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Theme Looks',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        // home: PageView(
        //   controller: pageController,
        //   children: const [FirstPage(), SecendPage()],
        // ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        builder: EasyLoading.init(),
      );
    });
  }
}
