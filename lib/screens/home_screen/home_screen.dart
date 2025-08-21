import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/notification_screen/notification_screen.dart';

enum CutoutSide { topLeft, topRight, bottomLeft, bottomRight }

class CurvedCard extends StatelessWidget {
  final String title;
  final String count;
  final TextAlign titleAlign;
  final Color startColor;
  final Color endColor;
  final CutoutSide cutoutSide;
  final bool reverseOrder;

  const CurvedCard({
    super.key,
    required this.title,
    required this.count,
    required this.titleAlign,
    required this.startColor,
    required this.endColor,
    required this.cutoutSide,
    this.reverseOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Text(
        count,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        title,
        textAlign: titleAlign,
        style: const TextStyle(fontSize: 12, color: Colors.black87),
      ),
    ];

    if (!reverseOrder) {
      children = children.reversed.toList(); // title on top
    }

    return SizedBox(
      width: 140,
      height: 130,
      child: CustomPaint(
        painter: CardShapePainter(cutoutSide, startColor, endColor),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: titleAlign == TextAlign.left
                ? CrossAxisAlignment.start
                : titleAlign == TextAlign.right
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            children: children,
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
          const Radius.circular(16),
        ),
      );

    Path cutout = Path();
    switch (cutoutSide) {
      case CutoutSide.topLeft:
        cutout.addOval(Rect.fromCircle(center: const Offset(0, 0), radius: 70));
        break;
      case CutoutSide.topRight:
        cutout.addOval(
          Rect.fromCircle(center: Offset(size.width, 0), radius: 70),
        );
        break;
      case CutoutSide.bottomLeft:
        cutout.addOval(
          Rect.fromCircle(center: Offset(0, size.height), radius: 70),
        );
        break;
      case CutoutSide.bottomRight:
        cutout.addOval(
          Rect.fromCircle(center: Offset(size.width, size.height), radius: 70),
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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF002D96),
        statusBarIconBrightness: Brightness.light,
      ),
    );

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
                      padding: const EdgeInsets.only(
                        top: 45,
                        left: 12,
                        right: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: 52,
                            height: 52,
                          ),
                          Column(
                            children: [
                              Text(
                                'बांधकाम विभाग ',
                                style: GoogleFonts.inter(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'वर्क क्वालिटी मॉनिटरिंग सिस्टिम',
                                style: GoogleFonts.inter(
                                  fontSize: 17,
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
                                  icon: const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    "1",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
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
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(12),
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
                          const CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(
                              "assets/images/logo.png",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "अधिकारी: श्री.जितेंद्र पवार",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "पदनाम : कनिष्ठ अभियंता",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Dashboard Layout
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
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
                                          MainAxisAlignment.center,
                                      children: [
                                        CurvedCard(
                                          title: "व्हिसिट केलेल्या साइट",
                                          count: "$visitedSites",
                                          startColor: const Color(0xFFE3D7FF),
                                          endColor: const Color(0xFFBFA4F9),
                                          cutoutSide: CutoutSide.bottomRight,
                                          titleAlign: TextAlign.left,
                                        ),
                                        const SizedBox(width: 10),
                                        CurvedCard(
                                          title: "पेंडिंग साइट",
                                          count: "$pendingSites",
                                          startColor: const Color(0xFFE6F0FF),
                                          endColor: const Color(0xFFBBD6FF),
                                          cutoutSide: CutoutSide.bottomLeft,
                                          titleAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Second row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CurvedCard(
                                          title: "विलंबित कामे",
                                          count: "$delayedWorks",
                                          startColor: const Color(0xFFFFF3D6),
                                          endColor: const Color(0xFFFFD280),
                                          cutoutSide: CutoutSide.topRight,
                                          titleAlign: TextAlign.left,
                                          reverseOrder: true,
                                        ),
                                        const SizedBox(width: 10),
                                        CurvedCard(
                                          title: "रिजेक्टेड साइट",
                                          count: "$rejectedSites",
                                          startColor: const Color(0xFFFFD6D6),
                                          endColor: const Color(0xFFFF9E9E),
                                          cutoutSide: CutoutSide.topLeft,
                                          titleAlign: TextAlign.right,
                                          reverseOrder: true,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Center Circle with Gradient
                                GestureDetector(
                                  onTap: () =>
                                      _updateCompleted(completedProjects + 1),
                                  child: Container(
                                    width: 140,
                                    height: 140,
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
                                          Text(
                                            "$completedProjects",
                                            style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "पूर्ण झालेले \nप्रकल्प",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Map
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/map.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
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
