import 'package:get/get.dart';
import 'package:shipmate_agent_app/core/routes/app_routes.dart';
import 'package:shipmate_agent_app/core/widgets/snackbar_widget.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () {
      router.go('/sign_up_screen');
      // final user = FirebaseAuth.instance.currentUser;

      // if (user != null) {

      //   AppSnackBar.show(" ✅   Welcome back", backgroundColor: AppColors.greenColor);
      // } else {
      //   router.go('/sign_up_screen');
      // }
    });
  }
}
