import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shipmate_agent_app/core/widgets/bottom_nav_bar_widget.dart';
import 'package:shipmate_agent_app/features/authentication/login/login_screen.dart';
import 'package:shipmate_agent_app/features/authentication/signup/sign_up_screen.dart';
import 'package:shipmate_agent_app/features/home/home_screen.dart';
import 'package:shipmate_agent_app/features/manifest/manifest_screen.dart';
import 'package:shipmate_agent_app/features/orders/order_checkout_screen.dart';
import 'package:shipmate_agent_app/features/profile/profile_screen.dart';
import 'package:shipmate_agent_app/features/qrscanner/qr_code_scanner.dart';
import 'package:shipmate_agent_app/features/splash/splash_screen.dart';
import 'package:shipmate_agent_app/features/entries/entries_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash_screen',
  routes: [
    GoRoute(
      path: '/sign_up_screen',
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: '/splash_screen',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/login_screen',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/order_checkout_screen',
      builder: (context, state) => OrderCheckoutScreen(),
    ),
    GoRoute(
      path: '/manifest_screen',
      builder: (context, state) => ManifestScreen(),
    ),
    GoRoute(
      path: '/entries_screen',
      builder: (context, state) => const EntriesScreen(),
    ),
    GoRoute(
      path: '/qr_scan_screen',
      builder: (context, state) => QRScanScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: const BottomNavigatorBar(),
        );
      },
      routes: [
        GoRoute(
          path: '/profile_screen',
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
          path: '/home_screen',
          builder: (context, state) => HomeScreen(),
        ),
      ],
    ),
  ],
);
