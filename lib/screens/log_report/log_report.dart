import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/logView_Screen/logview_screen.dart';
import 'package:workqualitymonitoringsystem/screens/log_update/logupdate_screen.dart';

class LogReportScreen extends StatefulWidget {
  const LogReportScreen({super.key});

  @override
  State<LogReportScreen> createState() => _LogReportScreenState();
}

class _LogReportScreenState extends State<LogReportScreen> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // Status bar style
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );

    return Scaffold(
      body: Container(
        // Gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7F9), Color(0xFF00B3A4)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.06),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: Row(
                children: [
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.arrow_back_ios_new,
                  //     color: ColorConstants.apptitleColor,
                  //     size: width * 0.055,
                  //   ),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                  Text(
                    ' लॉग ',
                    style: GoogleFonts.inter(
                      fontSize: width * 0.055,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.apptitleColor,
                    ),
                  ),
                ],
              ),
            ),

            // White container with floating search bar
            Expanded(
              child: Stack(
                children: [
                  // White rounded container
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.1,
                      left: 10,
                      right: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(width * 0.02),
                          topRight: Radius.circular(width * 0.02),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LogViewScreen(),
                              ),
                            );
                          },
                          child: ListView.builder(
                            itemCount:
                                6, // Replace with your report list length
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: height * 0.015),
                                padding: EdgeInsets.all(width * 0.03),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.circular(
                                    width * 0.025,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "रिपोर्ट क्रमांक : ${index + 1}",
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.008),
                                    Text(
                                      "कामाचे नाव : उदाहरण कामाचे नाव येथे दाखवा",
                                      style: TextStyle(
                                        fontSize: width * 0.038,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.004),
                                    Text(
                                      "तारीख : 15-08-2025",
                                      style: TextStyle(
                                        fontSize: width * 0.036,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Floating search bar (on top of white container)
                  Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: height * 0.055,
                        width: width * .94,
                        margin: EdgeInsets.symmetric(horizontal: width * 0.03),
                        decoration: BoxDecoration(
                          color: _isFocused
                              ? Colors.white
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(width * 0.016),
                          border: Border.all(color: Colors.teal, width: 2),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(Icons.search, color: Colors.black54),
                            ),
                            Expanded(
                              child: TextField(
                                focusNode: _focusNode,
                                decoration: const InputDecoration(
                                  hintText: "शोधा",
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
