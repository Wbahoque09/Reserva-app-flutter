import 'package:flutter/material.dart';

import 'presentation/routes/app_routes.dart';
import 'presentation/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: appRoutes,
      initialRoute: Routes.ONBORDING,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
      ),
    );
  }
}
