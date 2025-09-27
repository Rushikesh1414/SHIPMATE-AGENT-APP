import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipmate_agent_app/core/routes/app_routes.dart';
import 'package:shipmate_agent_app/core/storage/app_storage.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';
import 'package:shipmate_agent_app/core/widgets/snackbar_widget.dart';
import 'package:shipmate_agent_app/features/authentication/signup/controller/sign_up_controller.dart';


import 'package:sizer/sizer.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 70.w,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryColor),
            accountName: Text(
              AppStorage.userName ?? "User Name",
            ),
            accountEmail: Text(
              AppStorage.email!,
            ),
            currentAccountPicture: CircleAvatar(radius: 30, backgroundColor: Colors.white, child: ClipOval(child: Image.network(AppStorage.photo!))),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, '/home'); // Example navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, '/settings');
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () async {
              
              await AppStorage.clearAll();
              AppSnackBar.show("logged out", backgroundColor: AppColors.greenColor, textColor: AppColors.blackColor);
              router.go('/sign_up_screen');
            },
          ),
        ],
      ),
    );
  }
}
