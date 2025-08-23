import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/log_update/logupdate_screen.dart';

class LogViewScreen extends StatefulWidget {
  const LogViewScreen({super.key});

  @override
  State<LogViewScreen> createState() => _LogViewScreenState();
}

class _LogViewScreenState extends State<LogViewScreen> {
  final TextEditingController searchController = TextEditingController();
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
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: ColorConstants.backScreenColor),
          child: Column(
            children: [
              SizedBox(height: height * 0.015),

              // 🔙 Back + Title
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    'लॉग',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Stack(
                  children: [
                    // White container with list
                    Padding(
                      padding: EdgeInsets.only(
                        top:
                            height *
                            0.05, // lower to make space for floating bar
                        left: width * 0.03,
                        right: width * 0.03,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            top:
                                height *
                                0.08, // reduced so list starts near search
                            left: width * 0.03,
                            right: width * 0.03,
                            bottom: width * 0.03,
                          ),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return _buildLogCard(width, height);
                          },
                        ),
                      ),
                    ),

                    // Floating Search Bar (overlapping container top)
                    Positioned(
                      top: 10,
                      left: width * 0.03,
                      right: width * 0.03,
                      child: Container(
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          color: _isFocused ? Colors.white : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isFocused
                                ? Colors.teal
                                : Colors.teal.shade300,
                            width: 1.3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.search, color: Colors.black54),
                            ),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                focusNode: _focusNode,
                                decoration: const InputDecoration(
                                  hintText: "शोधा",
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontSize: width * 0.038,
                                  color: Colors.black87,
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
            ],
          ),
        ),
      ),
    );
  }

  /// 📝 Card Widget
  Widget _buildLogCard(double width, double height) {
    double fontSize = width * 0.04;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.all(width * 0.035),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // कामाचे नाव
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "कामाचे नाव : ",
                style: GoogleFonts.inter(fontSize: fontSize),
              ),
              Expanded(
                child: Text(
                  "नागापूर भाऊसाहेब खेबे वस्ती ते नागापूर सातवाड सुपा रोड रस्ता",
                  style: GoogleFonts.inter(fontSize: fontSize * 0.95),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.008),

          // तपशील
          Text("तपशील", style: GoogleFonts.inter(fontSize: fontSize)),
          SizedBox(height: height * 0.004),
          TextFormField(
            maxLines: 2,
            style: GoogleFonts.inter(fontSize: fontSize * 0.95),
            decoration: InputDecoration(
              hintText: "60% काम पूर्ण, सिमेंटचा दर्जा चांगला आहे",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.all(width * 0.025),
            ),
          ),
          SizedBox(height: height * 0.012),

          // शेरा
          Text("शेरा", style: GoogleFonts.inter(fontSize: fontSize)),
          SizedBox(height: height * 0.004),
          TextFormField(
            maxLines: 2,
            style: GoogleFonts.inter(fontSize: fontSize * 0.95),
            decoration: InputDecoration(
              hintText: "पावसामुळे काम तात्पुरते थांबवावे लागले.",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.all(width * 0.025),
            ),
          ),
          SizedBox(height: height * 0.015),

          // बटण
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LogUpdateScreen(logData: {}),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.07,
                  vertical: height * 0.01,
                ),
              ),
              child: Text(
                "व्हीव्यू",
                style: GoogleFonts.inter(
                  fontSize: fontSize * 0.8,
                  color: ColorConstants.apptitleColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
