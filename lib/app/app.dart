import 'package:advance_flutter/app/app_prefs.dart';
import 'package:advance_flutter/app/di.dart';
import 'package:advance_flutter/presentation/resources/routes_manager.dart';
import 'package:advance_flutter/presentation/resources/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class MyApp extends StatefulWidget {
  //named constructor
  const MyApp._internal();
  static const MyApp _instance =
      MyApp._internal(); //singleton or single instance
  factory MyApp() => _instance; //factory

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPrefrences _appPrefrences = instance<AppPrefrences>();
  @override
  void didChangeDependencies() {
    _appPrefrences.getlocal().then((local)=>{context.setLocale(local)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: getApplicationTheme(),
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRote,
      debugShowCheckedModeBanner: false,
    );
  }
}
