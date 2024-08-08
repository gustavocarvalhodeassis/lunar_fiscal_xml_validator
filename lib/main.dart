import 'package:fiscal_validator/content/home/controllers/home_provider.dart';
import 'package:fiscal_validator/content/home/pages/home_page.dart';
import 'package:fiscal_validator/global/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
      ],
      child: MaterialApp(
        theme: appThemeData,
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
