import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellbits/Pages/splash_page.dart';
import 'package:wellbits/config/app_theme.dart';
import 'package:wellbits/providers/user_provider.dart';
import 'package:wellbits/route_generator.dart';
import 'package:wellbits/util/app_constant.dart';

ValueNotifier<bool> isDevicePreviewEnabled = ValueNotifier<bool>(true);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
   Widget build(BuildContext context) {
    return  AppThemeData(
      data: AppThemes(ThemeMode.light).customTheme,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => UserProvider()),
        ],
        child: MaterialApp(
          localizationsDelegates: const [],
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.of(context).textScaler.clamp(
                    minScaleFactor: 0.5, maxScaleFactor: 1.5),
              ),
              child: child!,
            );
          },
          navigatorKey: AppConstants.navigatorKey,
          useInheritedMediaQuery: true,
          onGenerateRoute: RouteGenerator.generateRoute,
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppThemes(ThemeMode.light).theme,
          darkTheme: AppThemes(ThemeMode.dark).theme,
          themeMode: ThemeMode.light,
          home: Splash(),
        ),
      ),
    );
  }
}