import 'package:flutter/material.dart';
import '../../features/add-data/views/add_data_view.dart';
import '../../features/download-master/views/download_master_view.dart';
import '../../features/login/views/login_view.dart';
import '../../features/push-data/views/push_data_view.dart';
import '../../features/splash/views/splash_view.dart';
import 'router_constant.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const LoginView(),
        );
      case Routes.downloadData:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const DownloadMasterView(),
        );
      case Routes.pushData:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const PushDataView(),
        );
      case Routes.addData:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const AddDataView(),
        );
      case Routes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const SplashView(),
        );
      // case Routes.profileNakes:
      //   final data = args as ProfileNakesArgsModel;

      //   return MaterialPageRoute(
      //     settings: settings,
      //     builder: (_) => ProfileNakesView(args: data),
      //   );
      default:
        return _notFoundPage();
    }
  }

  static Route<dynamic> _notFoundPage() => MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Error!')),
          body: const Center(child: Text('Page not found!')),
        ),
      );
}
