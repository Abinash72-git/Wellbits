import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellbits/providers/user_provider.dart';
import 'package:wellbits/route_generator.dart';
import 'package:wellbits/util/constant_image.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    getconnect_status();
    _getData();
    super.initState();

    Timer(Duration(seconds: 13), () async {
      //WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      navigate(token);
      // runApp(MaterialApp(home: token == null ? Login() : Homepage()));
    });
  }

  Future _getData() async {
    await context.read<UserProvider>().initialFetch();
  }

  navigate(token) async {
    if (token == null) {
      AppRouteName.introPage.push(
        context,
      );
    } else {
      AppRouteName.introPage.pushAndRemoveUntil(context, (route) => false);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ConstantImageKey.IntroGif),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void getconnect_status() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // I am connected to a mobile network.
      _showalert();
    }
  }

  _showalert() async {
    showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Network Status'),
            content: new Text('You are not connect with internet'),
            actions: <Widget>[
              new ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text('Ok'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
