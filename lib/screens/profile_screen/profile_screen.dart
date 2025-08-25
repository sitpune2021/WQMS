import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/Login_screen/login_screen.dart';
import 'package:workqualitymonitoringsystem/screens/Site%20Inspection/Site%20Inspection.dart';
import 'package:workqualitymonitoringsystem/screens/report_screen/report_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String designation = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "Guest";
      log("$name");
      designation = prefs.getString('userDesignation') ?? "Not Available";
      log("$designation");
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: ColorConstants.statubarColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.backScreenColor),
        child: Column(
          children: [
            /// 🔹 AppBar Section
            Container(
              padding: EdgeInsets.only(
                top: height * 0.08,
                bottom: height * 0.015,
                left: width * 0.04,
              ),
              child: Row(
                children: [
                  // IconButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   icon: Icon(
                  //     Icons.arrow_back_ios_new,
                  //     color: ColorConstants.apptitleColor,
                  //     size: width * 0.05,
                  //   ),
                  // ),
                  SizedBox(width: width * 0.025),
                  Text(
                    "प्रोफाइल",
                    style: GoogleFonts.inter(
                      fontSize: width * 0.045,
                      color: ColorConstants.apptitleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔹 Profile Content
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  /// White Rounded Container
                  Container(
                    margin: EdgeInsets.only(
                      top: height * 0.08,
                      left: width * 0.03,
                      right: width * 0.03,
                    ),
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(width * 0.03),
                        topRight: Radius.circular(width * 0.03),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.08), // Avatar space
                        Text(
                          " नाव      :  $name",
                          style: GoogleFonts.inter(fontSize: width * 0.04),
                        ),
                        SizedBox(height: height * 0.005),
                        Text(
                          "पदनाम   :   $designation",
                          style: GoogleFonts.inter(fontSize: width * 0.04),
                        ),
                        SizedBox(height: height * 0.02),

                        /// Options List
                        Expanded(
                          child: ListView(
                            children: [
                              _buildOptionTileWithoutIcon(
                                "रिपोर्ट",
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReportScreen(),
                                  ),
                                ),
                                width,
                              ),
                              _buildOptionTileWithoutIcon(
                                "सेटीन्ग्स",
                                () {},
                                width,
                              ),
                              _buildOptionTileWithIcon(
                                icon: Remix.logout_box_r_line,
                                title: "लॉग आउट",
                                onTap: () =>
                                    showLogOutDialog(context, width, height),
                                width: width,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Circle Avatar
                  CircleAvatar(
                    radius: width * 0.12,
                    backgroundColor: ColorConstants.statubarColor,
                    child: Icon(
                      RemixIcons.user_3_fill,
                      size: width * 0.12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTileWithoutIcon(
    String title,
    VoidCallback onTap,
    double width,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: width * 0.015),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(width * 0.02),
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildOptionTileWithIcon({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double width,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: width * 0.015),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(width * 0.02),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87, size: width * 0.06),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> showLogOutDialog(
    BuildContext context,
    double width,
    double height,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.04),
          ),
          child: Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout,
                  size: width * 0.12,
                  color: ColorConstants.iconColor,
                ),
                SizedBox(height: height * 0.015),
                Text(
                  "तुम्हाला खात्री आहे का की \nतुम्ही लॉगआउट करू इच्छिता",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.03),

                /// Logout Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.iconColor,
                    minimumSize: Size(double.infinity, height * 0.065),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                  ),
                  onPressed: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.clear();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 200),
                        reverseDuration: const Duration(milliseconds: 200),
                        child: const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "लॉग आऊट",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.045,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.015),

                /// Cancel Button
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ColorConstants.iconColor),
                    minimumSize: Size(double.infinity, height * 0.065),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "बाहेर पडा",
                    style: TextStyle(
                      color: ColorConstants.iconColor,
                      fontSize: width * 0.045,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
