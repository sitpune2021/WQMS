import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workqualitymonitoringsystem/constants/color_constants.dart';
import 'package:workqualitymonitoringsystem/screens/report_screen/report_screen.dart';

class SiteInspectionForm extends StatefulWidget {
  const SiteInspectionForm({super.key});

  @override
  State<SiteInspectionForm> createState() => _SiteInspectionFormState();
}

class _SiteInspectionFormState extends State<SiteInspectionForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  String? uploadedPhoto;
  String? uploadedVideo;

  /// 🔹 This will hold dynamic work data fetched from API
  Map<String, dynamic>? workData;

  @override
  void initState() {
    super.initState();
    _fetchWorkDetails(); // API call simulation
  }

  /// 🔹 Mock API fetch (replace with real API later)
  Future<void> _fetchWorkDetails() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay
    setState(() {
      workData = {
        "workName":
            "नायगाव भानुदास खेळे वस्ती ते नायगाव सासवड सुपा रस्ता करणे", // from API
      };
    });
  }

  /// 🔹 Submit to API later
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        "workName": workData?["workName"],
        "details": _detailsController.text,
        "remark": _remarkController.text,
        "photo": uploadedPhoto,
        "video": uploadedVideo,
      };

      debugPrint("Submitted Data: $requestData");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ReportScreen()),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("जतन केले")));

      // TODO: send requestData to API using http/dio
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Responsive sizes
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorConstants.backScreenColor),
        child: Column(
          children: [
            // 🔹 Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: screenWidth * 0.05,
                      color: ColorConstants.iconColor,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    "स्थळ पाहणी",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.apptitleColor,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 White container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: workData == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        ) // Loader until API data
                      : SingleChildScrollView(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Work Name from API
                                Text(
                                  "कामाचे नाव : ${workData!["workName"]}",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),

                                // तपशील
                                Text(
                                  'तपशील ',
                                  style: GoogleFonts.inter(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                TextFormField(
                                  controller: _detailsController,
                                  decoration: const InputDecoration(
                                    labelText: "तपशील",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (val) => val == null || val.isEmpty
                                      ? "तपशील भरा"
                                      : null,
                                ),
                                SizedBox(height: screenHeight * 0.02),

                                // शेरा
                                Text(
                                  'शेरा ',
                                  style: GoogleFonts.inter(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                TextFormField(
                                  controller: _remarkController,
                                  decoration: const InputDecoration(
                                    labelText: "शेरा",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (val) => val == null || val.isEmpty
                                      ? "शेरा भरा"
                                      : null,
                                ),
                                // SizedBox(height: screenHeight * 0.02),

                                // फोटो
                                // Text(
                                //   'कामाचा फोटो ',
                                //   style: GoogleFonts.inter(
                                //     fontSize: screenWidth * 0.035,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                //  SizedBox(height: screenHeight * 0.01),
                                // InkWell(
                                //   onTap: () {
                                //     setState(() {
                                //       uploadedPhoto = "photo.jpg";
                                //     });
                                //   },
                                //   child: Container(
                                //     padding: const EdgeInsets.all(14),
                                //     decoration: BoxDecoration(
                                //       border: Border.all(
                                //         color: Colors.grey.shade400,
                                //       ),
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //     child: Row(
                                //       children: [
                                //         // const Icon(
                                //         //   RemixIcons.upload_2_line,
                                //         //   color: Colors.grey,
                                //         // ),
                                //         // const SizedBox(width: 8),
                                //         // Text("फोटो टाका"),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                SizedBox(height: screenHeight * 0.02),

                                // व्हिडिओ
                                // Text(
                                //   'कामाचा व्हिडिओ ',
                                //   style: GoogleFonts.inter(
                                //     fontSize: screenWidth * 0.035,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                SizedBox(height: screenHeight * 0.01),

                                // InkWell(
                                //   onTap: () {
                                //     setState(() {
                                //       uploadedVideo = "video.mp4";
                                //     });
                                //   },
                                //   child: Container(
                                //     padding: const EdgeInsets.all(14),
                                //     decoration: BoxDecoration(
                                //       border: Border.all(
                                //         color: Colors.grey.shade400,
                                //       ),
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //     child: Row(
                                //       children: [
                                //         const Icon(
                                //           RemixIcons.upload_2_line,
                                //           color: Colors.grey,
                                //         ),
                                //         const SizedBox(width: 8),
                                //         Text("व्हिडिओ टाका"),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                SizedBox(height: screenHeight * 0.03),

                                // Save button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorConstants.buttonColor,
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: _submitForm,
                                    child: Text(
                                      "जतन करा",
                                      style: GoogleFonts.inter(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.buttonTxtColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
