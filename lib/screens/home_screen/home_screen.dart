import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/notification_screen/notification_screen.dart';
import 'package:workqualitymonitoringsystem/screens/yojna_list/yojna_list.dart';

enum CutoutSide { topLeft, topRight, bottomLeft, bottomRight }

class CurvedCard extends StatelessWidget {
  final String title;
  final String count;
  final TextAlign titleAlign;
  final Color startColor;
  final Color endColor;
  // final Color? leftColor;
  // final Color? rightColor;
  final Color countColor;
  final Color titleColor;
  final CutoutSide cutoutSide;
  final bool reverseOrder;
  final double gap;

  const CurvedCard({
    super.key,
    required this.title,
    required this.count,
    required this.titleAlign,
    required this.startColor,
    required this.endColor,
    required this.cutoutSide,
    // this.rightColor,
    this.reverseOrder = false,
    required this.countColor,
    required this.titleColor,
    this.gap = 25,
    // this.leftColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.42; // ~42% of screen width
    final cardHeight = size.height * 0.18; // ~18% of screen height

    final countWidget = Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Text(
        count,
        style: GoogleFonts.inter(
          fontSize: size.width * 0.065, // responsive
          color: countColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    SizedBox(height: gap);
    final titleWidget = Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Text(
        title,
        textAlign: titleAlign,
        style: GoogleFonts.inter(
          fontSize: size.width * 0.045,
          color: titleColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: CustomPaint(
        painter: CardShapePainter(cutoutSide, startColor, endColor),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: titleAlign == TextAlign.left
                ? CrossAxisAlignment.start
                : titleAlign == TextAlign.right
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            children: reverseOrder
                ? [titleWidget, SizedBox(height: gap), countWidget]
                : [countWidget, SizedBox(height: gap), titleWidget],
          ),
        ),
      ),
    );
  }
}

class CardShapePainter extends CustomPainter {
  final CutoutSide cutoutSide;
  final Color startColor;
  final Color endColor;

  CardShapePainter(this.cutoutSide, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [startColor, endColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path rect = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(12),
        ),
      );

    Path cutout = Path();
    switch (cutoutSide) {
      case CutoutSide.topLeft:
        cutout.addOval(Rect.fromCircle(center: const Offset(0, 0), radius: 80));
        break;
      case CutoutSide.topRight:
        cutout.addOval(
          Rect.fromCircle(center: Offset(size.width, 0), radius: 80),
        );
        break;
      case CutoutSide.bottomLeft:
        cutout.addOval(
          Rect.fromCircle(center: Offset(0, size.height), radius: 80),
        );
        break;
      case CutoutSide.bottomRight:
        cutout.addOval(
          Rect.fromCircle(center: Offset(size.width, size.height), radius: 80),
        );
        break;
    }

    Path finalPath = Path.combine(PathOperation.difference, rect, cutout);
    canvas.drawPath(finalPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int completedProjects = 0;
  int visitedSites = 3;
  int pendingSites = 1;
  int delayedWorks = 1;
  int rejectedSites = 0;
  String? name = "";
  String? designation = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      completedProjects = prefs.getInt("completedProjects") ?? 10;
      visitedSites = prefs.getInt("visitedSites") ?? 3;
      pendingSites = prefs.getInt("pendingSites") ?? 1;
      delayedWorks = prefs.getInt("delayedWorks") ?? 1;
      rejectedSites = prefs.getInt("rejectedSites") ?? 0;
    });
  }

