import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shipmate_agent_app/core/routes/app_routes.dart';

class SignUpController extends GetxController {
  String? userName;
  String? photo;
  String? email;
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Future<void> sendOtp() async {
    router.go('/home_screen');
  }
}
