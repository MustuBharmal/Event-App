import 'package:ems/views/create_event/bindings/create_event_binding.dart';
import 'package:ems/views/home/bottom_bar_view.dart';
import 'package:ems/views/home/bindings/home_binding.dart';
import 'package:ems/views/home/home_screen.dart';
import 'package:ems/views/profile/add_profile.dart';
import 'package:ems/views/profile/bindings/profile_binding.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../views/auth/bindings/login_binding.dart';
import '../views/auth/login_signup.dart';

class AppRoutes {
  static List<GetPage> pages = [
    GetPage(
        name: LoginView.routeName,
        page: () => LoginView(),
        binding: LoginBinding()),
    GetPage(
        name: BottomBarView.routeName,
        page: () => const BottomBarView(),
        bindings: [HomeBinding(), CreateEventBinding()]),
    GetPage(
      name: HomeScreen.routeName,
      page: () => const HomeScreen(),
    ),
    GetPage(
        name: AddProfileScreen.routeName,
        page: () => AddProfileScreen(),
        binding: ProfileBinding()),
  ];
}