  Future<void> _updateCompleted(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("completedProjects", value);
    setState(() => completedProjects = value);
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? " ";
      designation = prefs.getString('userDesignation') ?? " ";
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.backScreenColor),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.06,
                        left: size.width * 0.03,
                        right: size.width * 0.03,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: size.width * 0.15,
                            height: size.width * 0.15,
                          ),
                          Column(
                            children: [
                              Text(
                                'बांधकाम विभाग',
                                style: GoogleFonts.inter(
                                  fontSize: size.width * 0.05,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'वर्क क्वालिटी मॉनिटरिंग सिस्टिम',
                                style: GoogleFonts.inter(
                                  fontSize: size.width * 0.05,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorConstants.iconColor,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: const NotificationScreen(),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: size.width * 0.08,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: size.width * .02,
                                top: size.height * .010,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFFFF0C0C),
                                  radius: size.width * .02,
                                  child: Text(
                                    "1",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Officer card
                    Container(
                      margin: EdgeInsets.all(size.width * 0.04),
                      padding: EdgeInsets.all(size.width * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: size.width * 0.06,
                            backgroundImage: const AssetImage(
                              "assets/images/logo.png",
                            ),
                          ),
                          SizedBox(width: size.width * 0.08),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (name != null && name!.trim().isNotEmpty)
                                Row(
                                  children: [
                                    Text(
                                      "अधिकारी: ",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: size.width * 0.04,
                                      ),
                                    ),
                                    Text(
                                      "$name",
                                      style: GoogleFonts.poppins(
                                        fontSize: size.width * 0.04,
                                        // fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              if (designation != null &&
                                  designation!.trim().isNotEmpty)
                                Row(
                                  children: [
                                    Text(
                                      "पदनाम : ",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: size.width * 0.035,
                                      ),
                                    ),
                                    Text(
                                      "$designation",
                                      style: GoogleFonts.poppins(
                                        fontSize: size.width * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Dashboard Layout
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.025,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  children: [
                                    // First row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => YojnaList(),
                                              ),
                                            );
                                          },
                                          child: CurvedCard(
                                            title: "व्हिसिट केलेल्या \nसाइट",
                                            count: "$visitedSites",
                                            startColor: const Color(0xFFC8B0FF),
                                            endColor: const Color(0xFFFEFE9FF),
                                            cutoutSide: CutoutSide.bottomRight,
                                            titleAlign: TextAlign.left,
                                            countColor: const Color(0xFF3800B9),
                                            titleColor: const Color(0xFF3800B9),
                                            reverseOrder: true,
                                            //gap: 5.0,
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.03),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => YojnaList(),
                                              ),
                                            );
                                          },
                                          child: CurvedCard(
                                            title: "पेंडिंग साइट\n",
                                            count: "$pendingSites",
                                            startColor: const Color(0xFFF4F9FF),
                                            //leftColor: const Color(0xFFF4F9FF),
                                            endColor: const Color(0xFFB6D7FF),
                                            cutoutSide: CutoutSide.bottomLeft,
                                            titleAlign: TextAlign.right,
                                            countColor: const Color(0xFF0B4890),
                                            titleColor: const Color(0xFF0B4890),
                                            reverseOrder: true,
                                            //gap: 5.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.015),
                                    // Second row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => YojnaList(),
                                              ),
                                            );
                                          },
                                          child: CurvedCard(
                                            gap: 12.0,
                                            title: "\nविलंबित कामे",
                                            count: "$delayedWorks",
                                            startColor: const Color(0xFFFFFBF5),
                                            endColor: const Color(0xFFFFD5A2),
                                            // rightColor: const Color(0xFFFFFBF6),
                                            cutoutSide: CutoutSide.topRight,
                                            titleAlign: TextAlign.left,
                                            reverseOrder: false,
                                            countColor: const Color(0xFFF38300),
                                            titleColor: const Color(0xFFF38300),
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.03),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => YojnaList(),
                                              ),
                                            );
                                          },
                                          child: CurvedCard(
                                            title: "\nरिजेक्टेड साइट",
                                            count: "$rejectedSites",
                                            startColor: const Color(
                                              0xFFFFFB0AE,
                                            ),
                                            endColor: const Color(0xFFFFFEBEA),
                                            // rightColor: Color(0xFFFFFEBEA),
                                            cutoutSide: CutoutSide.topLeft,
                                            titleAlign: TextAlign.right,
                                            reverseOrder: false,
                                            countColor: const Color(0xFFCA160E),
                                            titleColor: const Color(0xFFCA160E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Center Circle
                                Container(
                                  width: size.width * 0.42,
                                  height: size.width * 0.46,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFBFFFD5),
                                        Color(0xFF7CE2A6),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    border: Border.all(
                                      color: Color(0xFF009A42),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: const Color(
                                            0xFFFD5FCE6,
                                          ),
                                          radius: size.width * 0.06,
                                          child: Text(
                                            "10",
                                            style: GoogleFonts.inter(
                                              fontSize: size.width * 0.05,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFF006C2E),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.008),
                                        Text(
                                          "पूर्ण झालेले \nप्रकल्प",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            fontSize: size.width * 0.05,
                                            color: const Color(0xFFF006C2E),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.025),
                            // Map
                            Container(
                              height: size.height * 0.22,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/map.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
