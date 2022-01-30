import 'package:flutter/material.dart';
import 'pages/error_page.dart';
import 'pages/product_insert.dart';
import 'pages/product_view.dart';
import 'pages/singal_product.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;
    // print(auth.toMap());
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => FirstPage());

      case '/singal_product':
        if (settings.arguments != null) {
          return MaterialPageRoute(
              builder: (_) => SingalProduct(data: settings.arguments));
        }
        return MaterialPageRoute(builder: (_) => FirstPage());

      case '/product_insert':
        return MaterialPageRoute(builder: (_) => SecendPage());

      // case '/profile':
      //   if (auth.get(0) != null) {
      //     return MaterialPageRoute(builder: (_) => ProfilePage());
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());

      // case '/makeappoint':
      //   if (auth.get(0) != null) {
      //     return MaterialPageRoute(
      //         builder: (_) => MakeAppointment(doAss: settings.arguments));
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());

      // case '/b_shareholder':
      //   if (auth.get(0) != null) {
      //     return MaterialPageRoute(builder: (_) => Shareholder());
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());

      // case '/b_doctor':
      //   if (auth.get(0) != null) {
      //     return MaterialPageRoute(builder: (_) => Doctor());
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());
      // case '/s_doctor':
      //   if (auth.get(0) != null) {
      //     return MaterialPageRoute(builder: (_) => Dsearch());
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());
      // case '/doctor_details':
      //   if (auth.get(0) != null && settings.arguments is Map) {
      //     return MaterialPageRoute(
      //         builder: (_) => DoctorDetails(doctor: settings.arguments));
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());
      // case '/b_assistant':
      //   if (auth.get(0) != null) {
      //     return MaterialPageRoute(builder: (_) => Assistant());
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());
      // case '/s_assistant':
      //   if (auth.get(0) != null) {
      //     return MaterialPageRoute(builder: (_) => Asearch());
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());
      // case '/assistant_details':
      //   if (auth.get(0) != null && settings.arguments is Map) {
      //     return MaterialPageRoute(
      //         builder: (_) => AssistantDetails(assistant: settings.arguments));
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());
      // case '/myappointment':
      //   if (auth.get(0) != null) {
      //     return MaterialPageRoute(builder: (_) => MyAppointment());
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());
      // case '/docappoint':
      //   if (auth.get(0) != null) {
      //     return MaterialPageRoute(builder: (_) => DocAppointment());
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());
      // case '/assappoint':
      //   if (auth.get(0) != null) {
      //     return MaterialPageRoute(builder: (_) => AssAppointment());
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());
      // case '/installments':
      //   if (auth.get(0) != null && settings.arguments is Map) {
      //     return MaterialPageRoute(
      //         builder: (_) => PackageInst(
      //               package: settings.arguments,
      //             ));
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());
      // case '/shareholder':
      //   if (auth.get(0) != null && settings.arguments is List) {
      //     return MaterialPageRoute(
      //         builder: (_) => ShareHolderPack(
      //               packages: settings.arguments,
      //             ));
      //   }
      //   return MaterialPageRoute(builder: (_) => HomeSplash());
      // case '/login':
      //   return MaterialPageRoute(builder: (_) => HomeSplash());

      // case '/register':
      //   return MaterialPageRoute(builder: (_) => RegisterPage());

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) => ErrorPage(errorLog: "Page not found"));
    }
  }
}
