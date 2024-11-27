import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/widgets.g.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).viewPadding.top + 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromRGBO(243, 244, 246, 1),
            ),
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: SearchBar(
              backgroundColor: const WidgetStatePropertyAll(Color.fromRGBO(243, 244, 246, 1)),
              textStyle: WidgetStatePropertyAll(
                GoogleFonts.inter(
                  color: const Color(0xff9CA3AF),
                  fontSize: 14,
                ),
              ),
              elevation: const WidgetStatePropertyAll(0),
              hintText: " Search...",
              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
              constraints: const BoxConstraints(maxHeight: 50),
              leading: const Icon(
                Icons.search,
                color: Color(0xff9CA3AF),
              ),
              shape: const WidgetStatePropertyAll(LinearBorder.none),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/bg-decoration.png'),
                fit: BoxFit.contain,
                alignment: Alignment(-1, -1),
              ),
              color: const Color(0xff4F928A),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  offset: Offset(0, 0),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/female-doctor.png'),
                  fit: BoxFit.contain,
                  alignment: Alignment(0.8, -1),
                ),
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.dmSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              color: const Color(0xffffffff),
                            ),
                            children: [
                              TextSpan(
                                text: 'Hello\n',
                                style: GoogleFonts.dmSans(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  height: 1.04,
                                  color: const Color(0xffffffff),
                                ),
                              ),
                              TextSpan(
                                text: getGreeting(),
                                style: GoogleFonts.dmSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  height: 1.6,
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8, top: 0),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "You have 16 new patient \nreports to evaluate ",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox()
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Create New Report',
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                color: const Color.fromRGBO(0, 0, 0, 1),
                fontSize: 20,
                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(3, 3),
                      blurRadius: 5,
                      spreadRadius: 0,
                      color: Color(0x1a000000),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/sinusitis.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Text(
                        'Sinusitis Identification',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.inter(
                          color: const Color.fromRGBO(75, 85, 99, 1),
                          fontSize: 14,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Our Services',
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                color: const Color.fromRGBO(0, 0, 0, 1),
                fontSize: 20,
                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 4, right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              // childAspectRatio: width/height
              childAspectRatio: (MediaQuery.of(context).size.width / 2) / 170,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                ButtonCard(
                  title: "Patients",
                  count: "200 Patients",
                  asset: "assets/images/learning.png",
                  onPressed: () async {
                    // await pushScreen(
                    //   context,
                    //   screen: Sinusitis(),
                    //   withNavBar: true,
                    //   pageTransitionAnimation: PageTransitionAnimation.scale,
                    // );
                  },
                ),
                const ButtonCard(
                  title: "Reports",
                  count: "15 reports",
                  asset: "assets/images/tools.png",
                ),
                const ButtonCard(
                  title: "Hospitals",
                  count: "42 Hospitals",
                  asset: "assets/images/action.png",
                ),
                const ButtonCard(
                  title: "Contact Us",
                  count: "24hr Support",
                  asset: "assets/images/agent.png",
                ),
              ],
            ),
          ),
          const SizedBox(height: 60)
        ],
      ),
    );
  }
}
