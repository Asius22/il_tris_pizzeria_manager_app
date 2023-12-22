import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/bloc/image_bloc.dart';
import 'package:il_tris_manager/bloc/product_bloc.dart';
import 'package:il_tris_manager/color_schemes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:il_tris_manager/pages/home_page.dart';
import 'package:il_tris_manager/pages/image_page.dart';
import 'package:il_tris_manager/pages/login_page.dart';
import './firebase/firebase_options.dart';
import './pages/route_names.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "Il-tris-manager",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => ProductBloc(),
      ),
      BlocProvider(
        create: (context) => ImageBloc(),
        lazy: false,
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'Manager',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          useMaterial3: true,
          hoverColor: Colors.transparent,
          hintColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent),
      theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
      routes: {
        loginRoute: (context) => LoginPage(),
        imageRoute: (context) => const ImagePage(),
        homeRoute: (context) => HomePage(initialRoute: 0)
      },
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? loginRoute : homeRoute,
    );
  }
}
