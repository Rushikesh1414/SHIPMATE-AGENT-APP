import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shipmate_agent_app/core/theme/app_colors.dart';

class BottomNavigatorBar extends StatefulWidget {
  const BottomNavigatorBar({super.key});

  @override
  State<BottomNavigatorBar> createState() => _BottomNavigatorBarState();
}

class _BottomNavigatorBarState extends State<BottomNavigatorBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
      // Hardcoded routes based on index
      if (index == 0) {
        context.go('/home_screen');
      } else if (index == 1) {
        context.go('/profile_screen');
      } else if (index == 2) {
        context.go('/send_a_package_screen');
      } else if (index == 1) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.whiteColor,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Home",
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.track_changes_outlined),
        //   activeIcon: Icon(Icons.track_changes),
        //   label: "Track",
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.local_shipping_outlined),
        //   activeIcon: Icon(Icons.local_shipping),
        //   label: "Ship",
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
