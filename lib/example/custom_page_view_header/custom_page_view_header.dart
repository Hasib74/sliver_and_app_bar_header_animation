import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:practice/example/custom_page_view_header/sections/header_page.dart';
import 'package:practice/example/custom_page_view_header/sections/menu_views.dart';

class CustomPageViewHeader extends StatefulWidget {
  const CustomPageViewHeader({Key? key}) : super(key: key);

  @override
  State<CustomPageViewHeader> createState() => _CustomPageViewHeaderState();
}

class _CustomPageViewHeaderState extends State<CustomPageViewHeader> {
  var appBarKey = GlobalKey<ScaffoldState>();
  var bodyKey = GlobalKey<ScaffoldState>();
  var footerKey = GlobalKey<ScaffoldState>();

  final ScrollController scrollController = ScrollController();
  double currentPage = 0.0;
  bool isSnapping = false;

  Offset? headerOffset;

  // Offset? bodyOffset;
  //
  // Offset? footerOffset;

  double headerHeight = 300;

  double scrollFraction = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      var header = appBarKey.currentContext?.findRenderObject() as RenderBox;
      //   var body = bodyKey.currentContext?.findRenderObject() as RenderBox;
      //   var footer = footerKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        headerOffset = header.localToGlobal(Offset.zero);
        // bodyOffset = body.localToGlobal(Offset.zero);
        //    footerOffset = footer.localToGlobal(Offset.zero);
      });
    });

    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    print("On Scroll ....");
    if (!isSnapping) {
      final pageWidth = headerOffset?.dy ?? 0;
      setState(() {
        currentPage = scrollController.offset / pageWidth;
      });
    }

    if (scrollController.offset < headerHeight) {
      setState(() {
        scrollFraction = (scrollController.offset / headerHeight).clamp(0, 1);

        print("Scroll fraction: $scrollFraction");
      });
    }
  }

  void _snapToPage() {
    final pageWidth = headerOffset!.dy;
    final targetPage = (scrollController.offset / pageWidth).round();
    setState(() {
      isSnapping = true;
    });
    // scrollController
    //     .animateTo(
    //   targetPage * pageWidth,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // )
    //     .then((_) {
    //   setState(() {
    //     isSnapping = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SafeArea(
            child: GestureDetector(
                onPanEnd: (_) {
                  _snapToPage();
                },
                child: CustomScrollView(
                  controller: scrollController,
                  physics:
                      HeaderPageViewScrollPhysics(headerHeight: headerHeight),
                  slivers: [
                    // First sliver: Custom widget
                    SliverToBoxAdapter(
                      child: BurgerXpressScreen(
                        fraction: scrollFraction,
                      ),
                    ),

                    // Second sliver: Persistent header (TabBar)
                    SliverPersistentHeader(
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
                      pinned: true, // Keeps the header pinned at the top
                    ),

                    // Third sliver: List items
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.fastfood),
                            title: Text("Item $index"),
                          );
                        },
                        childCount: 20, // Number of list items
                      ),
                    ),
                  ],
                )),
          ),
        ));
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

class HeaderPageViewScrollPhysics extends ScrollPhysics {
  final double headerHeight;

  const HeaderPageViewScrollPhysics({
    required this.headerHeight,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  HeaderPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return HeaderPageViewScrollPhysics(
      headerHeight: headerHeight,
      parent: buildParent(ancestor),
    );
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // Calculate the current and target page
    //
    // print("Position: ${position.pixels}");
    // print("Velocity: ${velocity}");
    // print("tolerance: ${tolerance}");
    //
    // print("Current page: ${(position.pixels / headerHeight).round()}");
    // print(
    //     "Current page * header height: ${(position.pixels / headerHeight).round() * headerHeight}");
    // print("Current page ceil(): ${(position.pixels / headerHeight).ceil()}");
    // print(
    //     "Current page ceil() * header height: ${(position.pixels / headerHeight).ceil() * headerHeight}");
    // print(
    //     "=============================================================================================");
    //

    final double targetPixels;

    if (position.pixels > headerHeight) {
      if (velocity < 0) {
        // যদি নিচে স্ক্রল করা হয়, তবে থামানো হবে headerHeight পিক্সেলে
        targetPixels = headerHeight;
        return ScrollSpringSimulation(
          spring,
          position.pixels,
          targetPixels,
          velocity,
          tolerance: tolerance,
        );
      }
      // নরমাল স্ক্রল
      return super.createBallisticSimulation(position, velocity);
    }

    if (velocity.abs() < tolerance.velocity) {
      print("page indicator: velocity.abs() < tolerance.velocity");
      // Snap to the closest page
      targetPixels = (position.pixels / headerHeight).round() * headerHeight;
    } else if (velocity > 0) {
      print("page indicator: velocity > 0");

      // Snap to the next page
      targetPixels = ((position.pixels / headerHeight).ceil()) * headerHeight;
    } else {
      print("page indicator: velocity < 0");
      // Snap to the previous page
      targetPixels = ((position.pixels / headerHeight).floor()) * headerHeight;
    }

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      targetPixels,
      velocity,
      tolerance: tolerance,
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.minScrollExtent) {
      return value - position.minScrollExtent;
    } else if (value > position.maxScrollExtent) {
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true;
  }
}
