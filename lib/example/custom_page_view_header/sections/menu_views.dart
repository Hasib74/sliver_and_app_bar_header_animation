import 'package:flutter/material.dart';

class MenuViewScreen extends StatefulWidget {
  const MenuViewScreen({Key? key}) : super(key: key);


  @override
  State<MenuViewScreen> createState() => _MenuViewScreenState();
}

class _MenuViewScreenState extends State<MenuViewScreen> {
  @override
  Widget build(BuildContext context) {
    return   SliverPersistentHeader(
      delegate: _SliverTabBarDelegate(
        const TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: "Home"),
            Tab(text: "Profile"),
            Tab(text: "Settings"),
          ],
        ),
      ),
      pinned: true,
    );
  }
}


class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}