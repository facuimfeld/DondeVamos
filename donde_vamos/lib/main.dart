import 'dart:io';

import 'package:donde_vamos/blocs/event_bloc/event_bloc.dart';
import 'package:donde_vamos/device/permission_handler.dart';
import 'package:donde_vamos/firebase_options.dart';
import 'package:donde_vamos/resources/event_repository.dart';
import 'package:donde_vamos/ui/home/home.dart';
import 'package:donde_vamos/ui/permission/permission.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainBloc());
}

class MainBloc extends StatelessWidget {
  const MainBloc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => EventRepository()),
          //RepositoryProvider(create: (context) => AuthRepository('', '')),
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider(
              create: ((context) => EventBloc(repository: EventRepository()))),
        ], child: MyApp()));
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool permissionStatus = false;

  @override
  void initState() {
    getStatusGPS();
    super.initState();
  }

  Future<void> getStatusGPS() async {
    permissionStatus = await Permissions().getCurrentStatusGPS();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Donde Vamos',
      home: permissionStatus == true ? Home() : const Permission(),
    );
  }
}
