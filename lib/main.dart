
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hiv3app/data/local_storage.dart';
import 'package:hiv3app/models/task_model.dart';
import 'package:hiv3app/pages/HomePage.dart';
import 'package:hive_flutter/hive_flutter.dart';


final locator = GetIt.instance;
void setup() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> SetupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var TaskBox = await Hive.openBox<Task>("Tasks");
  // for (var element in TaskBox.values) {
  //   if (element.CreatedAt.day != DateTime.now().day) {
  //     TaskBox.delete(element.Id);
  //   }
  // }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await SetupHive();
  setup();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations', // <-- change the path of the translation files 
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp()
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black)),
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
