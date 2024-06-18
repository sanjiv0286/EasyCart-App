// import 'package:easymart/Users/UserPreferences/current_user.dart';
// import 'package:easymart/Users/fragments/favourite_fragment_screen.dart';
// import 'package:easymart/Users/fragments/home_fragment_screen.dart';
// import 'package:easymart/Users/fragments/order_fragment_screen.dart';
// import 'package:easymart/Users/fragments/profile_fragment_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DashboardOfFragments extends StatelessWidget {
//   final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
//   DashboardOfFragments({super.key});

//   final List<Widget> fragmentScreens = [
//     const HomeFragmentScreen(),
//     const FavoritesFragmentScreen(),
//     const OrderFragmentScreen(),
//     const ProfileFragmentScreen(),
//   ];
//   final List<Map<String, dynamic>> navigationButtonsProperties = [
//     {
//       "active_icon": Icons.home,
//       "non_active_icon": Icons.home_outlined,
//       "label": "Home",
//     },
//     {
//       "active_icon": Icons.favorite,
//       "non_active_icon": Icons.favorite_border,
//       "label": "Favorites",
//     },
//     {
//       "active_icon": Icons.shopping_cart,
//       "non_active_icon": Icons.shopping_cart_outlined,
//       "label": "Orders",
//     },
//     {
//       "active_icon": Icons.person,
//       "non_active_icon": Icons.person_outline,
//       "label": "Profile",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder(
//       init: CurrentUser(),
//       initState: (currentState) {
//         _rememberCurrentUser.getUserInfo();
//       },
//       builder: (controller) {
//         return Scaffold(
//           // appBar: AppBar(
//           //    const Text(
//           //    'Screen',
//           //   ),
//           // backgroundColor: Colors.blueGrey,
//           // ),
//           appBar: AppBar(
//             title: const Text(
//               'Dashboard Screen',
//               style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
//             ),
//             backgroundColor: Colors.blue,
//           ),

//           body: const Center(
//             child: Text(
//               "Dashboard Screen",
//             ),
//           ),
//         );
//       },
//     ); // GetBuilder
//   }
// }
// *****************************************************************************

import 'package:easymart/Users/fragments/favourite_fragment_screen.dart';
import 'package:easymart/Users/fragments/home_fragment_screen.dart';
import 'package:easymart/Users/fragments/order_fragment_screen.dart';
import 'package:easymart/Users/fragments/profile_fragment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easymart/Users/UserPreferences/current_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardOfFragments extends StatelessWidget {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  DashboardOfFragments({super.key});

  final List<Widget> fragmentScreens = [
    HomeFragmentScreen(),
    FavoritesFragmentScreen(),
    OrderFragmentScreen(),
    ProfileFragmentScreen(),
  ];

  final List<Map<String, dynamic>> navigationButtonsProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": Icons.favorite,
      "non_active_icon": Icons.favorite_border,
      "label": "Favorites",
    },
    {
      "active_icon": Icons.shopping_cart,
      // "active_icon": FontAwesomeIcons.boxOpen,
      "non_active_icon": FontAwesomeIcons.box,
      "label": "Orders",
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline,
      "label": "Profile",
    },
  ];
  final RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrentUser>(
      init: _rememberCurrentUser,
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
            backgroundColor: Colors.black,
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   title: const Center(
            //     child: Text(
            //       'Clothes Item',
            //       style: TextStyle(color: Colors.black87),
            //     ),
            //   ),
            //   backgroundColor: Colors.white,
            // ),
            body: SafeArea(
              child: Obx(() => fragmentScreens[_indexNumber.value]),
            ),
            bottomNavigationBar: Obx(
              () => BottomNavigationBar(
                currentIndex: _indexNumber.value,
                onTap: (value) {
                  _indexNumber.value = value;
                },
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.blue,
                items: List.generate(
                  4,
                  (index) {
                    var navBtnProperty = navigationButtonsProperties[index];
                    return BottomNavigationBarItem(
                      backgroundColor: Colors.black,
                      icon: Icon(navBtnProperty["non_active_icon"]),
                      activeIcon: Icon(navBtnProperty["active_icon"]),
                      label: navBtnProperty["label"],
                    );
                  },
                ),
              ),
            ));
      },
    );
  }
}
