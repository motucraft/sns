import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns/generated/l10n.dart';
import 'package:sns/utils/constant.dart';
import 'package:sns/view/activities/pages/activities_page.dart';
import 'package:sns/view/feed/pages/feed_page.dart';
import 'package:sns/view/post/pages/post_page.dart';
import 'package:sns/view/profile/pages/profile_page.dart';
import 'package:sns/view/search/pages/search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _pages = [];
  int _currentIndex = 0;

  @override
  void initState() {
    _pages = [
      const FeedPage(),
      const SearchPage(),
      const PostPage(),
      const ActivitiesPage(),
      const ProfilePage(
        profileMode: ProfileMode.myself,
        isOpenFromProfileScreen: false,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.house),
            label: S.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: S.of(context).search,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.squarePlus),
            label: S.of(context).add,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.heart),
            label: S.of(context).activities,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.user),
            label: S.of(context).user,
          ),
        ],
      ),
    );
  }
}
