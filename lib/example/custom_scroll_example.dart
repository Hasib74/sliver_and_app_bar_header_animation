import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

class ComplexNestedScrollView extends StatefulWidget {
  const ComplexNestedScrollView({Key? key}) : super(key: key);

  @override
  State<ComplexNestedScrollView> createState() =>
      _ComplexNestedScrollViewState();
}

class _ComplexNestedScrollViewState extends State<ComplexNestedScrollView>
    with SingleTickerProviderStateMixin {
  AnimationController? exampleController;
  Animation<double>? exampleAnimation;

  List<IconData> profileIcons = [];

  ScrollController? _scrollController;
  bool _isUserScrolling = false;

  void _onScroll() {
    // Check if user scrolling has stopped

    print("""Offset:-> ${_scrollController!.offset}""");
    if (!_scrollController!.position.isScrollingNotifier.value == true &&
        !_isUserScrolling) {
      // If offset > 150, auto-scroll to 300
      if (_scrollController!.offset > 150 && _scrollController!.offset < 300) {
        _scrollTo(300);
      } else if (_scrollController!.offset < 150) {
        _scrollTo(0);
      }
    }
  }

  void _scrollTo(double offset) {
    _scrollController!.animateTo(
      offset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  initState() {
    super.initState();

    _scrollController = ScrollController();
    // Listen to scroll events
    _scrollController!.addListener(_onScroll);
    exampleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 500),
    );

    exampleAnimation = CurvedAnimation(
      parent: exampleController!,
      curve: Curves.fastOutSlowIn,
    );

    profileIcons = [
      Icons.phone,
      Icons.email,
      Icons.translate,
      Icons.map,
    ];
  }

  double roundCircleRadius = 70;
  double iconSize = 50;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        body: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) {
            print(
                """details.velocity.pixelsPerSecond.y: ${details.velocity.pixelsPerSecond.dy}""");
          },
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                // SliverAppBar with flexible space
                SliverAppBar(
                  expandedHeight: 300.0,

                  // Height of the AppBar when expanded

                  collapsedHeight: 90,
                  // Minimum height when collapsed

                  floating: false,
                  pinned: true,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      print("scrollOffset: ${constraints.biggest.height}");
                      // Calculate the scroll offset
                      const double expandedHeight = 300.0;
                      final double scrollOffset = constraints.biggest.height;
                      const double fadeStart = 200.0;
                      const double fadeEnd = 300.0;

                      const double minHeight = 100.0;

                      // Calculate opacity for fade transition

                      //  var profileImageTransaction =

                      final double profilePosition =
                          (scrollOffset - fadeStart) / (fadeEnd - fadeStart);

                      final double opacity =
                          (scrollOffset - fadeStart) / (fadeEnd - fadeStart);

                      var calimprofilePosition =
                          profilePosition.clamp(0.0, 1.0);

                      print(
                          """opacity calculations: ($scrollOffset - $fadeStart) / ($fadeEnd - $fadeStart)""");
                      final double clampedOpacity = opacity.clamp(0.0, 1.0);

                      // Calculate opacity for scale transition
                      final double scale = scrollOffset / expandedHeight;
                      final double clampedScale = scale.clamp(0.0, 1.0);

                      var leftValue =
                          MediaQuery.of(context).size.width * 0.5 - 50;

                      double tempButtonScale = 0.0;

                      final double buttonScale =
                          (1 - pow(scale, 3)).clamp(0.0, 1.0).toDouble();

                      if (buttonScale < 0.5) {
                        tempButtonScale = buttonScale * 0.3;
                      } else {
                        tempButtonScale = buttonScale * 1.4;
                      }

                      print("clampedScale: $clampedScale");
                      print("clampedOpacaity: $clampedOpacity");

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background image
                          Image.network(
                            'https://images.pexels.com/photos/235986/pexels-photo-235986.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                            fit: BoxFit.cover,
                          ),

                          const Positioned.fill(
                              child: ColoredBox(
                            color: Colors.black54,
                          )),
                          // Icons Row (at the bottom of the image)

                          // Title (appears during scroll)

                          Opacity(
                            opacity: clampedOpacity,
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                      visible:
                                          scrollOffset < 340 ? false : true,
                                      replacement: SizedBox(
                                        height: 50,
                                        width: 50,
                                      ),
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                      )),
                                  SizedBox(
                                    height: 16 * 5,
                                  ),
                                  Text(
                                    "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  Text(
                                    "hasibakon74@gmail.com",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.0),
                                  ),
                                  Text(
                                    "+8801712345678",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /*  Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Opacity(
                              opacity: 1,
                              // Fade out the icons as we scroll
                              child: Transform.scale(
                                scale: 1 - tempButtonScale,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    iconBackground(
                                        icon: Icon(
                                          Icons.phone,
                                          size: 30,
                                        ),
                                        clampedOpacity: clampedOpacity),
                                    iconBackground(
                                      icon: Icon(Icons.email,
                                          size: 30, color: Colors.white),
                                      clampedOpacity: clampedOpacity,
                                    ),
                                    iconBackground(
                                      icon: Icon(Icons.verified_user,
                                          size: 30, color: Colors.white),
                                      clampedOpacity: clampedOpacity,
                                    ),
                                    iconBackground(
                                      icon: const Icon(Icons.settings,
                                          size: 30, color: Colors.white),
                                      clampedOpacity: clampedOpacity,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),*/

                          // CircleAvatar Transition to Leading
                          Positioned(
                            // duration: const Duration(milliseconds: 300),
                            left: leftValue -
                                (leftValue * (1 - calimprofilePosition)),
                            top: MediaQuery.of(context).size.height * 0.11 -
                                (MediaQuery.of(context).size.height *
                                    0.11 *
                                    (1 - calimprofilePosition)) +
                                ((1 - calimprofilePosition) * 32),
                            child: Transform(
                              /// scale: clampedScale,
                              alignment: Alignment.center,
                              // Ensure the rotation happens around the center

                              transform: Matrix4.identity()
                                ..rotateZ((1 - calimprofilePosition) * 2 * pi)
                                ..scale(clampedScale),
                              child: CircleAvatar(
                                backgroundImage: const NetworkImage(
                                  'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                                ),
                                radius: 50.0,
                              ),
                            ),
                          ),

                          Transform.translate(
                            /*  left: leftValue+120 -
                                (leftValue * (1 - calimprofilePosition)),
                            top: MediaQuery.of(context).size.height * 0.235 -
                                (MediaQuery.of(context).size.height *
                                    0.235 *
                                    (1 - calimprofilePosition)) +
                                ((1 - calimprofilePosition) * 32),*/

                            offset: Offset(
                                (expandedHeight * 0.47) -
                                    ((expandedHeight * 0.19) *
                                        (1 - calimprofilePosition)),
                                (expandedHeight * 0.67 -
                                    ((expandedHeight * 0.48) *
                                        (1 - calimprofilePosition)))),
                            child: const Text(
                              "Hasib Akon",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),

                          Opacity(
                            opacity: (1 - calimprofilePosition),
                            child: Transform.translate(
                              /*  left: leftValue+120 -
                                  (leftValue * (1 - calimprofilePosition)),
                              top: MediaQuery.of(context).size.height * 0.235 -
                                  (MediaQuery.of(context).size.height *
                                      0.235 *
                                      (1 - calimprofilePosition)) +
                                  ((1 - calimprofilePosition) * 32),*/

                              offset: Offset(
                                  (expandedHeight * 0.465) -
                                      ((expandedHeight * 0.18) *
                                          (1 - calimprofilePosition)),
                                  85),
                              child: const Text(
                                "+8801727123374",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),

                          rotted_buttons(expandedHeight, clampedScale, context,
                              clampedOpacity)
                        ],
                      );
                    },
                  ),
                ),
                // TabBar in SliverPersistentHeader
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
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                // Tab 1: Scrollable List
                ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.home),
                        title: Text('Home Item $index'),
                      ),
                    );
                  },
                ),
                // Tab 2: Scrollable Grid
                GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.blueAccent,
                      child: Center(
                        child: Text(
                          'Profile $index',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
                // Tab 3: Static Content
                Center(
                  child: Text(
                    "Settings Tab Content",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  rotted_buttons(double expandedHeight, double clampedScale,
      BuildContext context, double clamp) {
    clampedScale = clamp;
    return Positioned(
        top: (expandedHeight - 18) - ((1 - clamp) * (expandedHeight - 80) + 2),
        // right: (MediaQuery.of(context).size.width * 0.16) +
        //     (clamp * MediaQuery.of(context).size.width * 0.56 +
        //         (1 - clamp) * 60),

        left: (MediaQuery.of(context).size.width * 0.18) +
            ((1 - clamp) * MediaQuery.of(context).size.width * 0.43),
        right: 0,

        // right: 100,
        // left: 0,
        child: Container(
          ///  color: Colors.red,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: profileIcons
                .take(profileIcons.length)
                .toList()
                .asMap()
                .entries
                .map((entry) {
              int index = entry.key;
              IconData element = entry.value;

              // Calculate spacing for horizontal layout
              var offsetX, offsetY, angle;

              angle = (2 * pi / profileIcons.length) * index +
                  1 -
                  (clampedScale * pi * 2);

              var space = clamp < 0.5 ? 35 : 75;

              offsetX = lerpDouble(
                  roundCircleRadius * cos(angle), // Circular X
                  index * space, // Horizontal X
                  clamp > 0.5
                      ? (pow(clamp, 5)).toDouble()
                      : pow(1 - clamp, 5).toDouble());

              offsetY = lerpDouble(
                  roundCircleRadius * sin(angle) -
                      ((roundCircleRadius * sin(angle)) *
                          (clamp > 0.5
                              ? (pow(clamp, 5))
                              : pow(1 - clamp, 5))), // Circular Y
                  1, // Horizontal Y
                  clamp);

              return Transform.translate(
                filterQuality: FilterQuality.low,
                offset:
                    Offset(offsetX, double.parse(offsetY.toStringAsFixed(2))),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  // Ensure gesture detection
                  onTap: () {
                    print("G-> Icon $index clicked");
                  },
                  child: Container(
                    // Make the container transparent
                    child: iconBackground(
                        index: index,
                        clampedOpacity: 1,
                        icon: Icon(element),
                        size: clamp < 0.5
                            ? lerpDouble(25, 10, (1 - clamp))
                            : lerpDouble(10, 25, clamp)),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  Positioned rotted_buttonsV2(double expandedHeight, double clampedScale,
      BuildContext context, double clamp) {
    clampedScale = clamp;
    return Positioned(
        top: (expandedHeight) - ((1 - clamp) * (expandedHeight - 60) + 2),
        right: (MediaQuery.of(context).size.width * 0.16) +
            (clamp * MediaQuery.of(context).size.width * 0.56 +
                (1 - clamp) * 60),
        child: Transform.scale(
          scale: 1,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: profileIcons
                  .take(profileIcons.length)
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key;
                IconData element = entry.value;

                // Calculate spacing for horizontal layout

                // Determine if we are in horizontal or circular layout
                //   bool isHorizontal = clampedScale < 0.5 ; //

                var offsetX, offsetY, angle;

                angle = (2 * pi / profileIcons.length) * index +
                    1 -
                    (clampedScale * pi * 2);
                ;

                print("clamp: $clamp");

                if (false) {
                  // Horizontal layout for first three icons
                  offsetY = 0;
                } else {
                  // Circular layout
                  // angle -= (clampedScale * 2 * pi) / 2;

                  var space = clamp < 0.5 ? 35 : 75;

                  offsetX = lerpDouble(
                      roundCircleRadius * cos(angle), // Circular X
                      index * space, // Horizontal X
                      clamp > 0.5
                          ? (pow(clamp, 5)).toDouble()
                          : pow(1 - clamp, 5).toDouble());
                  /*         offsetX =    clamp > 0.5 ? (index * roundCircleRadius) :  ( roundCircleRadius * cos(angle) )  ; */ /*clamp > 0.5
                      ? (roundCircleRadius * cos(angle))
                      : -1 * roundCircleRadius * cos(angle);
*/
                  offsetY = lerpDouble(
                      roundCircleRadius * sin(angle) -
                          ((roundCircleRadius * sin(angle)) *
                              (clamp > 0.5
                                  ? (pow(clamp, 5))
                                  : pow(1 - clamp, 5))), // Circular Y
                      1, // Horizontal Y
                      clamp);
                  // roundCircleRadius * sin(angle) -
                  //     ((roundCircleRadius * sin(angle)) *
                  //         (clamp > 0.5
                  //             ? (pow(clamp, 5))
                  //             : pow(1 - clamp, 5)));
                  print(
                      "index: $index  offsetX: $offsetX offsetY: $offsetY angle: $angle clamp: $clamp ");
                }

                return Transform.translate(
                  filterQuality: FilterQuality.low,
                  offset:
                      Offset(offsetX, double.parse(offsetY.toStringAsFixed(2))),
                  child: Container(
                    color: Colors.amber,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      // Ensure gesture detection

                      onTap: () {
                        print("G->");
                      },

                      child: iconBackground(
                          index: index,
                          clampedOpacity: 1,
                          icon: Icon(element),
                          size: clamp < 0.5
                              ? lerpDouble(25, 10, (1 - clamp))
                              : lerpDouble(10, 25, clamp)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ));
  }

  iconBackground(
      {Icon? icon,
      required double clampedOpacity,
      double? size,
      required int index}) {
    return InkWell(
      onTap: () {
        print("Fk index: ${index}");
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(icon!.icon,
            size: size ?? 30,
            color: clampedOpacity == 1.0 ? Colors.black : Colors.white),
      ),
    );
  }
}

// SliverPersistentHeader Delegate for TabBar
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
