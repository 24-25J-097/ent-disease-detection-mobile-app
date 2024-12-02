import 'package:ent_insight_app/providers/app_provider.dart';
import 'package:ent_insight_app/routes/app_routes.dart';
import 'package:ent_insight_app/screens/init/SplashScreen.dart';
import 'package:ent_insight_app/utils/theme_consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';


import 'firebase_options.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  app = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  auth = FirebaseAuth.instanceFor(app: app);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ENT Insight',
      theme: ThemeConsts.lightTheme,
      // darkTheme: ThemeConsts.darkTheme,
      home: const SplashScreen(),
      routes: routes,
      builder: EasyLoading.init(),
    );
  }
}
