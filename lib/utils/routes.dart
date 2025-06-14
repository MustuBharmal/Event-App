import 'package:ems/views/create_event/add_participating_community.dart';
import 'package:ems/views/create_event/bindings/create_event_binding.dart';
import 'package:ems/views/event_page/binding/event_page_binding.dart';
import 'package:ems/views/event_page/event_page_view.dart';
import 'package:ems/views/event_page/event_participants_list_view.dart';
import 'package:ems/views/home/bottom_bar_view.dart';
import 'package:ems/views/home/bindings/home_binding.dart';
import 'package:ems/views/profile/add_profile.dart';
import 'package:ems/views/profile/bindings/profile_binding.dart';
import 'package:ems/views/registration/binding/registration_binding.dart';
import 'package:ems/views/event_page/view_event_end_details.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../views/auth/bindings/login_binding.dart';
import '../views/auth/login_signup.dart';
import '../views/registration/register_event_view.dart';
import '../views/splash_screen.dart';

class AppRoutes {
  static List<GetPage> pages = [
    GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
    GetPage(
        name: LoginView.routeName,
        page: () => LoginView(),
        binding: LoginBinding()),
    GetPage(
        name: BottomBarView.routeName,
        page: () => const BottomBarView(),
        bindings: [HomeBinding(), CreateEventBinding(), ProfileBinding()]),
    GetPage(
      name: AddProfileScreen.routeName,
      page: () => AddProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
        name: EventPageView.routeName,
        page: () => const EventPageView(),
        binding: EventPageBinding()),
    GetPage(
        name: EventParticipantListView.routeName,
        page: () => const EventParticipantListView()),
    GetPage(
        name: ViewEndEventDetails.routeName,
        page: () => const ViewEndEventDetails(),
        binding: RegistrationBinding()),
    GetPage(
        name: AddParticipatingCommunity.routeName,
        page: () =>  AddParticipatingCommunity(),
        binding: CreateEventBinding()),
    GetPage(
      name: RegisterEventView.routeName,
      page: () => RegisterEventView(),
      binding: RegistrationBinding(),
    ),
  ];
}
