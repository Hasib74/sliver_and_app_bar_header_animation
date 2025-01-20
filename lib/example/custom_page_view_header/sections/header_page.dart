import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BurgerXpressScreen extends StatefulWidget {
  double? fraction = 0.8;

  BurgerXpressScreen({Key? key, this.fraction}) : super(key: key);

  @override
  State<BurgerXpressScreen> createState() => _BurgerXpressScreenState();
}

class _BurgerXpressScreenState extends State<BurgerXpressScreen> {
  ScrollController? scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //
    // scrollController?.animateTo(widget.fraction! * 300,
    //     duration: const Duration(seconds: 400), curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) {
    print("fraction: ${widget.fraction}");
    return SizedBox(
      height: 380,
      child: Scaffold(
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              // Restaurant Name and Logo Section

              // Search Menu Section

              _topSections(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 32 * widget.fraction!,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          // Align text and hint vertically
                          decoration: InputDecoration(
                            hintText: "Search in menu",
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            // Style the prefix icon
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              // Customize hint text color
                              fontSize: 14, // Adjust hint text size
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16),
                            // Padding inside the field
                            filled: true,
                            // Background color
                            fillColor: Colors.grey.shade200,
                            // Light gray background
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              // Rounded corners
                              borderSide: BorderSide(
                                  color: Colors.grey.shade400), // Border color
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: BorderSide(
                                  color: Colors.grey
                                      .shade300), // Light gray border for inactive state
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: BorderSide(
                                  color: Colors.blue
                                      .shade400), // Blue border for focused state
                            ),
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      size: 32 * widget.fraction!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard({required Color color, required String text}) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  _topSections() {
    return Transform.translate(
      offset: Offset(0, -(widget.fraction!) * 10),
      child: Opacity(
        opacity: 1 - widget.fraction!,
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {},
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.share, color: Colors.black),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 60,
              width: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: const Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0Q7WPMZDtsjL3NxC6IQ1J3YcyLz20c6J29w&s")),
              ),
            ),

            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Burger Xpress- Shewrapara",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "4.9 (500+ ratings)",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 8,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delivery Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Row(
                children: [
                  Icon(Icons.delivery_dining, color: Colors.black54),
                  const SizedBox(width: 10),
                  const Text(
                    "Delivery 20–35 min",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Change",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            // Offer Cards Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOfferCard(
                    color: Colors.purple.shade100,
                    text: "5% off\nMin. order Tk 50.",
                  ),
                  _buildOfferCard(
                    color: Colors.red.shade100,
                    text: "Tk 160 off (BX)\nMin. order Tk 459.",
                  ),
                  _buildOfferCard(
                    color: Colors.grey.shade200,
                    text: "Other offers\nAvailable.",
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
