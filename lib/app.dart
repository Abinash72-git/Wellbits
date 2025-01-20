import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellbits/Pages/app_pages.dart';
import 'package:wellbits/Pages/booking/bookin_page.dart';
import 'package:wellbits/Pages/booking/booking_confirm_page.dart';
import 'package:wellbits/Pages/booking/slot_page.dart';
import 'package:wellbits/Pages/intro_slider.dart';
import 'package:wellbits/Pages/otp.dart';
import 'package:wellbits/Pages/register_app_pages.dart';
import 'package:wellbits/Pages/splash_page.dart';
import 'package:wellbits/Pages/summary_page.dart';
import 'package:wellbits/config/app_theme.dart';
import 'package:wellbits/flavours.dart';
import 'package:wellbits/providers/user_provider.dart';
import 'package:wellbits/route_generator.dart';
import 'package:wellbits/util/app_constant.dart';

ValueNotifier<bool> isDevicePreviewEnabled = ValueNotifier<bool>(false);
bool testingMode = kDebugMode && F.appFlavor == Flavor.dev;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isDevicePreviewEnabled,
        builder: (context, value, __) {
          return AppThemeData(
            data: AppThemes(ThemeMode.light).customTheme,
            child: DevicePreview(
                enabled: F.appFlavor != Flavor.prod ? value : false,
                // useInheritedMediaQuery:true,
                builder: (context) {
                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (ctx) => UserProvider()),
                    ],
                    child: MaterialApp(
                        localizationsDelegates: const [],
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              textScaler: MediaQuery.of(context)
                                  .textScaler
                                  .clamp(
                                      minScaleFactor: 0.5, maxScaleFactor: 1.5),
                            ),
                            child: child!,
                          );
                        },
                        // supportedLocales: context.supportedLocales,
                        // locale: context.locale,
                        navigatorKey: AppConstants.navigatorKey,
                        // ignore: deprecated_member_use
                        useInheritedMediaQuery: true,
                        onGenerateRoute: RouteGenerator.generateRoute,
                        title: AppConstants.appName,
                        debugShowCheckedModeBanner: false,
                        theme: AppThemes(ThemeMode.light).theme,
                        darkTheme: AppThemes(ThemeMode.dark).theme,
                        themeMode: ThemeMode.light,
                        home: RegisterAppPages(tabNumber: 0,)),
                  );
                }),
          );
        });
  }
}
