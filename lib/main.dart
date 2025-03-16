import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_tris_manager/pages/landing_page.dart';
import 'package:il_tris_manager/pages/menu_bloc_page.dart';
import 'package:il_tris_manager/pages/orari_page.dart';
import 'package:il_tris_manager/pages/query_page.dart';
import 'package:pizzeria_model_package/blocs/businesshours/businesshours_bloc.dart';
import 'package:pizzeria_model_package/blocs/product/product_bloc.dart';
import 'package:il_tris_manager/color_schemes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: "admin@iltrispizzeria.it", password: "P1zz3ria73!");

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => ProductBloc(),
      ),
      BlocProvider(
        create: (context) => BusinesshoursBloc(),
        lazy: true,
      )
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
    return Sizer(
      builder: (p0, p1, p2) => ToastificationWrapper(
        child: MaterialApp(
          title: 'Manager',
          debugShowCheckedModeBanner: false,
          theme: MaterialTheme(Theme.of(context).textTheme).dark(),
          routes: {
            MenuBlocPage.routeName: (context) => MenuBlocPage(),
            OrariPage.routeName: (context) => OrariPage(),
            QueryPage.routeName: (context) => QueryPage(),
            LandingPage.routeName: (context) => LandingPage(),
          },
          initialRoute: LandingPage.routeName,
        ),
      ),
    );
  }
}
