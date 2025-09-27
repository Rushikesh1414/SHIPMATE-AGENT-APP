
import 'package:flutter/material.dart';
import 'package:shipmate_agent_app/core/routes/app_routes.dart';
import 'package:shipmate_agent_app/core/storage/app_storage.dart';
import 'package:shipmate_agent_app/core/widgets/snackbar_widget.dart';


import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp.router(
        scaffoldMessengerKey: AppSnackBar.scaffoldMessengerKey,
        title: 'Flutter Demo',
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
