import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellbits/Pages/app_pages.dart';
import 'package:wellbits/Pages/intro_page.dart';
import 'package:wellbits/Pages/login.dart';
import 'package:wellbits/Pages/register_app_pages.dart';
import 'package:wellbits/Pages/splash_page.dart';
import 'package:wellbits/util/extension.dart';

enum AppRouteName {
  splashPage('/splash_page'),
  introPage('/intro_page'),
  login('/login'),
  homepage('/homepage'),
  appPages('/app_pages'),
  registerAppPages('/register_app_pages'),
  addGroup('/add_group'),
  addMember('/add_member'),
  addTask('/add_task'),
  addCommentPage('/add_comment_page'),
  alarmRingPage('/alarm_ring_page'),
  createGroup('/create_group'),
  editGroup('/edit_group'),
  member('/member'),
  notUser('/not_user'),
  taskPage('/task_page');

  /// args: TaskViewScreenArgs

  final String value;
  const AppRouteName(this.value);
}

extension AppRouteNameExt on AppRouteName {
  Future<T?> push<T extends Object?>(BuildContext context,
      {Object? args}) async {
    return await Navigator.pushNamed<T>(context, value, arguments: args);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context,
    bool Function(Route<dynamic>) predicate, {
    Object? args,
  }) async {
    return await Navigator.pushNamedAndRemoveUntil<T>(context, value, predicate,
        arguments: args);
  }

  Future<T?> popAndPush<T extends Object?>(BuildContext context,
      {Object? args}) async {
    return await Navigator.popAndPushNamed(context, value);
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final name = AppRouteName.values
        .where(
          (element) => element.value == settings.name,
        )
        .firstOrNull;
    // settings.name
    switch (name) {
      case AppRouteName.splashPage:
        return MaterialPageRoute(
          builder: (_) => Splash(),
        );
      case AppRouteName.login:
        return MaterialPageRoute(
          builder: (_) => Login(),
        );
        case AppRouteName.introPage:
        return MaterialPageRoute(
          builder: (_) => Intro(),
        );
         case AppRouteName.appPages:
        return MaterialPageRoute(
          builder: (_) => AppPages(tabNumber: 0,),
        );
        case AppRouteName.registerAppPages:
        return MaterialPageRoute(
          builder: (_) => RegisterAppPages(tabNumber: 0,),
        );
      // case AppRouteName.homepage:
      //   return MaterialPageRoute(
      //     builder: (_) => MultiProvider(providers: [
      //       ChangeNotifierProvider(create: (_) => UserProvider()),
      //       ChangeNotifierProvider(create: (_) => GroupProvider()),
      //     ], child: const Homepage()),
      //   );
      // case AppRouteName.createGroup:
      //   return MaterialPageRoute(
      //     builder: (_) => ChangeNotifierProvider(
      //         create: (context) => GroupProvider(), child: Create_group()),
      //   );
      // case AppRouteName.editGroup:
      //   return MaterialPageRoute(
      //     builder: (_) => ChangeNotifierProvider(
      //         create: (context) => GroupProvider(), child: Edit_group()),
      //   );
      // case AppRouteName.addGroup:
      //   return MaterialPageRoute(
      //     builder: (_) => ChangeNotifierProvider(
      //         create: (context) => GroupProvider(), child: AddGroup()),
      //   );
      // case AppRouteName.addMember:
      //   final value = (args as CustomScreenArgs);
      //   return MaterialPageRoute(
      //     builder: (_) => ChangeNotifierProvider(
      //         create: (context) => GroupProvider(),
      //         child: AddMember(
      //           group_id: value.data as String,
      //         )),
      //   );
      // case AppRouteName.addTask:
      //   return MaterialPageRoute(
      //     builder: (_) => ChangeNotifierProvider(
      //         create: (context) => GroupProvider(), child: AddGroup()),
      //   );

      // case AppRouteName.addCommentPage:
      //   return MaterialPageRoute(
      //     builder: (_) => ChangeNotifierProvider(
      //         create: (context) => TaskProvider(), child: AddCommentPage()),
      //   );
      // default:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return Scaffold(
      //         body: Center(
      //           child: Text(
      //             "Route Error",
      //             style: context.textTheme.labelLarge?.copyWith(
      //               color:context.colorScheme.error,
      //             ),
      //           ),
      //         ),
      //       );
      //     },
      //   );
      case null:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: Text(
                  "Route Error",
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.error,
                  ),
                ),
              ),
            );
          },
        );
      default:
        return MaterialPageRoute(
            builder: (_) =>
                const SafeArea(child: Scaffold(body: Text("Route Error"))));
    }
  }
}